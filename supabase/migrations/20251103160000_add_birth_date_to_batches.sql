-- Add birth_date column to batches table
ALTER TABLE batches 
ADD COLUMN IF NOT EXISTS birth_date DATE;

-- Add entry_date column to batches table (if it doesn't exist)
ALTER TABLE batches 
ADD COLUMN IF NOT EXISTS entry_date TIMESTAMP WITH TIME ZONE;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_batches_birth_date ON batches(birth_date);

-- Add comment to explain the column
COMMENT ON COLUMN batches.birth_date IS 'Birth date of the animals in the batch. Used for age calculation and progress tracking.';
COMMENT ON COLUMN batches.entry_date IS 'Date when the batch entered the facility. Falls back to created_at if not set.';
