-- Clean up ALL biometric_measurements policies and create correct ones
-- Remove all existing policies first
DROP POLICY IF EXISTS "Allow authenticated read access" ON public.biometric_measurements;
DROP POLICY IF EXISTS "Allow authenticated insert access" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_select_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_insert_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_update_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_delete_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "biometric_measurements_service_role_policy" ON public.biometric_measurements;

-- Create simplified policies that avoid the UUID casting issue
-- These policies check ownership through batch_biometrics table

-- SELECT: Allow authenticated users to see measurements from their own biometrics
CREATE POLICY "measurements_select_policy"
ON public.biometric_measurements FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE batch_biometrics.id = biometric_measurements.biometric_id
      AND (select auth.uid()) = batch_biometrics.created_by
  )
);

-- INSERT: Allow authenticated users to add measurements to their own biometrics
CREATE POLICY "measurements_insert_policy"
ON public.biometric_measurements FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE batch_biometrics.id = biometric_measurements.biometric_id
      AND (select auth.uid()) = batch_biometrics.created_by
  )
);

-- UPDATE: Allow authenticated users to update measurements from their own biometrics
CREATE POLICY "measurements_update_policy"
ON public.biometric_measurements FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE batch_biometrics.id = biometric_measurements.biometric_id
      AND (select auth.uid()) = batch_biometrics.created_by
  )
);

-- DELETE: Allow authenticated users to delete measurements from their own biometrics
CREATE POLICY "measurements_delete_policy"
ON public.biometric_measurements FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE batch_biometrics.id = biometric_measurements.biometric_id
      AND (select auth.uid()) = batch_biometrics.created_by
  )
);

-- Service role can do everything (for admin operations)
CREATE POLICY "measurements_service_role_policy"
ON public.biometric_measurements
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- Verify RLS is enabled
ALTER TABLE public.biometric_measurements ENABLE ROW LEVEL SECURITY;

-- Log the changes
DO $$
BEGIN
  RAISE NOTICE '✅ Cleaned up and recreated biometric_measurements RLS policies';
  RAISE NOTICE '   - Removed all old policies including duplicates';
  RAISE NOTICE '   - Created simplified policies without UUID casting issues';
  RAISE NOTICE '   - All policies use wrapped auth.uid() for performance';
  RAISE NOTICE '   - Policies check ownership through batch_biometrics table';
END $$;
