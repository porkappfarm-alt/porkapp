# 🧬 Plan de Implementación: Módulo de Biometría v1.0

## 📋 Resumen Ejecutivo
Este documento detalla el plan de implementación para el módulo de biometría, enfocado en el registro de pesajes colectivos para lotes de animales activos.

## 🎯 Objetivos
- Implementar registro de biometrías por lote
- Asegurar trazabilidad de pesajes
- Mantener actualizado el peso promedio del lote
- Preparar base para futuras alertas de alimentación

## 🗓️ Cronograma de Implementación

### Fase 1: Preparación de Base de Datos (2 días)
1. **Estructura de Datos**
   ```sql
   -- Tabla principal de biometrías por lote
   CREATE TABLE batch_biometrics (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     batch_id UUID REFERENCES batches(id),
     measurement_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
     average_weight DECIMAL(10,2),
     animal_count INTEGER,
     notes TEXT,
     created_by UUID REFERENCES auth.users(id),
     created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
     status TEXT DEFAULT 'active',
     measurement_name TEXT GENERATED ALWAYS AS (
       'Biometría - Lote ' || (SELECT name FROM batches WHERE id = batch_id) || 
       ' (' || TO_CHAR(measurement_date, 'DD/MM/YYYY') || ')'
     ) STORED,
     CONSTRAINT valid_status CHECK (status IN ('active', 'cancelled', 'archived'))
   );

   -- Tabla de mediciones individuales
   CREATE TABLE biometric_measurements (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     biometric_id UUID REFERENCES batch_biometrics(id),
     animal_id UUID REFERENCES animals(id),
     weight DECIMAL(10,2),
     previous_weight DECIMAL(10,2),
     weight_gain DECIMAL(10,2),
     days_since_last INTEGER,
     adg DECIMAL(10,2), -- Average Daily Gain
     notes TEXT,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
     CONSTRAINT positive_weight CHECK (weight > 0),
     CONSTRAINT valid_adg CHECK (adg IS NULL OR (adg >= 0 AND adg <= 2))
   );

   -- Vista para histórico de crecimiento
   CREATE VIEW animal_growth_history AS
   SELECT 
     bm.animal_id,
     b.batch_id,
     bm.weight,
     bm.weight_gain,
     bm.adg,
     bb.measurement_date
   FROM biometric_measurements bm
   JOIN batch_biometrics bb ON bb.id = bm.biometric_id
   WHERE bb.status = 'active'
   ORDER BY bb.measurement_date DESC;

   -- Función para calcular estadísticas del lote
   CREATE OR REPLACE FUNCTION calculate_batch_stats(batch_id UUID)
   RETURNS TABLE (
     avg_weight DECIMAL(10,2),
     avg_adg DECIMAL(10,2),
     min_weight DECIMAL(10,2),
     max_weight DECIMAL(10,2),
     weight_std_dev DECIMAL(10,2)
   ) LANGUAGE plpgsql AS $$
   BEGIN
     RETURN QUERY
     SELECT 
       AVG(bm.weight)::DECIMAL(10,2) as avg_weight,
       AVG(bm.adg)::DECIMAL(10,2) as avg_adg,
       MIN(bm.weight)::DECIMAL(10,2) as min_weight,
       MAX(bm.weight)::DECIMAL(10,2) as max_weight,
       STDDEV(bm.weight)::DECIMAL(10,2) as weight_std_dev
     FROM batch_biometrics bb
     JOIN biometric_measurements bm ON bm.biometric_id = bb.id
     WHERE bb.batch_id = $1 AND bb.status = 'active';
   END;
   $$;
   ```

2. **Índices y Relaciones**
   ```sql
   CREATE INDEX idx_biometric_batch ON batch_biometrics(batch_id);
   CREATE INDEX idx_biometric_date ON batch_biometrics(measurement_date);
   CREATE INDEX idx_animal_weights_biometric ON animal_weights(biometric_id);
   ```

### Fase 2: Implementación de Backend (3 días)

1. **Modelos de Dominio**
   - BatchBiometric
   - AnimalWeight
   - BiometricSummary

2. **Repositorios**
   - BiometricRepository
   - Métodos CRUD
   - Consultas especializadas

3. **Providers**
   - Estado global de biometrías
   - Gestión de estado local
   - Sincronización offline

### Fase 3: Desarrollo de UI (4 días)

1. **Vistas Principales**
   - Lista de biometrías
   - Formulario de nueva biometría
   - Detalle de biometría

2. **Componentes**
   - Selector de lote
   - Tabla de registro de pesos
   - Indicadores de progreso
   - Mensajes de retroalimentación

### Fase 4: Lógica de Negocio (3 días)

1. **Validaciones**
   - Verificación de lotes activos
   - Validación de pesos
   - Control de datos requeridos

2. **Cálculos**
   - Promedio de peso por lote
   - Estadísticas básicas
   - Histórico de crecimiento

### Fase 5: Testing y Refinamiento (3 días)

1. **Pruebas**
   - Tests unitarios
   - Tests de integración
   - Pruebas de UI

2. **Optimización**
   - Rendimiento
   - UX/UI
   - Manejo de errores

## 🔍 Detalles Técnicos

### Estructura de Archivos
```
lib/features/biometrics/
├── data/
│   ├── biometric_repository.dart
│   └── models/
│       ├── batch_biometric.dart
│       └── animal_weight.dart
├── presentation/
│   ├── views/
│   │   ├── biometric_list_view.dart
│   │   ├── new_biometric_view.dart
│   │   └── biometric_detail_view.dart
│   └── widgets/
│       ├── batch_selector.dart
│       ├── weight_input_table.dart
│       └── biometric_summary_card.dart
└── providers/
    └── biometric_providers.dart
```

### Dependencias Requeridas
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  intl: ^0.18.1
  drift: ^2.11.1
  
dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.3
  json_serializable: ^6.7.1
  drift_dev: ^2.11.1
```

## ⚠️ Puntos de Atención

1. **Manejo de Datos**
   - Persistencia local para modo offline
   - Sincronización con backend
   - Manejo de conflictos

2. **Validaciones Críticas**
   - Verificación de conectividad
   - Validación de datos numéricos
   - Control de duplicados

3. **UX/UI**
   - Feedback inmediato
   - Prevención de pérdida de datos
   - Indicadores de progreso

## 🚦 Criterios de Aceptación

1. **Funcionales**
   - Registro exitoso de biometrías
   - Cálculo correcto de promedios
   - Actualización de datos del lote
   - Persistencia de datos

2. **No Funcionales**
   - Tiempo de respuesta < 2s
   - Funcionamiento offline
   - Sincronización automática
   - UI responsiva

## 📝 Solicitud de Autorización

Se solicita autorización para:

1. Iniciar la implementación según el plan detallado
2. Crear las nuevas tablas en la base de datos
3. Implementar los cambios en la estructura del proyecto
4. Proceder con el desarrollo de la funcionalidad

**Tiempo estimado**: 15 días hábiles
**Recursos necesarios**: 1 desarrollador Flutter
**Impacto**: Medio - Requiere cambios en la estructura de datos existente

¿Se autoriza proceder con la implementación?

- [ ] Sí, proceder según lo planeado
- [ ] Sí, con modificaciones (especificar)
- [ ] No, requiere revisión

Firma de autorización: ______________________
Fecha: ______________________

## 📈 Seguimiento

Se propone realizar seguimiento diario del avance mediante:
1. Reuniones de actualización de 15 minutos
2. Actualización del tablero Kanban
3. Revisión de código al final de cada fase
4. Demo de funcionalidades completadas