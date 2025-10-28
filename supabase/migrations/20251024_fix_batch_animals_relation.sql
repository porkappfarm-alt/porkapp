-- Asegurarnos de que la tabla batches existe y tiene la estructura correcta
CREATE TABLE IF NOT EXISTS batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    headcount_start INTEGER DEFAULT 0,
    corral_id UUID REFERENCES corrals(id),
    initial_avg_weight DECIMAL,
    status TEXT DEFAULT 'active',
    notes TEXT,
    image_url TEXT
);

-- Asegurarnos de que la tabla animals existe y tiene la estructura correcta
CREATE TABLE IF NOT EXISTS animals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID REFERENCES batches(id) ON DELETE CASCADE,
    identifier TEXT NOT NULL,
    birth_date DATE,
    weight_at_entry DECIMAL,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    notes TEXT,
    entry_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    breed TEXT,
    animal_type TEXT DEFAULT 'fattening',
    sex TEXT CHECK (sex IN ('M', 'F'))
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_animals_batch_id ON animals(batch_id);
CREATE INDEX IF NOT EXISTS idx_batches_corral_id ON batches(corral_id);

-- Función para actualizar el timestamp de updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para actualizar updated_at automáticamente
DROP TRIGGER IF EXISTS animals_updated_at ON animals;
CREATE TRIGGER animals_updated_at
    BEFORE UPDATE ON animals
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Crear una vista para facilitar la consulta de lotes con sus animales
CREATE OR REPLACE VIEW batch_details AS
SELECT 
    b.*,
    COUNT(a.id) as current_animal_count,
    AVG(a.weight_at_entry) as average_entry_weight
FROM batches b
LEFT JOIN animals a ON b.id = a.batch_id
WHERE a.status = 'active' OR a.status IS NULL
GROUP BY b.id;