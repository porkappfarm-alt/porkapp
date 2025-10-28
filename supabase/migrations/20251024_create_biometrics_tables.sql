-- Create biometrics schema if not exists
CREATE SCHEMA IF NOT EXISTS biometrics;

-- Create batch_measurements table
CREATE TABLE IF NOT EXISTS biometrics.batch_measurements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID REFERENCES public.batches(id) ON DELETE CASCADE,
    measurement_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    average_weight DECIMAL NOT NULL,
    animal_count INTEGER NOT NULL,
    notes TEXT,
    created_by TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status TEXT DEFAULT 'active'
);

-- Create animal_measurements table
CREATE TABLE IF NOT EXISTS biometrics.animal_measurements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_measurement_id UUID REFERENCES biometrics.batch_measurements(id) ON DELETE CASCADE,
    animal_id UUID REFERENCES public.animals(id) ON DELETE CASCADE,
    weight DECIMAL NOT NULL,
    previous_weight DECIMAL,
    weight_gain DECIMAL,
    days_since_last INTEGER,
    adg DECIMAL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_batch_measurements_batch_id ON biometrics.batch_measurements(batch_id);
CREATE INDEX IF NOT EXISTS idx_animal_measurements_batch_measurement_id ON biometrics.animal_measurements(batch_measurement_id);
CREATE INDEX IF NOT EXISTS idx_animal_measurements_animal_id ON biometrics.animal_measurements(animal_id);

-- Create view for measurements
CREATE OR REPLACE VIEW biometrics.measurements_view AS
SELECT 
    bm.*,
    b.name as batch_name,
    COUNT(am.id) as measurements_count,
    MIN(am.weight) as min_weight,
    MAX(am.weight) as max_weight,
    AVG(am.weight) as actual_average_weight
FROM biometrics.batch_measurements bm
LEFT JOIN public.batches b ON b.id = bm.batch_id
LEFT JOIN biometrics.animal_measurements am ON am.batch_measurement_id = bm.id
GROUP BY bm.id, b.name;

-- Create RLS policies
ALTER TABLE biometrics.batch_measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE biometrics.animal_measurements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable all for authenticated users" ON biometrics.batch_measurements
    FOR ALL
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Enable all for authenticated users" ON biometrics.animal_measurements
    FOR ALL
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Grant permissions
GRANT USAGE ON SCHEMA biometrics TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA biometrics TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA biometrics TO authenticated;