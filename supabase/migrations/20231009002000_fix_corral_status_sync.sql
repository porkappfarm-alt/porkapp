-- Asegurarnos que los lotes activos marquen correctamente los corrales como ocupados
DO $$ 
BEGIN
    -- Primero resetear todos los corrales que no estén en mantenimiento a disponible
    UPDATE corrals 
    SET status = 'disponible'
    WHERE status != 'mantenimiento';
    
    -- Luego marcar como ocupados los que tengan lotes activos
    UPDATE corrals c
    SET status = 'ocupado'
    WHERE EXISTS (
        SELECT 1 
        FROM batches b 
        WHERE b.corral_id = c.id 
        AND b.status = 'active'
    )
    AND c.status != 'mantenimiento';
END $$;