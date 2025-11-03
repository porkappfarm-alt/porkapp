-- Migración: add_cascade_delete_profiles
-- Fecha: 2025-11-03
-- Descripción: Agregar ON DELETE CASCADE a la FK de profiles para que al eliminar
--              un usuario de auth.users se elimine automáticamente de profiles

-- 1. Eliminar la constraint existente (sin CASCADE)
ALTER TABLE public.profiles
DROP CONSTRAINT IF EXISTS profiles_id_fkey;

-- 2. Recrear la constraint con ON DELETE CASCADE
-- Esto asegura que cuando se elimine un usuario de auth.users,
-- automáticamente se elimine su perfil en public.profiles
ALTER TABLE public.profiles
ADD CONSTRAINT profiles_id_fkey
FOREIGN KEY (id)
REFERENCES auth.users(id)
ON DELETE CASCADE;

-- 3. Crear índice para mejorar performance en eliminaciones (si no existe)
CREATE INDEX IF NOT EXISTS idx_profiles_id ON public.profiles(id);

-- Comentario explicativo
COMMENT ON CONSTRAINT profiles_id_fkey ON public.profiles IS
'Foreign key con CASCADE delete - al eliminar usuario de auth.users se elimina automáticamente su perfil';
