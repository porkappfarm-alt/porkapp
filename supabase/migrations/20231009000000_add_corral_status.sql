-- Create an enum type for corral status
CREATE TYPE corral_status AS ENUM ('disponible', 'ocupado', 'mantenimiento');

-- Add status column to corrals table
ALTER TABLE corrals 
ADD COLUMN status corral_status NOT NULL DEFAULT 'disponible';

-- Create a function to update corral status based on active batches
CREATE OR REPLACE FUNCTION update_corral_status()
RETURNS TRIGGER AS $$
BEGIN
    -- If a batch is being created or updated
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        -- If the batch is active, set corral status to 'ocupado'
        IF NEW.status = 'active' THEN
            -- Only update if corral is not in maintenance
            UPDATE corrals 
            SET status = 'ocupado'
            WHERE id = NEW.corral_id 
            AND status != 'mantenimiento';
        END IF;

        -- If batch status changed from active to something else
        IF TG_OP = 'UPDATE' AND OLD.status = 'active' AND NEW.status != 'active' THEN
            -- Check if there are any other active batches for this corral
            IF NOT EXISTS (
                SELECT 1 FROM batches 
                WHERE corral_id = NEW.corral_id 
                AND status = 'active'
                AND id != NEW.id
            ) THEN
                -- If no other active batches, set corral to 'disponible'
                -- Only update if corral is not in maintenance
                UPDATE corrals 
                SET status = 'disponible'
                WHERE id = NEW.corral_id
                AND status != 'mantenimiento';
            END IF;
        END IF;
    END IF;

    -- If a batch is being deleted
    IF TG_OP = 'DELETE' THEN
        -- If the deleted batch was active
        IF OLD.status = 'active' THEN
            -- Check if there are any other active batches for this corral
            IF NOT EXISTS (
                SELECT 1 FROM batches 
                WHERE corral_id = OLD.corral_id 
                AND status = 'active'
                AND id != OLD.id
            ) THEN
                -- If no other active batches, set corral to 'disponible'
                -- Only update if corral is not in maintenance
                UPDATE corrals 
                SET status = 'disponible'
                WHERE id = OLD.corral_id
                AND status != 'mantenimiento';
            END IF;
        END IF;
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update corral status
DROP TRIGGER IF EXISTS update_corral_status_trigger ON batches;
CREATE TRIGGER update_corral_status_trigger
AFTER INSERT OR UPDATE OR DELETE ON batches
FOR EACH ROW
EXECUTE FUNCTION update_corral_status();

-- Create a function to validate batch creation/update
CREATE OR REPLACE FUNCTION validate_batch_corral()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if corral exists and is available
    IF EXISTS (
        SELECT 1 FROM corrals 
        WHERE id = NEW.corral_id 
        AND status = 'mantenimiento'
    ) THEN
        RAISE EXCEPTION 'No se pueden agregar lotes a un corral en mantenimiento';
    END IF;

    -- Check if there's already an active batch in this corral
    IF NEW.status = 'active' AND EXISTS (
        SELECT 1 FROM batches 
        WHERE corral_id = NEW.corral_id 
        AND status = 'active'
        AND id != NEW.id
    ) THEN
        RAISE EXCEPTION 'Ya existe un lote activo en este corral';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to validate batch operations
DROP TRIGGER IF EXISTS validate_batch_corral_trigger ON batches;
CREATE TRIGGER validate_batch_corral_trigger
BEFORE INSERT OR UPDATE ON batches
FOR EACH ROW
EXECUTE FUNCTION validate_batch_corral();

-- Update initial corral statuses based on existing batches
UPDATE corrals c
SET status = 'ocupado'
WHERE EXISTS (
    SELECT 1 FROM batches b
    WHERE b.corral_id = c.id
    AND b.status = 'active'
)
AND c.status != 'mantenimiento';