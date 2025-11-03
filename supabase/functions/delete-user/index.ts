import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface DeleteUserRequest {
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
    const body: DeleteUserRequest = await req.json();
    const { userId } = body;

    if (!userId) {
      throw new Error("Missing required field: userId");
    }

    // Prevent admin from deleting themselves
    if (userId === user.id) {
      throw new Error("Cannot delete your own account");
    }

    // Create admin client with SERVICE_ROLE key
    const supabaseAdmin = createClient(Deno.env.get("SUPABASE_URL") ?? "", Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "", {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    // Delete from database first using RPC function
    const { data: rpcResult, error: rpcError } = await supabaseAdmin.rpc("delete_user_account", {
      p_user_id: userId,
    });

    if (rpcError) {
      console.error("Error deleting user from database:", rpcError);
      throw rpcError;
    }

    if (!rpcResult || !rpcResult.success) {
      throw new Error(rpcResult?.message || "Failed to delete user from database");
    }

    // Delete from auth.users
    const { error: authError } = await supabaseAdmin.auth.admin.deleteUser(userId);

    if (authError) {
      console.error("Error deleting user from auth:", authError);
      throw authError;
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: "User deleted successfully",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("Error in delete-user function:", error);
    return new Response(
      JSON.stringify({
        error: error.message || "Internal server error",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      }
    );
  }
});
