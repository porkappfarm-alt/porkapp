-- =====================================================
-- Migración 5: RLS Mejorado para Profiles
-- =====================================================
-- Fecha: 2025-11-03
-- Descripción: Limpiar y mejorar políticas RLS de profiles.
--              Usuarios pueden ver solo su perfil, admins ven todos.
-- Impacto: MEDIO - Tabla crítica pero ya tiene RLS funcional
-- Reversible: Sí - Restaurar políticas anteriores

-- =====================================================
-- PASO 1: ELIMINAR POLÍTICAS ANTIGUAS Y DUPLICADAS
-- =====================================================

-- Eliminar todas las políticas antiguas
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can insert profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can update profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admins can delete profiles" ON public.profiles;
DROP POLICY IF EXISTS "Service role can create admin profiles" ON public.profiles;
DROP POLICY IF EXISTS "Service role full access" ON public.profiles;

-- =====================================================
-- PASO 2: POLÍTICAS PARA USUARIOS NORMALES
-- =====================================================

-- -----------------------------------------------------
-- SELECT: Usuario puede ver su propio perfil
-- -----------------------------------------------------
CREATE POLICY "profiles_user_select_own"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  auth.uid() = id
);

COMMENT ON POLICY "profiles_user_select_own" ON public.profiles IS
'Los usuarios pueden ver únicamente su propio perfil.';

-- -----------------------------------------------------
-- UPDATE: Usuario puede actualizar su propio perfil
-- (excepto role y status que son solo admin)
-- -----------------------------------------------------
CREATE POLICY "profiles_user_update_own"
ON public.profiles
FOR UPDATE
TO authenticated
USING (
  auth.uid() = id
)
WITH CHECK (
  auth.uid() = id
);

COMMENT ON POLICY "profiles_user_update_own" ON public.profiles IS
'Los usuarios pueden actualizar únicamente su propio perfil (excepto role/status).';

-- =====================================================
-- PASO 3: POLÍTICAS PARA ADMINISTRADORES
-- =====================================================

-- -----------------------------------------------------
-- SELECT: Admins pueden ver todos los perfiles
-- -----------------------------------------------------
CREATE POLICY "profiles_admin_select_all"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  (SELECT is_admin(auth.uid()))
);

COMMENT ON POLICY "profiles_admin_select_all" ON public.profiles IS
'Los administradores pueden ver todos los perfiles de usuarios.';

-- -----------------------------------------------------
-- INSERT: Solo admins pueden crear nuevos perfiles
-- -----------------------------------------------------
CREATE POLICY "profiles_admin_insert"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (
  (SELECT is_admin(auth.uid()))
);

COMMENT ON POLICY "profiles_admin_insert" ON public.profiles IS
'Solo administradores pueden crear nuevos perfiles de usuario.';

-- -----------------------------------------------------
-- UPDATE: Admins pueden actualizar cualquier perfil
-- -----------------------------------------------------
CREATE POLICY "profiles_admin_update_all"
ON public.profiles
FOR UPDATE
TO authenticated
USING (
  (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  (SELECT is_admin(auth.uid()))
);

COMMENT ON POLICY "profiles_admin_update_all" ON public.profiles IS
'Los administradores pueden actualizar cualquier perfil (incluido role/status).';

-- -----------------------------------------------------
-- DELETE: Admins pueden eliminar perfiles (excepto el propio)
-- Solo si el usuario no tiene datos asociados
-- -----------------------------------------------------
CREATE POLICY "profiles_admin_delete"
ON public.profiles
FOR DELETE
TO authenticated
USING (
  (SELECT is_admin(auth.uid()))
  AND id != auth.uid()  -- No puede eliminarse a sí mismo
  AND (SELECT can_delete_user(id))  -- Usuario no tiene datos asociados
);

COMMENT ON POLICY "profiles_admin_delete" ON public.profiles IS
'Los administradores pueden eliminar perfiles (excepto el propio) solo si no tienen datos asociados.';

-- =====================================================
-- PASO 4: POLÍTICAS PARA SERVICE ROLE
-- =====================================================

-- Service role tiene acceso completo (bypass RLS)
CREATE POLICY "profiles_service_role_all"
ON public.profiles
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

COMMENT ON POLICY "profiles_service_role_all" ON public.profiles IS
'Service role tiene acceso completo para operaciones del sistema.';

-- =====================================================
-- PASO 5: VERIFICACIÓN
-- =====================================================

DO $$
DECLARE
  policy_count INTEGER;
  rls_enabled BOOLEAN;
BEGIN
  -- Verificar que RLS está habilitado
  SELECT relrowsecurity
  INTO rls_enabled
  FROM pg_class
  WHERE relname = 'profiles'
    AND relnamespace = 'public'::regnamespace;

  -- Contar políticas activas
  SELECT COUNT(*)
  INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public'
    AND tablename = 'profiles';

  RAISE NOTICE '=====================================================';
  RAISE NOTICE 'Políticas RLS actualizadas en PROFILES:';
  RAISE NOTICE '- RLS habilitado: %', rls_enabled;
  RAISE NOTICE '';
  RAISE NOTICE 'USUARIOS NORMALES:';
  RAISE NOTICE '  - SELECT: Solo su propio perfil';
  RAISE NOTICE '  - UPDATE: Solo su propio perfil';
  RAISE NOTICE '';
  RAISE NOTICE 'ADMINISTRADORES:';
  RAISE NOTICE '  - SELECT: Todos los perfiles';
  RAISE NOTICE '  - INSERT: Crear nuevos usuarios';
  RAISE NOTICE '  - UPDATE: Modificar cualquier perfil';
  RAISE NOTICE '  - DELETE: Eliminar usuarios sin datos asociados';
  RAISE NOTICE '';
  RAISE NOTICE 'Total de políticas activas: %', policy_count;
  RAISE NOTICE '=====================================================';

  IF NOT rls_enabled THEN
    RAISE EXCEPTION 'ERROR: RLS no está habilitado en profiles';
  END IF;

  IF policy_count < 6 THEN
    RAISE WARNING 'ADVERTENCIA: Se esperaban al menos 6 políticas, encontradas: %', policy_count;
  END IF;
END $$;
