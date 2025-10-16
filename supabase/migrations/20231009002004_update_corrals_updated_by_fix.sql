-- Update corrals with active batches to set updated_by if null
UPDATE corrals c
SET 
    updated_by = c.created_by,
    updated_at = NOW()
WHERE c.updated_by IS NULL
  AND EXISTS (
    SELECT 1 
    FROM batches b
    WHERE b.corral_id = c.id 
    AND b.status = 'active'
  );