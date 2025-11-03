-- Migración: user_management_setup
-- Fecha: 2025-11-02
-- Descripción: Configuración de gestión de usuarios con columna full_name y estados actualizados

-- Eliminar constraints existentes
ALTER TABLE public.profiles
DROP CONSTRAINT IF EXISTS status_values;

ALTER TABLE public.profiles
DROP CONSTRAINT IF EXISTS profiles_status_check;

-- Actualizar status existentes
UPDATE public.profiles
SET status = 'active'
WHERE status = 'approved';

UPDATE public.profiles
SET status = 'inactive'
WHERE status = 'blocked';

-- Agregar columna full_name
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS full_name TEXT;

-- Crear nuevo constraint de status
ALTER TABLE public.profiles
ADD CONSTRAINT profiles_status_check
CHECK (status IN ('pending', 'active', 'inactive'));

-- Establecer default como 'pending'
ALTER TABLE public.profiles
ALTER COLUMN status SET DEFAULT 'pending';

-- Crear índices para mejorar consultas
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_status ON public.profiles(status);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- Función para actualizar usuario (incluye status)
CREATE OR REPLACE FUNCTION public.update_user_profile(
  p_user_id UUID,
  p_full_name TEXT DEFAULT NULL,
  p_role TEXT DEFAULT NULL,
  p_status TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_caller_id UUID;
  v_is_admin BOOLEAN;
BEGIN
  v_caller_id := auth.uid();
  v_is_admin := is_admin(v_caller_id);

  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'No tienes permisos para actualizar usuarios';
  END IF;

  -- No permitir auto-desactivación
  IF p_user_id = v_caller_id AND p_status = 'inactive' THEN
    RAISE EXCEPTION 'No puedes desactivar tu propia cuenta';
  END IF;

  -- Validar status si se proporciona
  IF p_status IS NOT NULL AND p_status NOT IN ('pending', 'active', 'inactive') THEN
    RAISE EXCEPTION 'Status inválido';
  END IF;

  -- Actualizar perfil
  UPDATE public.profiles
  SET
    full_name = COALESCE(p_full_name, full_name),
    role = COALESCE(p_role, role),
    status = COALESCE(p_status, status),
    updated_at = NOW()
  WHERE id = p_user_id;

  -- Si se actualiza el rol, actualizar también users_roles
  IF p_role IS NOT NULL THEN
    UPDATE public.users_roles
    SET role = p_role
    WHERE user_id = p_user_id;
  END IF;

  RETURN json_build_object(
    'success', true,
    'message', 'Usuario actualizado correctamente'
  );
END;
$$;

-- Función para eliminar usuario
CREATE OR REPLACE FUNCTION public.delete_user_account(
  p_user_id UUID
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_caller_id UUID;
  v_is_admin BOOLEAN;
BEGIN
  v_caller_id := auth.uid();
  v_is_admin := is_admin(v_caller_id);

  IF NOT v_is_admin THEN
    RAISE EXCEPTION 'No tienes permisos para eliminar usuarios';
  END IF;

  -- No permitir auto-eliminación
  IF p_user_id = v_caller_id THEN
    RAISE EXCEPTION 'No puedes eliminar tu propia cuenta';
  END IF;

  -- Eliminar de users_roles
  DELETE FROM public.users_roles WHERE user_id = p_user_id;

  -- Eliminar perfil
  DELETE FROM public.profiles WHERE id = p_user_id;

  RETURN json_build_object(
    'success', true,
    'message', 'Usuario eliminado correctamente'
  );
END;
$$;

-- Eliminar políticas RLS existentes
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can update profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can insert profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can delete profiles" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;

-- Habilitar RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Políticas RLS

-- Los usuarios pueden ver su propio perfil
CREATE POLICY "Users can view own profile"
ON public.profiles FOR SELECT
TO authenticated
USING (id = auth.uid());

-- Los admins pueden ver todos los perfiles
CREATE POLICY "Admins can view all profiles"
ON public.profiles FOR SELECT
TO authenticated
USING (is_admin(auth.uid()));

-- Los admins pueden actualizar perfiles
CREATE POLICY "Admins can update profiles"
ON public.profiles FOR UPDATE
TO authenticated
USING (is_admin(auth.uid()));

-- Los admins pueden insertar perfiles
CREATE POLICY "Admins can insert profiles"
ON public.profiles FOR INSERT
TO authenticated
WITH CHECK (is_admin(auth.uid()));

-- Los admins pueden eliminar perfiles (excepto el propio)
CREATE POLICY "Admins can delete profiles"
ON public.profiles FOR DELETE
TO authenticated
USING (is_admin(auth.uid()) AND id != auth.uid());
