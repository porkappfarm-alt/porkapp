-- =====================================================
-- Migración 6-10: RLS Multi-Tenant Jerárquico Completo
-- =====================================================
-- Fecha: 2025-11-03
-- Descripción: Implementar políticas RLS multi-tenant en todas las tablas
-- Impacto: ALTO - Implementa multi-tenancy real
-- Reversible: Sí - Restaurar políticas anteriores

-- =====================================================
-- TABLA: CORRALS (Base de la Jerarquía Multi-Tenant)
-- =====================================================

-- Eliminar políticas antiguas
DROP POLICY IF EXISTS "Users can view their own corrals" ON public.corrals;
DROP POLICY IF EXISTS "Users can insert their own corrals" ON public.corrals;
DROP POLICY IF EXISTS "Users can update their own corrals" ON public.corrals;
DROP POLICY IF EXISTS "Users can delete their own corrals" ON public.corrals;
DROP POLICY IF EXISTS "Enable all users to update corrals" ON public.corrals;

-- SELECT
CREATE POLICY "corrals_select_policy"
ON public.corrals FOR SELECT TO authenticated
USING (created_by = auth.uid() OR (SELECT is_admin(auth.uid())));

-- INSERT
CREATE POLICY "corrals_insert_policy"
ON public.corrals FOR INSERT TO authenticated
WITH CHECK (created_by = auth.uid() OR (SELECT is_admin(auth.uid())));

-- UPDATE
CREATE POLICY "corrals_update_policy"
ON public.corrals FOR UPDATE TO authenticated
USING (created_by = auth.uid() OR (SELECT is_admin(auth.uid())))
WITH CHECK (created_by = auth.uid() OR (SELECT is_admin(auth.uid())));

-- DELETE
CREATE POLICY "corrals_delete_policy"
ON public.corrals FOR DELETE TO authenticated
USING (created_by = auth.uid() OR (SELECT is_admin(auth.uid())));

-- Service role bypass
CREATE POLICY "corrals_service_role_policy"
ON public.corrals FOR ALL TO service_role
USING (true) WITH CHECK (true);

-- =====================================================
-- TABLA: BATCHES
-- =====================================================

DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.batches;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.batches;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.batches;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.batches;
DROP POLICY IF EXISTS "Users can view batches" ON public.batches;
DROP POLICY IF EXISTS "Users can insert batches" ON public.batches;
DROP POLICY IF EXISTS "Users can update batches" ON public.batches;

-- SELECT: batches de corrales propios
CREATE POLICY "batches_select_policy"
ON public.batches FOR SELECT TO authenticated
USING (
  (SELECT is_corral_owner(corral_id))
  OR (SELECT is_admin(auth.uid()))
);

-- INSERT: en corrales propios
CREATE POLICY "batches_insert_policy"
ON public.batches FOR INSERT TO authenticated
WITH CHECK (
  (SELECT is_corral_owner(corral_id))
  OR (SELECT is_admin(auth.uid()))
);

