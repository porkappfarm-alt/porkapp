-- Create feeding_schedule table
CREATE TABLE IF NOT EXISTS public.feeding_schedule (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    days_old INTEGER NOT NULL UNIQUE,
    weeks_old DECIMAL GENERATED ALWAYS AS (days_old / 7.0) STORED,
    average_weight_kg DECIMAL(5,2) NOT NULL CHECK (average_weight_kg > 0),
    daily_feed_kg DECIMAL(5,2) NOT NULL CHECK (daily_feed_kg > 0),
    weekly_feed_kg DECIMAL(5,2) GENERATED ALWAYS AS (daily_feed_kg * 7) STORED,
    feed_type TEXT NOT NULL CHECK (feed_type IN ('pre_starter', 'starter', 'grower', 'fattening', 'finisher')),
    tasks TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_feeding_schedule_days_old ON public.feeding_schedule(days_old);
CREATE INDEX IF NOT EXISTS idx_feeding_schedule_feed_type ON public.feeding_schedule(feed_type);

-- Enable RLS
ALTER TABLE public.feeding_schedule ENABLE ROW LEVEL SECURITY;

-- RLS Policies for authenticated users
CREATE POLICY "Enable read access for authenticated users" ON public.feeding_schedule
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Enable insert for authenticated users" ON public.feeding_schedule
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users" ON public.feeding_schedule
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Enable delete for authenticated users" ON public.feeding_schedule
    FOR DELETE
    TO authenticated
    USING (true);

-- Grant permissions
GRANT ALL ON public.feeding_schedule TO authenticated;

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_feeding_schedule_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
CREATE TRIGGER update_feeding_schedule_updated_at
    BEFORE UPDATE ON public.feeding_schedule
    FOR EACH ROW
    EXECUTE FUNCTION public.update_feeding_schedule_updated_at();

-- Insert some initial sample data
INSERT INTO public.feeding_schedule (days_old, average_weight_kg, daily_feed_kg, feed_type, tasks) VALUES
    (7, 1.5, 0.15, 'pre_starter', ARRAY['vitamin']),
    (14, 3.0, 0.25, 'pre_starter', ARRAY['deworm']),
    (21, 5.0, 0.40, 'starter', ARRAY[]::TEXT[]),
    (30, 8.0, 0.60, 'starter', ARRAY['vitamin']),
    (45, 15.0, 1.00, 'grower', ARRAY[]::TEXT[]),
    (60, 25.0, 1.50, 'grower', ARRAY['deworm', 'vitamin']),
    (90, 45.0, 2.20, 'fattening', ARRAY[]::TEXT[]),
    (120, 70.0, 2.80, 'fattening', ARRAY['vitamin']),
    (150, 95.0, 3.20, 'finisher', ARRAY[]::TEXT[]),
    (180, 115.0, 3.50, 'finisher', ARRAY[]::TEXT[])
ON CONFLICT (days_old) DO NOTHING;
