-- Add updated_by column to corrals table
ALTER TABLE corrals 
ADD COLUMN updated_by uuid REFERENCES auth.users(id);

-- Add trigger to automatically set updated_by
CREATE OR REPLACE FUNCTION public.set_corrals_updated_by()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_by = auth.uid();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS set_corrals_updated_by_trigger ON corrals;

-- Create trigger
CREATE TRIGGER set_corrals_updated_by_trigger
  BEFORE UPDATE ON corrals
  FOR EACH ROW
  EXECUTE FUNCTION public.set_corrals_updated_by();

-- Add RLS policy for updated_by
ALTER TABLE corrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can update corrals they have access to"
ON public.corrals
FOR UPDATE
USING (
  -- Allow farm admins and owners to update
  EXISTS (
    SELECT 1 FROM user_farms uf
    WHERE uf.user_id = auth.uid()
    AND uf.farm_id = corrals.farm_id
    AND uf.role IN ('admin', 'owner')
  )
);