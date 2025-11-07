-- SOLUCIÓN DEFINITIVA: Crear función helper para verificar ownership
-- El problema es que WITH CHECK no puede acceder correctamente a los valores siendo insertados
-- cuando hay subqueries que intentan hacer JOIN con esos valores

-- Primero, crear una función security definer para verificar ownership de un biometric_id
CREATE OR REPLACE FUNCTION public.is_biometric_owner(biometric_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.batch_biometrics
    WHERE id = biometric_uuid
      AND created_by = auth.uid()
  );
END;
$$;

-- Comentar la función
COMMENT ON FUNCTION public.is_biometric_owner IS
'Verifica si el usuario autenticado es dueño del biometric_id especificado.
Se usa en políticas RLS para validar operaciones en biometric_measurements.';

-- Ahora eliminar todas las políticas existentes
DROP POLICY IF EXISTS "measurements_select_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "measurements_insert_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "measurements_update_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "measurements_delete_policy" ON public.biometric_measurements;
DROP POLICY IF EXISTS "measurements_service_role_policy" ON public.biometric_measurements;

-- Crear políticas usando la función helper
-- SELECT: Ver mediciones de biometrías propias
CREATE POLICY "measurements_select_policy"
ON public.biometric_measurements FOR SELECT
TO authenticated
USING (
  is_biometric_owner(biometric_id)
);

-- INSERT: Insertar mediciones solo en biometrías propias
-- CRÍTICO: En WITH CHECK, biometric_id es el valor siendo insertado (aún no existe en la tabla)
-- Por eso usamos la función helper que recibe el UUID directamente
CREATE POLICY "measurements_insert_policy"
ON public.biometric_measurements FOR INSERT
TO authenticated
WITH CHECK (
  is_biometric_owner(biometric_id)
);

-- UPDATE: Actualizar solo mediciones de biometrías propias
CREATE POLICY "measurements_update_policy"
ON public.biometric_measurements FOR UPDATE
TO authenticated
USING (
  is_biometric_owner(biometric_id)
)
WITH CHECK (
  is_biometric_owner(biometric_id)
);

-- DELETE: Eliminar solo mediciones de biometrías propias
CREATE POLICY "measurements_delete_policy"
ON public.biometric_measurements FOR DELETE
TO authenticated
USING (
  is_biometric_owner(biometric_id)
);

-- Service role bypass (para operaciones administrativas)
CREATE POLICY "measurements_service_role_policy"
ON public.biometric_measurements
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- Asegurar que RLS esté habilitado
ALTER TABLE public.biometric_measurements ENABLE ROW LEVEL SECURITY;

-- Otorgar permisos de ejecución a la función
GRANT EXECUTE ON FUNCTION public.is_biometric_owner(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_biometric_owner(UUID) TO service_role;

-- Log
DO $$
BEGIN
  RAISE NOTICE '✅ SOLUCIÓN DEFINITIVA aplicada para biometric_measurements RLS';
  RAISE NOTICE '   - Creada función helper is_biometric_owner() con SECURITY DEFINER';
  RAISE NOTICE '   - Función evita problemas de UUID casting en WITH CHECK';
  RAISE NOTICE '   - Todas las políticas usan la función helper';
  RAISE NOTICE '   - WITH CHECK ahora puede evaluar correctamente valores siendo insertados';
  RAISE NOTICE '   - Permisos de ejecución otorgados a authenticated y service_role';
END $$;
