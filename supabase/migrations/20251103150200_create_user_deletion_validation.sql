-- =====================================================
-- Migración 3: Validación de Eliminación de Usuarios
-- =====================================================
-- Fecha: 2025-11-03
-- Descripción: Crear función para validar que un usuario puede ser eliminado
--              según la regla de negocio: "Un usuario no podrá ser eliminado
--              si tiene datos asociados en las tablas diferentes a auth.users
--              y public.profiles"
-- Impacto: CERO - Solo crea función de validación, no bloquea nada aún
-- Reversible: Sí - DROP FUNCTION

-- =====================================================
-- FUNCIÓN DE VALIDACIÓN DE ELIMINACIÓN
-- =====================================================

-- -----------------------------------------------------
-- Función: can_delete_user
-- Verifica si un usuario puede ser eliminado
-- Retorna: TRUE si el usuario NO tiene datos asociados
--          FALSE si el usuario TIENE datos asociados
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.can_delete_user(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
DECLARE
  has_corrals BOOLEAN;
  has_batches BOOLEAN;
  has_animals BOOLEAN;
  has_events BOOLEAN;
  has_biometrics BOOLEAN;
BEGIN
  -- Verificar si el usuario tiene corrales creados
  SELECT EXISTS (
    SELECT 1 FROM public.corrals
    WHERE created_by = user_uuid
  ) INTO has_corrals;

  -- Verificar si el usuario tiene batches (vía corrales)
  SELECT EXISTS (
    SELECT 1 FROM public.batches b
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE c.created_by = user_uuid
  ) INTO has_batches;

  -- Verificar si el usuario tiene animales (vía batches -> corrales)
  SELECT EXISTS (
    SELECT 1 FROM public.animals a
    INNER JOIN public.batches b ON a.batch_id = b.id
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE c.created_by = user_uuid
  ) INTO has_animals;

  -- Verificar si el usuario tiene eventos (vía animales -> batches -> corrales)
  SELECT EXISTS (
    SELECT 1 FROM public.animal_events ae
    INNER JOIN public.animals a ON ae.animal_id = a.id
    INNER JOIN public.batches b ON a.batch_id = b.id
    INNER JOIN public.corrals c ON b.corral_id = c.id
    WHERE c.created_by = user_uuid
  ) INTO has_events;

  -- Verificar si el usuario tiene biometrías creadas
  SELECT EXISTS (
    SELECT 1 FROM public.batch_biometrics
    WHERE created_by = user_uuid
  ) INTO has_biometrics;

  -- El usuario PUEDE ser eliminado solo si NO tiene datos asociados
  RETURN NOT (has_corrals OR has_batches OR has_animals OR has_events OR has_biometrics);
END;
$$;

COMMENT ON FUNCTION public.can_delete_user(UUID) IS
'Valida si un usuario puede ser eliminado. Retorna TRUE solo si el usuario NO tiene datos asociados (corrales, batches, animales, eventos, biometrías). Usado para prevenir eliminación accidental de datos.';

-- -----------------------------------------------------
-- Función: get_user_data_summary
-- Retorna resumen de datos asociados a un usuario
-- Útil para mostrar al admin antes de intentar eliminar
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_user_data_summary(user_uuid UUID)
RETURNS TABLE(
  has_data BOOLEAN,
  corrals_count INTEGER,
  batches_count INTEGER,
  animals_count INTEGER,
  events_count INTEGER,
  biometrics_count INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN QUERY
  SELECT
    -- TRUE si tiene algún dato
    (
      (SELECT COUNT(*) FROM public.corrals WHERE created_by = user_uuid) > 0 OR
      (SELECT COUNT(*) FROM public.batch_biometrics WHERE created_by = user_uuid) > 0
    ) as has_data,
    -- Contar corrales
    (SELECT COUNT(*)::INTEGER FROM public.corrals WHERE created_by = user_uuid) as corrals_count,
    -- Contar batches (vía corrales)
    (SELECT COUNT(*)::INTEGER FROM public.batches b
     INNER JOIN public.corrals c ON b.corral_id = c.id
     WHERE c.created_by = user_uuid) as batches_count,
    -- Contar animales (vía batches -> corrales)
    (SELECT COUNT(*)::INTEGER FROM public.animals a
     INNER JOIN public.batches b ON a.batch_id = b.id
     INNER JOIN public.corrals c ON b.corral_id = c.id
     WHERE c.created_by = user_uuid) as animals_count,
    -- Contar eventos (vía animales -> batches -> corrales)
    (SELECT COUNT(*)::INTEGER FROM public.animal_events ae
     INNER JOIN public.animals a ON ae.animal_id = a.id
     INNER JOIN public.batches b ON a.batch_id = b.id
     INNER JOIN public.corrals c ON b.corral_id = c.id
     WHERE c.created_by = user_uuid) as events_count,
    -- Contar biometrías
    (SELECT COUNT(*)::INTEGER FROM public.batch_biometrics WHERE created_by = user_uuid) as biometrics_count;
END;
$$;

COMMENT ON FUNCTION public.get_user_data_summary(UUID) IS
'Retorna resumen detallado de datos asociados a un usuario: corrales, batches, animales, eventos y biometrías. Útil para mostrar al admin antes de intentar eliminar un usuario.';

-- =====================================================
-- PERMISOS Y SEGURIDAD
-- =====================================================

-- Solo admins pueden verificar si un usuario puede ser eliminado
GRANT EXECUTE ON FUNCTION public.can_delete_user(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_data_summary(UUID) TO authenticated;

-- Service role tiene acceso completo
GRANT EXECUTE ON FUNCTION public.can_delete_user(UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.get_user_data_summary(UUID) TO service_role;

-- =====================================================
-- EJEMPLOS DE USO
-- =====================================================
/*
-- Verificar si un usuario puede ser eliminado:
SELECT can_delete_user('uuid-del-usuario');

-- Obtener resumen de datos del usuario:
SELECT * FROM get_user_data_summary('uuid-del-usuario');

-- Ejemplo de resultado:
-- has_data | corrals_count | batches_count | animals_count | events_count | biometrics_count
-- ---------+---------------+---------------+---------------+--------------+-----------------
--    true  |       2       |       3       |      21       |      0       |        1
*/

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
DO $$
BEGIN
  RAISE NOTICE 'Funciones de validación de eliminación creadas:';
  RAISE NOTICE '- can_delete_user(UUID) -> BOOLEAN';
  RAISE NOTICE '- get_user_data_summary(UUID) -> TABLE';
  RAISE NOTICE 'Estas funciones permiten validar antes de eliminar usuarios';
END $$;
