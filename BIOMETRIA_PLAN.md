# 🧬 Plan de Implementación: Módulo de Biometría v1.0

## 📋 Resumen Ejecutivo
Este documento detalla el plan de implementación para el módulo de biometría, enfocado en el registro de pesajes colectivos para lotes de animales activos.

## 🎯 Objetivos
- [x] Implementar registro de biometrías por lote
- [x] Asegurar trazabilidad de pesajes
- [x] Mantener actualizado el peso promedio del lote
- [ ] Preparar base para futuras alertas de alimentación

## 🗓️ Cronograma de Implementación

### Fase 1: Preparación de Base de Datos (2 días) ✅
1. **Estructura de Datos** *(Completado)*
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
   - [x] BatchBiometric *(Completado)*
   - [x] AnimalWeight *(Completado)*
   - [x] BiometricSummary *(Completado)*

2. **Repositorios**
   - [x] BiometricRepository *(Completado)*
   - [x] Métodos CRUD *(Completado)*
   - [x] Consultas especializadas *(Completado)*

3. **Providers**
   - [x] Estado global de biometrías *(Completado)*
   - [x] Gestión de estado local *(Completado)*
   - [x] Sincronización offline *(Completado)*

### Fase 3: Desarrollo de UI (4 días) ✅

1. **Vistas Principales** *(Completado)*
   - [x] Lista de biometrías
   - [x] Formulario de nueva biometría
     - Formulario con validación
     - Selección de lote
     - Entrada de notas
     - Gestión de mediciones
     - Guardado con feedback
   - [x] Detalle de biometría
     - Visualización de datos generales
     - Estadísticas del lote
     - Lista de mediciones individuales
     - Estados de carga y error

2. **Componentes** *(Completado)*
   - [x] Selector de lote
   - [x] Tabla de registro de pesos
     - Entrada de pesos individuales
     - Validación de datos
     - Actualización en tiempo real
   - [x] Indicadores de progreso
   - [x] Mensajes de retroalimentación
     - Confirmación de guardado
     - Manejo de errores
     - Estado de sincronización

### Fase 4: Lógica de Negocio (3 días) 🚧

1. **Validaciones** *(Pendiente)*
   - [ ] Verificación de lotes activos
   - [ ] Validación de pesos
     - Rango permitido
     - Coherencia con histórico
   - [ ] Control de datos requeridos
     - Campos obligatorios
     - Formatos correctos

2. **Cálculos** *(Pendiente)*
   - [ ] Promedio de peso por lote
     - Cálculo ponderado
     - Exclusión de valores atípicos
   - [ ] Estadísticas básicas
     - Desviación estándar
     - Rango de pesos
   - [ ] Histórico de crecimiento
     - Tasa de crecimiento
     - Proyecciones

### Fase 5: Testing y Refinamiento (3 días) 🚧

1. **Pruebas** *(Pendiente)*
   - [ ] Tests unitarios
     - Modelos y providers
     - Lógica de negocio
   - [ ] Tests de integración
     - Flujo completo de registro
     - Sincronización offline
   - [ ] Pruebas de UI
     - Validación de formularios
     - Estados de carga

2. **Optimización** *(Pendiente)*
   - [ ] Rendimiento
     - Tiempo de respuesta
     - Uso de memoria
   - [ ] UX/UI
     - Feedback visual
     - Accesibilidad
   - [ ] Manejo de errores
     - Mensajes claros
     - Recuperación graceful

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

