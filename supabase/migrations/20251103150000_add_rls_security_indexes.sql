-- =====================================================
-- Migración 1: Índices de Optimización para RLS
-- =====================================================
-- Fecha: 2025-11-03
-- Descripción: Crear índices en columnas utilizadas en políticas RLS
--              para optimizar el rendimiento de las queries con RLS habilitado.
-- Impacto: CERO - Solo mejora performance, no afecta acceso
-- Reversible: Sí - DROP INDEX

-- =====================================================
-- ÍNDICES PARA OPTIMIZACIÓN DE RLS
-- =====================================================

-- Índice en corrals.created_by (base de la jerarquía multi-tenant)
-- Usado en: Todas las políticas RLS de corrals
CREATE INDEX IF NOT EXISTS idx_corrals_created_by
ON public.corrals(created_by)
TABLESPACE pg_default;

-- Índice en corrals.updated_by (para auditoría)
CREATE INDEX IF NOT EXISTS idx_corrals_updated_by
ON public.corrals(updated_by)
TABLESPACE pg_default;

-- Índice en batches.corral_id (relación jerárquica)
-- Usado en: Políticas RLS que verifican propiedad vía corral
CREATE INDEX IF NOT EXISTS idx_batches_corral_id
ON public.batches(corral_id)
TABLESPACE pg_default;

-- Índice en animals.batch_id (relación jerárquica)
-- Usado en: Políticas RLS que verifican propiedad vía batch
CREATE INDEX IF NOT EXISTS idx_animals_batch_id
ON public.animals(batch_id)
TABLESPACE pg_default;

-- Índice en animal_events.animal_id (relación jerárquica)
-- Usado en: Políticas RLS que verifican propiedad vía animal
CREATE INDEX IF NOT EXISTS idx_animal_events_animal_id
ON public.animal_events(animal_id)
TABLESPACE pg_default;

-- Índice en animal_events.batch_id (relación directa con batch)
-- Usado en: Consultas que filtran eventos por batch
CREATE INDEX IF NOT EXISTS idx_animal_events_batch_id
ON public.animal_events(batch_id)
TABLESPACE pg_default;

-- Índice en batch_biometrics.created_by (propiedad directa)
-- Usado en: Políticas RLS de batch_biometrics
CREATE INDEX IF NOT EXISTS idx_batch_biometrics_created_by
ON public.batch_biometrics(created_by)
TABLESPACE pg_default;

-- Índice en batch_biometrics.batch_id (relación con batch)
-- Usado en: Políticas que verifican propiedad vía batch
CREATE INDEX IF NOT EXISTS idx_batch_biometrics_batch_id
ON public.batch_biometrics(batch_id)
TABLESPACE pg_default;

-- Índice en biometric_measurements.biometric_id (relación con batch_biometrics)
-- Usado en: Políticas RLS que heredan propiedad de batch_biometrics
CREATE INDEX IF NOT EXISTS idx_biometric_measurements_biometric_id
ON public.biometric_measurements(biometric_id)
TABLESPACE pg_default;

-- Índice en biometric_measurements.animal_id (relación directa)
-- Usado en: Consultas que filtran mediciones por animal
CREATE INDEX IF NOT EXISTS idx_biometric_measurements_animal_id
ON public.biometric_measurements(animal_id)
TABLESPACE pg_default;

-- Índice en profiles.id (usado en is_admin y verificaciones de usuario)
-- Mejora performance de auth.uid() = id
CREATE INDEX IF NOT EXISTS idx_profiles_id
ON public.profiles(id)
TABLESPACE pg_default;

-- Índice en profiles.role (usado en is_admin function)
-- Optimiza búsqueda de admins
CREATE INDEX IF NOT EXISTS idx_profiles_role
ON public.profiles(role)
TABLESPACE pg_default;

-- =====================================================
-- VERIFICACIÓN
-- =====================================================
-- Listar todos los índices creados
DO $$
BEGIN
  RAISE NOTICE 'Índices RLS creados exitosamente:';
  RAISE NOTICE '- idx_corrals_created_by';
  RAISE NOTICE '- idx_corrals_updated_by';
  RAISE NOTICE '- idx_batches_corral_id';
  RAISE NOTICE '- idx_animals_batch_id';
  RAISE NOTICE '- idx_animal_events_animal_id';
  RAISE NOTICE '- idx_animal_events_batch_id';
  RAISE NOTICE '- idx_batch_biometrics_created_by';
  RAISE NOTICE '- idx_batch_biometrics_batch_id';
  RAISE NOTICE '- idx_biometric_measurements_biometric_id';
  RAISE NOTICE '- idx_biometric_measurements_animal_id';
  RAISE NOTICE '- idx_profiles_id';
  RAISE NOTICE '- idx_profiles_role';
  RAISE NOTICE 'Total: 12 índices para optimización RLS';
END $$;