-- UPDATE: batches de corrales propios
CREATE POLICY "batches_update_policy"
ON public.batches FOR UPDATE TO authenticated
USING (
  (SELECT is_corral_owner(corral_id))
  OR (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  (SELECT is_corral_owner(corral_id))
  OR (SELECT is_admin(auth.uid()))
);

-- DELETE: batches de corrales propios
CREATE POLICY "batches_delete_policy"
ON public.batches FOR DELETE TO authenticated
USING (
  (SELECT is_corral_owner(corral_id))
  OR (SELECT is_admin(auth.uid()))
);

-- Service role bypass
CREATE POLICY "batches_service_role_policy"
ON public.batches FOR ALL TO service_role
USING (true) WITH CHECK (true);

-- =====================================================
-- TABLA: ANIMALS
-- =====================================================

DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.animals;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.animals;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.animals;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.animals;
DROP POLICY IF EXISTS "Users can view animals" ON public.animals;
DROP POLICY IF EXISTS "Users can insert animals" ON public.animals;
DROP POLICY IF EXISTS "Users can update animals" ON public.animals;

-- SELECT: animals de batches propios
CREATE POLICY "animals_select_policy"
ON public.animals FOR SELECT TO authenticated
USING (
  (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
);

-- INSERT: en batches propios
CREATE POLICY "animals_insert_policy"
ON public.animals FOR INSERT TO authenticated
WITH CHECK (
  (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
);

-- UPDATE: animals de batches propios
CREATE POLICY "animals_update_policy"
ON public.animals FOR UPDATE TO authenticated
USING (
  (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
);

-- DELETE: animals de batches propios
CREATE POLICY "animals_delete_policy"
ON public.animals FOR DELETE TO authenticated
USING (
  (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
);

-- Service role bypass
CREATE POLICY "animals_service_role_policy"
ON public.animals FOR ALL TO service_role
USING (true) WITH CHECK (true);

-- =====================================================
-- TABLA: ANIMAL_EVENTS
-- =====================================================

DROP POLICY IF EXISTS "select_policy" ON public.animal_events;
DROP POLICY IF EXISTS "insert_policy" ON public.animal_events;
DROP POLICY IF EXISTS "update_policy" ON public.animal_events;
DROP POLICY IF EXISTS "delete_policy" ON public.animal_events;

-- SELECT: eventos de animals propios
CREATE POLICY "animal_events_select_policy"
ON public.animal_events FOR SELECT TO authenticated
USING (
  (SELECT is_animal_owner(animal_id))
  OR (SELECT is_admin(auth.uid()))
);

-- INSERT: en animals propios
CREATE POLICY "animal_events_insert_policy"
ON public.animal_events FOR INSERT TO authenticated
WITH CHECK (
  (SELECT is_animal_owner(animal_id))
  OR (SELECT is_admin(auth.uid()))
);

-- UPDATE: eventos de animals propios
CREATE POLICY "animal_events_update_policy"
ON public.animal_events FOR UPDATE TO authenticated
USING (
  (SELECT is_animal_owner(animal_id))
  OR (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  (SELECT is_animal_owner(animal_id))
  OR (SELECT is_admin(auth.uid()))
);

-- DELETE: eventos de animals propios
CREATE POLICY "animal_events_delete_policy"
ON public.animal_events FOR DELETE TO authenticated
USING (
  (SELECT is_animal_owner(animal_id))
  OR (SELECT is_admin(auth.uid()))
);

-- Service role bypass
CREATE POLICY "animal_events_service_role_policy"
ON public.animal_events FOR ALL TO service_role
USING (true) WITH CHECK (true);

-- =====================================================
-- TABLA: BATCH_BIOMETRICS
-- =====================================================

DROP POLICY IF EXISTS "Usuarios autenticados pueden ver biometrías" ON public.batch_biometrics;
DROP POLICY IF EXISTS "Usuarios autenticados pueden crear biometrías" ON public.batch_biometrics;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar sus biometrías" ON public.batch_biometrics;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar sus biometrías" ON public.batch_biometrics;

-- SELECT: biometrías propias o de batches propios
CREATE POLICY "batch_biometrics_select_policy"
ON public.batch_biometrics FOR SELECT TO authenticated
USING (
  created_by = auth.uid()
  OR (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
);

-- INSERT: en batches propios
CREATE POLICY "batch_biometrics_insert_policy"
ON public.batch_biometrics FOR INSERT TO authenticated
WITH CHECK (
  (SELECT is_batch_owner(batch_id))
  OR (SELECT is_admin(auth.uid()))
);

-- UPDATE: biometrías propias
CREATE POLICY "batch_biometrics_update_policy"
ON public.batch_biometrics FOR UPDATE TO authenticated
USING (
  created_by = auth.uid()
  OR (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  created_by = auth.uid()
  OR (SELECT is_admin(auth.uid()))
);

-- DELETE: biometrías propias
CREATE POLICY "batch_biometrics_delete_policy"
ON public.batch_biometrics FOR DELETE TO authenticated
USING (
  created_by = auth.uid()
  OR (SELECT is_admin(auth.uid()))
);

-- Service role bypass
CREATE POLICY "batch_biometrics_service_role_policy"
ON public.batch_biometrics FOR ALL TO service_role
USING (true) WITH CHECK (true);

-- =====================================================
-- TABLA: BIOMETRIC_MEASUREMENTS
-- =====================================================

DROP POLICY IF EXISTS "Usuarios autenticados pueden ver mediciones" ON public.biometric_measurements;
DROP POLICY IF EXISTS "Usuarios autenticados pueden crear mediciones" ON public.biometric_measurements;
DROP POLICY IF EXISTS "Usuarios autenticados pueden actualizar sus mediciones" ON public.biometric_measurements;
DROP POLICY IF EXISTS "Usuarios autenticados pueden eliminar sus mediciones" ON public.biometric_measurements;

-- SELECT: mediciones de biometrías propias o animals propios
CREATE POLICY "biometric_measurements_select_policy"
ON public.biometric_measurements FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id = biometric_measurements.biometric_id
      AND created_by = auth.uid()
  )
  OR (SELECT is_animal_owner(animal_id))
  OR (SELECT is_admin(auth.uid()))
);

-- INSERT: en biometrías propias
CREATE POLICY "biometric_measurements_insert_policy"
ON public.biometric_measurements FOR INSERT TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id = biometric_measurements.biometric_id
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
);

-- UPDATE: mediciones de biometrías propias
CREATE POLICY "biometric_measurements_update_policy"
ON public.biometric_measurements FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id = biometric_measurements.biometric_id
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id = biometric_measurements.biometric_id
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
);

-- DELETE: mediciones de biometrías propias
CREATE POLICY "biometric_measurements_delete_policy"
ON public.biometric_measurements FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id = biometric_measurements.biometric_id
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
);

-- Service role bypass
CREATE POLICY "biometric_measurements_service_role_policy"
ON public.biometric_measurements FOR ALL TO service_role
USING (true) WITH CHECK (true);
