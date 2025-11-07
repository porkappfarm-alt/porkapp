-- Fix UUID comparison in biometric_measurements RLS policies
-- The issue is that when inserting, biometric_measurements.biometric_id is being compared
-- as text instead of UUID, causing "operator does not exist: uuid = text" error

-- Drop existing policies
DROP POLICY IF EXISTS "biometric_measurements_select_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_insert_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_update_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_delete_policy" ON public.biometric_measurements;

-- Recreate SELECT policy with explicit UUID cast
CREATE POLICY "biometric_measurements_select_policy"
ON public.biometric_measurements FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id::uuid = biometric_measurements.biometric_id::uuid
      AND created_by = auth.uid()
  )
  OR (SELECT is_animal_owner(animal_id::uuid))
  OR (SELECT is_admin(auth.uid()))
);

-- Recreate INSERT policy with explicit UUID cast
CREATE POLICY "biometric_measurements_insert_policy"
ON public.biometric_measurements FOR INSERT TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id::uuid = biometric_measurements.biometric_id::uuid
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
);

-- Recreate UPDATE policy with explicit UUID cast
CREATE POLICY "biometric_measurements_update_policy"
ON public.biometric_measurements FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id::uuid = biometric_measurements.biometric_id::uuid
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
);

-- Recreate DELETE policy with explicit UUID cast
CREATE POLICY "biometric_measurements_delete_policy"
ON public.biometric_measurements FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE id::uuid = biometric_measurements.biometric_id::uuid
      AND created_by = auth.uid()
  )
  OR (SELECT is_admin(auth.uid()))
);

-- Log the changes
DO $$
BEGIN
  RAISE NOTICE '✅ Fixed biometric_measurements RLS policies with explicit UUID casts';
  RAISE NOTICE '   - biometric_measurements_select_policy: Added ::uuid casts';
  RAISE NOTICE '   - biometric_measurements_insert_policy: Added ::uuid casts';
  RAISE NOTICE '   - biometric_measurements_update_policy: Added ::uuid casts';
  RAISE NOTICE '   - biometric_measurements_delete_policy: Added ::uuid casts';
END $$;
