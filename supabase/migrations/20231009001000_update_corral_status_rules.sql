-- Definir los estados posibles para corrales
CREATE TYPE corral_status AS ENUM ('disponible', 'ocupado', 'mantenimiento');

-- Agregar campo status a la tabla corrals
ALTER TABLE corrals 
ADD COLUMN status corral_status NOT NULL DEFAULT 'disponible';

-- Función para validar operaciones en lotes
CREATE OR REPLACE FUNCTION validate_batch_operations()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que no se pueda asignar un lote a un corral en mantenimiento
    IF EXISTS (
        SELECT 1 
        FROM corrals 
        WHERE id = NEW.corral_id 
        AND status = 'mantenimiento'
    ) THEN
        RAISE EXCEPTION 'No se pueden asignar lotes a un corral en mantenimiento';
    END IF;

    -- Validar que no haya más de un lote activo por corral
    IF NEW.status = 'active' AND EXISTS (
        SELECT 1 
        FROM batches 
        WHERE corral_id = NEW.corral_id 
        AND status = 'active'
        AND id != NEW.id
    ) THEN
        RAISE EXCEPTION 'El corral ya tiene un lote activo';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar el estado del corral
CREATE OR REPLACE FUNCTION update_corral_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Si el trigger se activó por una eliminación
    IF TG_OP = 'DELETE' THEN
        -- Si el lote eliminado estaba activo, actualizar el estado del corral
        IF OLD.status = 'active' THEN
            -- Solo actualizar si no hay otros lotes activos y el corral no está en mantenimiento
            UPDATE corrals 
            SET status = 'disponible'
            WHERE id = OLD.corral_id 
            AND status != 'mantenimiento'
            AND NOT EXISTS (
                SELECT 1 
                FROM batches 
                WHERE corral_id = OLD.corral_id 
                AND status = 'active'
                AND id != OLD.id
            );
        END IF;
        RETURN OLD;
    END IF;

    -- Para inserciones o actualizaciones
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        -- Si el nuevo estado es activo
        IF NEW.status = 'active' THEN
            -- Actualizar el corral a ocupado si no está en mantenimiento
            UPDATE corrals 
            SET status = 'ocupado'
            WHERE id = NEW.corral_id 
            AND status != 'mantenimiento';
        END IF;

        -- Si se cambia de activo a finalizado
        IF TG_OP = 'UPDATE' AND OLD.status = 'active' AND NEW.status = 'finished' THEN
            -- Solo actualizar si no hay otros lotes activos y el corral no está en mantenimiento
            UPDATE corrals 
            SET status = 'disponible'
            WHERE id = NEW.corral_id 
            AND status != 'mantenimiento'
            AND NOT EXISTS (
                SELECT 1 
                FROM batches 
                WHERE corral_id = NEW.corral_id 
                AND status = 'active'
                AND id != NEW.id
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para validar operaciones antes de insertar o actualizar lotes
DROP TRIGGER IF EXISTS validate_batch_operations_trigger ON batches;
CREATE TRIGGER validate_batch_operations_trigger
    BEFORE INSERT OR UPDATE ON batches
    FOR EACH ROW
    EXECUTE FUNCTION validate_batch_operations();

-- Trigger para actualizar el estado del corral después de operaciones en lotes
DROP TRIGGER IF EXISTS update_corral_status_trigger ON batches;
CREATE TRIGGER update_corral_status_trigger
    AFTER INSERT OR UPDATE OR DELETE ON batches
    FOR EACH ROW
    EXECUTE FUNCTION update_corral_status();

-- Función para validar cambios de estado en corrales
CREATE OR REPLACE FUNCTION validate_corral_status_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Si se intenta cambiar a ocupado manualmente
    IF NEW.status = 'ocupado' AND OLD.status != 'ocupado' THEN
        RAISE EXCEPTION 'El estado "ocupado" se maneja automáticamente según los lotes activos';
    END IF;

    -- Si se intenta cambiar a mantenimiento y hay lotes activos
    IF NEW.status = 'mantenimiento' AND EXISTS (
        SELECT 1 
        FROM batches 
        WHERE corral_id = NEW.id 
        AND status = 'active'
    ) THEN
        RAISE EXCEPTION 'No se puede poner en mantenimiento un corral con lotes activos';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para validar cambios de estado en corrales
DROP TRIGGER IF EXISTS validate_corral_status_change_trigger ON corrals;
CREATE TRIGGER validate_corral_status_change_trigger
    BEFORE UPDATE ON corrals
    FOR EACH ROW
    WHEN (OLD.status IS DISTINCT FROM NEW.status)
    EXECUTE FUNCTION validate_corral_status_change();

-- Actualizar estados iniciales
UPDATE corrals c
SET status = CASE
    WHEN EXISTS (
        SELECT 1 
        FROM batches b 
        WHERE b.corral_id = c.id 
        AND b.status = 'active'
    ) THEN 'ocupado'
    ELSE 'disponible'
END
WHERE status != 'mantenimiento';