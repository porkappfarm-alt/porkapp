-- =====================================================
-- Migración 2: Funciones Helper para RLS
-- =====================================================
-- Fecha: 2025-11-03
-- Descripción: Crear funciones SECURITY DEFINER para optimizar políticas RLS
--              Estas funciones se ejecutan con privilegios elevados, evitando
--              recursión de RLS en tablas relacionadas.
-- Impacto: CERO - Solo crea funciones, no afecta acceso actual
-- Reversible: Sí - DROP FUNCTION

-- =====================================================
-- FUNCIONES HELPER PARA RLS
-- =====================================================

-- -----------------------------------------------------
-- 1. Función: is_corral_owner
-- Verifica si el usuario actual es propietario de un corral
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_corral_owner(corral_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER -- Ejecuta con privilegios del creador, evita RLS en corrals
STABLE -- Resultado no cambia durante la transacción
AS $$
BEGIN
  -- Verificar si el usuario autenticado es el creador del corral
  RETURN EXISTS (
    SELECT 1
    FROM public.corrals
    WHERE id = corral_uuid
      AND created_by = auth.uid()
  );
END;
$$;

-- Comentario descriptivo
COMMENT ON FUNCTION public.is_corral_owner(UUID) IS
'Verifica si el usuario autenticado (auth.uid()) es propietario del corral especificado. Usado en políticas RLS.';

-- -----------------------------------------------------
-- 2. Función: is_batch_owner
-- Verifica si el usuario es propietario del batch (vía corral)
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_batch_owner(batch_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  -- Verificar si el usuario es propietario del corral al que pertenece el batch
  RETURN EXISTS (
    SELECT 1
    FROM public.batches b
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE b.id = batch_uuid
      AND c.created_by = auth.uid()
  );
END;
$$;

COMMENT ON FUNCTION public.is_batch_owner(UUID) IS
'Verifica si el usuario autenticado es propietario del batch (heredado del corral). Usado en políticas RLS.';

-- -----------------------------------------------------
-- 3. Función: is_animal_owner
-- Verifica si el usuario es propietario del animal (vía batch -> corral)
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_animal_owner(animal_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  -- Verificar si el usuario es propietario del corral del batch del animal
  RETURN EXISTS (
    SELECT 1
    FROM public.animals a
    INNER JOIN public.batches b ON a.batch_id = b.id
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE a.id = animal_uuid
      AND c.created_by = auth.uid()
  );
END;
$$;

COMMENT ON FUNCTION public.is_animal_owner(UUID) IS
'Verifica si el usuario autenticado es propietario del animal (heredado de batch -> corral). Usado en políticas RLS.';

-- -----------------------------------------------------
-- 4. Función: get_user_corrals
-- Retorna array de UUIDs de corrales del usuario actual
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_user_corrals()
RETURNS UUID[]
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  -- Retornar array de IDs de corrales del usuario autenticado
  RETURN ARRAY(
    SELECT id
    FROM public.corrals
    WHERE created_by = auth.uid()
  );
END;
$$;

COMMENT ON FUNCTION public.get_user_corrals() IS
'Retorna un array de UUIDs de todos los corrales propiedad del usuario autenticado. Optimiza políticas RLS con IN/ANY.';

-- -----------------------------------------------------
-- 5. Función: get_user_batches
-- Retorna array de UUIDs de batches del usuario (vía corrals)
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_user_batches()
RETURNS UUID[]
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  -- Retornar array de IDs de batches cuyos corrales pertenecen al usuario
  RETURN ARRAY(
    SELECT b.id
    FROM public.batches b
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE c.created_by = auth.uid()
  );
END;
$$;

COMMENT ON FUNCTION public.get_user_batches() IS
'Retorna un array de UUIDs de todos los batches del usuario (vía propiedad de corrals). Optimiza políticas RLS.';

-- -----------------------------------------------------
-- 6. Función: get_user_animals
-- Retorna array de UUIDs de animales del usuario (vía batches -> corrals)
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_user_animals()
RETURNS UUID[]
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  -- Retornar array de IDs de animales cuyos batches pertenecen al usuario
  RETURN ARRAY(
    SELECT a.id
    FROM public.animals a
    INNER JOIN public.batches b ON a.batch_id = b.id
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE c.created_by = auth.uid()
  );
END;
$$;

COMMENT ON FUNCTION public.get_user_animals() IS
'Retorna un array de UUIDs de todos los animales del usuario (vía batches -> corrals). Optimiza políticas RLS.';

-- =====================================================
-- PERMISOS Y SEGURIDAD
-- =====================================================

-- Otorgar permisos de ejecución a roles autenticados
GRANT EXECUTE ON FUNCTION public.is_corral_owner(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_batch_owner(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_animal_owner(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_corrals() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_batches() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_animals() TO authenticated;

-- Service role tiene acceso completo (para bypass de RLS)
GRANT EXECUTE ON FUNCTION public.is_corral_owner(UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.is_batch_owner(UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.is_animal_owner(UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.get_user_corrals() TO service_role;
GRANT EXECUTE ON FUNCTION public.get_user_batches() TO service_role;
GRANT EXECUTE ON FUNCTION public.get_user_animals() TO service_role;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
DO $$
BEGIN
  RAISE NOTICE 'Funciones helper RLS creadas exitosamente:';
  RAISE NOTICE '- is_corral_owner(UUID)';
  RAISE NOTICE '- is_batch_owner(UUID)';
  RAISE NOTICE '- is_animal_owner(UUID)';
  RAISE NOTICE '- get_user_corrals()';
  RAISE NOTICE '- get_user_batches()';
  RAISE NOTICE '- get_user_animals()';
  RAISE NOTICE 'Total: 6 funciones SECURITY DEFINER para optimización RLS';
END $$;
