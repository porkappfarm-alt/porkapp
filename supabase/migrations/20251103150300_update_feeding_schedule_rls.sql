-- =====================================================
-- Migración 4: RLS para Feeding Schedule (Referencia Global)
-- =====================================================
-- Fecha: 2025-11-03
-- Descripción: Actualizar políticas RLS de feeding_schedule como tabla de
--              referencia global. Todos los usuarios pueden LEER, solo admins
--              pueden CREAR/ACTUALIZAR/ELIMINAR.
-- Impacto: BAJO - Tabla de referencia, solo ajusta permisos de escritura
-- Reversible: Sí - Restaurar políticas anteriores

-- =====================================================
-- PASO 1: ELIMINAR POLÍTICAS ANTIGUAS
-- =====================================================

DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.feeding_schedule;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.feeding_schedule;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.feeding_schedule;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.feeding_schedule;

-- =====================================================
-- PASO 2: CREAR NUEVAS POLÍTICAS RLS
-- =====================================================

-- -----------------------------------------------------
-- SELECT: Todos los usuarios autenticados pueden leer
-- feeding_schedule es una tabla de referencia compartida
-- -----------------------------------------------------
CREATE POLICY "feeding_schedule_select_policy"
ON public.feeding_schedule
FOR SELECT
TO authenticated
USING (true);

COMMENT ON POLICY "feeding_schedule_select_policy" ON public.feeding_schedule IS
'Permite a todos los usuarios autenticados leer el feeding_schedule. Es una tabla de referencia global.';

-- -----------------------------------------------------
-- INSERT: Solo admins pueden insertar nuevos registros
-- -----------------------------------------------------
CREATE POLICY "feeding_schedule_insert_policy"
ON public.feeding_schedule
FOR INSERT
TO authenticated
WITH CHECK (
  (SELECT is_admin(auth.uid()))
);

COMMENT ON POLICY "feeding_schedule_insert_policy" ON public.feeding_schedule IS
'Solo administradores pueden crear nuevos registros en feeding_schedule.';

-- -----------------------------------------------------
-- UPDATE: Solo admins pueden actualizar registros
-- -----------------------------------------------------
CREATE POLICY "feeding_schedule_update_policy"
ON public.feeding_schedule
FOR UPDATE
TO authenticated
USING (
  (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  (SELECT is_admin(auth.uid()))
);

COMMENT ON POLICY "feeding_schedule_update_policy" ON public.feeding_schedule IS
'Solo administradores pueden actualizar registros en feeding_schedule.';

-- -----------------------------------------------------
-- DELETE: Solo admins pueden eliminar registros
-- -----------------------------------------------------
CREATE POLICY "feeding_schedule_delete_policy"
ON public.feeding_schedule
FOR DELETE
TO authenticated
USING (
  (SELECT is_admin(auth.uid()))
);

COMMENT ON POLICY "feeding_schedule_delete_policy" ON public.feeding_schedule IS
'Solo administradores pueden eliminar registros en feeding_schedule.';

-- =====================================================
-- PASO 3: POLÍTICA PARA SERVICE ROLE (bypass RLS)
-- =====================================================

CREATE POLICY "feeding_schedule_service_role_policy"
ON public.feeding_schedule
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

COMMENT ON POLICY "feeding_schedule_service_role_policy" ON public.feeding_schedule IS
'Service role tiene acceso completo para operaciones administrativas.';

-- =====================================================
-- VERIFICACIÓN
-- =====================================================

DO $$
DECLARE
  policy_count INTEGER;
BEGIN
  -- Contar políticas en feeding_schedule
  SELECT COUNT(*)
  INTO policy_count
  FROM pg_policies
  WHERE schemaname = 'public'
    AND tablename = 'feeding_schedule';

  RAISE NOTICE '=====================================================';
  RAISE NOTICE 'Políticas RLS actualizadas en feeding_schedule:';
  RAISE NOTICE '- SELECT: Todos los usuarios autenticados (read-only)';
  RAISE NOTICE '- INSERT: Solo admins';
  RAISE NOTICE '- UPDATE: Solo admins';
  RAISE NOTICE '- DELETE: Solo admins';
  RAISE NOTICE '- SERVICE ROLE: Acceso completo';
  RAISE NOTICE 'Total de políticas activas: %', policy_count;
  RAISE NOTICE '=====================================================';
END $$;
