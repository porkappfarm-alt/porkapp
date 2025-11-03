-- Migración: fix_password_change
-- Fecha: 2025-11-03
-- Descripción: Corregir el flujo de cambio de contraseña para usuarios creados con admin.createUser()

-- 1. Corregir función update_status_on_password_change para usar 'active' en lugar de 'approved'
CREATE OR REPLACE FUNCTION public.update_status_on_password_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Actualizar el status a 'active' cuando el usuario cambia su contraseña
  UPDATE profiles
  SET
    status = 'active',
    updated_at = now()
  WHERE id = NEW.id;
  RETURN NEW;
END;
$$;

-- 2. Crear función para actualizar contraseña usando bcrypt directamente
-- Esta función es necesaria porque admin.updateUserById() tiene restricciones
-- para usuarios creados con admin.createUser()
CREATE OR REPLACE FUNCTION public.update_user_password(
  user_id UUID,
  new_password TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Actualizar contraseña en auth.users usando bcrypt
  UPDATE auth.users
  SET
    encrypted_password = crypt(new_password, gen_salt('bf')),
    updated_at = now()
  WHERE id = user_id;

  -- Actualizar metadata para indicar que ya no necesita cambiar contraseña
  UPDATE auth.users
  SET raw_user_meta_data = jsonb_set(
    COALESCE(raw_user_meta_data, '{}'::jsonb),
    '{needs_password_change}',
    'false'::jsonb
  )
  WHERE id = user_id;

  -- Actualizar perfil a activo
  UPDATE public.profiles
  SET
    status = 'active',
    temporary_password = NULL,
    updated_at = now()
  WHERE id = user_id;

  RETURN json_build_object(
    'success', true,
    'message', 'Password updated successfully'
  );
END;
$$;

-- 3. Dar permisos para que usuarios autenticados puedan ejecutar la función
GRANT EXECUTE ON FUNCTION public.update_user_password(UUID, TEXT) TO authenticated;

-- 4. Comentario explicativo
COMMENT ON FUNCTION public.update_user_password IS
'Actualiza la contraseña de un usuario usando bcrypt directamente.
Esta función se usa desde la Edge Function change-password para evitar
las restricciones de admin.updateUserById() con usuarios creados por admin.createUser().';
