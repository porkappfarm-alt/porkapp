import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface ResendInvitationRequest {
  userId: string;
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
    const body: ResendInvitationRequest = await req.json();
    const { userId } = body;

    if (!userId) {
      throw new Error("Missing required field: userId");
    }

    // Create admin client with SERVICE_ROLE key
    const supabaseAdmin = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "", {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    // Get user profile
    const { data: targetProfile, error: profileError } = await supabaseAdmin.from("profiles").select("email, status, full_name, temporary_password").eq("id", userId).single();

    if (profileError || !targetProfile) {
      throw new Error("User not found");
    }

    // Verify user is in pending status
    if (targetProfile.status !== "pending") {
      throw new Error("Only pending users can have their invitation resent");
    }

    // Verify temporary password exists
    if (!targetProfile.temporary_password) {
      throw new Error("Temporary password not found. Please create a new invitation.");
    }

    // TODO: Send email with temporary password
    // For now, just return success with the password
    console.log(`Resending invitation to: ${targetProfile.email}`);
    console.log(`Temporary password: ${targetProfile.temporary_password}`);

    return new Response(
      JSON.stringify({
        success: true,
        message: "Invitation resent successfully",
        temporaryPassword: targetProfile.temporary_password, // Return password to admin
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("Error in resend-invitation function:", error);
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