### Dependencias Requeridas ✅
```yaml
dependencies:
  flutter_riverpod: ^2.4.0 *(Instalado)*
  freezed_annotation: ^2.4.1 *(Instalado)*
  json_annotation: ^4.8.1 *(Instalado)*
  intl: ^0.18.1 *(Instalado)*
  
dev_dependencies:
  build_runner: ^2.4.6 *(Instalado)*
  freezed: ^2.4.3 *(Instalado)*
  json_serializable: ^6.7.1 *(Instalado)*
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

## 📋 Plan de Implementación Restante

### Tareas Pendientes por Fase

#### Fase 4: Lógica de Negocio (5 días)
1. Implementación de Validaciones (2 días)
   - Desarrollo de sistema de validación para lotes activos
   - Implementación de validadores de peso con rangos permitidos
   - Sistema de verificación de datos obligatorios
   - Validación de coherencia con histórico de pesajes

2. Implementación de Cálculos (3 días)
   - Sistema de cálculo de promedios por lote
   - Implementación de cálculos estadísticos
   - Desarrollo de sistema de histórico de crecimiento
   - Implementación de proyecciones de crecimiento

#### Fase 5: Testing y Refinamiento (4 días)
1. Desarrollo de Tests (2 días)
   - Tests unitarios para modelos y providers
   - Tests de integración para flujos completos
   - Tests de UI para validación de formularios

2. Optimización y Pulido (2 días)
   - Optimización de rendimiento
   - Mejoras en UX/UI
   - Implementación de sistema robusto de manejo de errores

## 📝 Plan de Implementación Detallado

### Fase 1: Preparación (1 día)
1. **Creación de Estructura Base**
   - Crear nuevos archivos en la estructura existente
   - Configurar rutas para la nueva vista simplificada
   - Preparar providers específicos para la funcionalidad simplificada

2. **Configuración Inicial**
   - Integración con el sistema de rutas
   - Preparación de dependencias necesarias
   - Configuración de providers base

### Fase 2: Vista de Historial (2 días)
1. **Implementación de Lista**
   - Desarrollo de lista de biometrías previas
   - Diseño de cards de información resumida
   - Implementación de ordenamiento por fecha

2. **Sistema de Filtrado**
   - Filtros por fecha
   - Filtros por lote
   - Sistema de búsqueda rápida

### Fase 3: Formulario Simple (3 días)
1. **Desarrollo de Formulario**
   - Creación de formulario de entrada rápida
   - Implementación de selector de animales
   - Sistema de entrada de pesos

2. **Validaciones**
   - Validaciones de campos requeridos
   - Verificación de rangos de peso
   - Validaciones de coherencia de datos

### Fase 4: Integración (2 días)
1. **Conexión con Sistema**
   - Integración con providers existentes
   - Implementación de lógica de guardado
   - Sistema de sincronización de datos

2. **Pruebas de Integración**
   - Verificación de flujo de datos
   - Pruebas de sincronización
   - Validación de persistencia

### Fase 5: UI/UX (1 día)
1. **Refinamiento Visual**
   - Implementación de diseño limpio
   - Mejoras en la usabilidad
   - Optimización de la experiencia de usuario

2. **Sistema de Feedback**
   - Mensajes de éxito/error
   - Indicadores de progreso
   - Tooltips y ayudas visuales

### ⚙️ Estructura de Archivos Final
```
lib/features/biometrics/
├── presentation/
│   ├── views/
│   │   ├── simple_biometric_view.dart
│   │   └── biometric_history_view.dart
│   └── widgets/
│       ├── biometric_history_card.dart
│       ├── quick_weight_form.dart
│       └── biometric_filters.dart
└── providers/
    └── simple_biometric_provider.dart
```

### 🎯 Próximos Pasos Inmediatos
1. Crear estructura base de archivos
2. Implementar navegación básica
3. Desarrollar vista de historial
4. Implementar formulario simple
5. Integrar con sistema existente

### Cronograma Propuesto
- Inicio: 24 de Octubre, 2025
- Finalización: 4 de Noviembre, 2025

### Recursos Necesarios
- 1 Desarrollador Flutter Senior
- Acceso a ambiente de pruebas
- Documentación técnica actualizada

## 🚀 Solicitud de Autorización para Implementación Final

Se solicita autorización para proceder con la implementación de las fases restantes del módulo de biometría:

1. Implementación de la lógica de negocio pendiente
2. Desarrollo del sistema completo de testing
3. Optimización y refinamiento final

**Tiempo estimado**: 9 días hábiles
**Recursos asignados**: 1 desarrollador Flutter Senior
**Impacto**: Medio - Completará la funcionalidad core del módulo

Autorización para proceder:

- [ ] Aprobado para comenzar inmediatamente
- [ ] Aprobado con modificaciones (especificar abajo)
- [ ] Requiere revisión adicional

Comentarios o modificaciones requeridas:
_____________________________________________
_____________________________________________

Aprobado por: ______________________
Fecha: ______________________