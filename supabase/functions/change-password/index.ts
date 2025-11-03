// Supabase Edge Function - Change Password for New Users
// This function allows users with temporary passwords to change their password

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface ChangePasswordRequest {
  newPassword: string;
}

Deno.serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Verify the user is authenticated
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      throw new Error("No authorization header");
    }

    // Extract the JWT token from the Authorization header
    const token = authHeader.replace("Bearer ", "");

    // Create Supabase client with the user's auth header
    const supabaseClient = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_ANON_KEY") ?? "", {
      global: {
        headers: { Authorization: authHeader },
      },
    });

    // Get authenticated user
    const {
      data: { user },
    } = await supabaseClient.auth.getUser(token);

    if (!user) {
      throw new Error("Not authenticated");
    }

    console.log(`Change password request from user: ${user.email}`);

    // Parse request body
    const body: ChangePasswordRequest = await req.json();
    const { newPassword } = body;

    // Validate input
    if (!newPassword || newPassword.length < 8) {
      throw new Error("Password must be at least 8 characters long");
    }

    // Validate password strength
    if (!/[a-zA-Z]/.test(newPassword)) {
      throw new Error("Password must contain at least one letter");
    }
    if (!/[0-9]/.test(newPassword)) {
      throw new Error("Password must contain at least one number");
    }

    // Create admin client with SERVICE_ROLE key
    // We'll use SQL to update the password directly since admin.updateUserById has restrictions
    const supabaseAdmin = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "", {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    // Update password directly in database using bcrypt
    // This is the only reliable method for users created with admin.createUser()
    const { error: passwordError } = await supabaseAdmin.rpc("update_user_password", {
      user_id: user.id,
      new_password: newPassword,
    });

    if (passwordError) {
      console.error("Error updating password:", passwordError);
      throw new Error(`Failed to update password: ${passwordError.message}`);
    }

    console.log(`Password updated successfully for user: ${user.email}`);

    // Update the profile status to active and clear temporary password
    const { error: profileError } = await supabaseAdmin
      .from("profiles")
      .update({
        status: "active",
        temporary_password: null,
        updated_at: new Date().toISOString(),
      })
      .eq("id", user.id);

    if (profileError) {
      console.error("Error updating profile:", profileError);
      // No lanzar error, el cambio de contraseña ya fue exitoso
    }

    console.log(`Profile updated to active for user: ${user.email}`);

    return new Response(
      JSON.stringify({
        success: true,
        message: "Password changed successfully",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("Error in change-password function:", error);
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
