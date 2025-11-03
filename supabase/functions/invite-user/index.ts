// Supabase Edge Function - Invite User
// Runtime: Deno (https://deno.land/)
// Este archivo se ejecuta en el servidor de Supabase, no en el cliente Flutter
// Los errores de linting de VS Code son normales y no afectan el funcionamiento

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface InviteUserRequest {
  email: string;
  fullName: string;
  role: "user" | "admin";
  identificationNumber: string;
  whatsappNumber: string;
}

Deno.serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Verify the user is authenticated and is an admin
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      throw new Error("No authorization header");
    }

    // Extract the JWT token from the Authorization header
    const token = authHeader.replace("Bearer ", "");

    // Create Supabase client with the auth header (user's token)
    const supabaseClient = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_ANON_KEY") ?? "", {
      global: {
        headers: { Authorization: authHeader },
      },
    });

    // Verify user is admin - pass the token explicitly to getUser()
    const {
      data: { user },
    } = await supabaseClient.auth.getUser(token);
    if (!user) {
      throw new Error("Not authenticated");
    }

    const { data: profile } = await supabaseClient.from("profiles").select("role").eq("id", user.id).single();

    if (!profile || profile.role !== "admin") {
      throw new Error("Not authorized - admin access required");
    }

    // Parse request body
    const body: InviteUserRequest = await req.json();
    const { email, fullName, role, identificationNumber, whatsappNumber } = body;

    // Validate input
    if (!email || !fullName || !role || !identificationNumber || !whatsappNumber) {
      throw new Error("Missing required fields: email, fullName, role, identificationNumber, whatsappNumber");
    }

    if (!["user", "admin"].includes(role)) {
      throw new Error('Invalid role. Must be "user" or "admin"');
    }

    // Validate identification number (only numbers)
    if (!/^\d+$/.test(identificationNumber)) {
      throw new Error("Identification number must contain only numbers");
    }

    // Validate WhatsApp number (only numbers, 10-15 digits)
    if (!/^\d{10,15}$/.test(whatsappNumber)) {
      throw new Error("WhatsApp number must be 10-15 digits");
    }

    // Create admin client with SERVICE_ROLE key
    const supabaseAdmin = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "", {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    // Use identification number as temporary password
    const tempPassword = identificationNumber;

    // Create user with temporary password (identification number)
    const { data: userData, error: createError } = await supabaseAdmin.auth.admin.createUser({
      email: email,
      password: tempPassword,
      email_confirm: true, // Auto-confirm email
      user_metadata: {
        full_name: fullName,
        needs_password_change: true, // Flag to force password change
      },
    });

    if (createError) {
      console.error("Error creating user:", createError);
      throw createError;
    }

    if (!userData.user) {
      throw new Error("User creation failed");
    }

    // Create profile in database with temporary password and new fields
    const { error: profileError } = await supabaseAdmin.from("profiles").upsert({
      id: userData.user.id,
      email: email,
      role: role,
      status: "pending",
      full_name: fullName,
      temporary_password: tempPassword, // Store for resend functionality
      identification_number: identificationNumber,
      whatsapp_number: whatsappNumber,
    });

    if (profileError) {
      console.error("Error creating profile:", profileError);
      throw profileError;
    }

    // Log success
    console.log(`User created: ${email}, Temporary password: ${tempPassword}`);

    return new Response(
      JSON.stringify({
        success: true,
        user: {
          id: userData.user.id,
          email: userData.user.email,
          role: role,
          status: "pending",
          identificationNumber: identificationNumber,
          whatsappNumber: whatsappNumber,
        },
        temporaryPassword: tempPassword, // Return password (identification number) to admin
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("Error in invite-user function:", error);
    const errorMessage = error instanceof Error ? error.message : "Internal server error";
    return new Response(
      JSON.stringify({
        error: errorMessage,
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      }
    );
  }
});
