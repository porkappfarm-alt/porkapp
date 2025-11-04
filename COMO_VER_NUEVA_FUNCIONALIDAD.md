# Cómo Ver la Nueva Funcionalidad de Gestión de Lotes

## 🎯 Funcionalidades Implementadas

La nueva funcionalidad incluye:

1. **Fecha de Nacimiento en Lotes**: Campo opcional para registrar la fecha de nacimiento de los animales del lote
2. **Cálculo Automático de Edad**: Muestra la edad en semanas/meses automáticamente
3. **Tracking de Progreso Inteligente**: Compara el peso actual con el esperado según la tabla `feeding_schedule`
4. **Alertas Inteligentes en Dashboard**:
   - Tareas programadas (vitaminas, desparasitación)
   - Lotes por debajo del peso objetivo
   - Lotes por encima del peso objetivo
5. **Indicadores Visuales**: Barras de progreso con colores según el estado (verde/amarillo/rojo)

## 📋 Pasos para Ver la Funcionalidad

### 1. Aplicar Migraciones a Supabase

Primero necesitas aplicar la migración que agrega la columna `birth_date` a la tabla `batches`:

```bash
# Opción A: Si tienes Supabase CLI instalado
supabase db push

# Opción B: Ejecutar manualmente en el SQL Editor de Supabase
```

**SQL a ejecutar en Supabase (si no usas CLI):**

```sql
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
```

### 2. Crear o Editar un Lote con Fecha de Nacimiento

Una vez aplicada la migración:

1. **Abre la app** y ve a la sección de Lotes
2. **Crea un nuevo lote** o **edita uno existente**
3. En el formulario verás un nuevo campo: **"Fecha de nacimiento (opcional)"**
4. Selecciona una fecha de nacimiento (por ejemplo, hace 30 días)
5. Completa los demás campos y guarda

### 3. Ver la Edad y Progreso en la Tarjeta del Lote

Después de guardar, verás en la tarjeta del lote:

- **Icono de pastel (🎂)** con la edad en formato legible:
  - "1 semana" (si tiene 7-13 días)
  - "4 semanas" (si tiene 14-59 días)
  - "2 meses" (si tiene 60+ días)
  
- **Barra de progreso inteligente** (solo si hay birthDate):
  - Verde 🟢: Peso dentro del rango objetivo (95-105%)
  - Amarillo 🟡: Peso bajo (85-95% del objetivo)
  - Naranja 🟠: Peso muy bajo (<85%) o alto (>105%)
  - Rojo 🔴: Peso crítico
  
### 4. Ver Detalles en la Vista de Detalle del Lote

Al hacer clic en un lote con fecha de nacimiento:

- **Header**: Muestra la edad y fecha de nacimiento formateada
- **Sección de Progreso**: 
  - Días de edad actual
  - Peso promedio actual vs peso objetivo
  - Estado con icono y color
  - Descripción del estado

### 5. Ver Alertas en el Dashboard

El dashboard ahora muestra alertas inteligentes:

1. **Alertas de tareas programadas**: 
   - "Vitamina programada" si el lote tiene X días y debe recibir vitamina
   - "Desparasitación programada" según la tabla feeding_schedule
   
2. **Alertas de peso**:
   - "Lote X: Por debajo del peso objetivo" (si está <95% del peso esperado)
   - "Lote Y: Por encima del peso objetivo" (si está >105% del peso esperado)

3. **Priorización**: Las alertas se ordenan por prioridad (high > medium > low)

4. **Navegación**: Haz clic en una alerta para ir directamente al detalle del lote

## 🔍 Dónde se Implementaron los Cambios

### Código de UI actualizado:

1. **batch_form_dialog.dart**: 
   - Campo DatePicker para seleccionar fecha de nacimiento
   - Icono de calendario
   - Botón para limpiar la fecha

2. **batch_card.dart**:
   - Muestra edad con icono de pastel si hay birthDate
   - Barra de progreso inteligente con BatchProgress
   - Estados con colores: verde/amarillo/naranja/rojo

3. **batch_detail_view.dart**:
   - Header con edad y fecha formateada
   - Sección de progreso expandida con más detalles
   - Indicadores visuales del estado

4. **alert_section.dart** (Dashboard):
   - Renderiza alertas con iconos según el tipo
   - Navegación al detalle del lote
   - Ordenamiento por prioridad

### Lógica de negocio:

5. **batch_progress_provider.dart**: 
   - Calcula progreso comparando con feeding_schedule
   - Determina estado (onTrack, slightlyBehind, critical, etc.)
   - Provee colores e iconos para cada estado

6. **dashboard_repository.dart**:
   - Genera alertas de tareas programadas
   - Detecta lotes con peso bajo/alto
   - Calcula prioridad de alertas

### Base de datos:

7. **20251103160000_add_birth_date_to_batches.sql**:
   - Agrega columna birth_date a la tabla batches
   - Agrega columna entry_date
   - Crea índices para mejorar performance

8. **20251102_create_feeding_schedule.sql** (ya existente):
   - Tabla con datos de referencia de peso por edad
   - Incluye tareas programadas (vitamina, deworm)

## ⚠️ Importante

**Por qué no ves nada ahora:**

1. ❌ **No has aplicado la migración** - La columna `birth_date` no existe en tu base de datos
2. ❌ **Tus lotes existentes no tienen fecha de nacimiento** - Fueron creados antes de esta feature
3. ❌ **No se han generado alertas** - Sin birthDate, no hay progreso que calcular

**Solución:**

1. ✅ Aplica la migración SQL en Supabase
2. ✅ Edita un lote existente y agrégale una fecha de nacimiento
3. ✅ O crea un nuevo lote con fecha de nacimiento
4. ✅ Agrega biometrías al lote para que tenga peso actual
5. ✅ Vuelve al dashboard para ver las alertas

## 🧪 Caso de Prueba Recomendado

Para ver toda la funcionalidad:

1. Crea un lote nuevo con:
   - Fecha de nacimiento: hace 30 días
   - 50 animales
   - Peso inicial: 6 kg

2. Agrega una biometría con peso promedio: 7 kg

3. Verás:
   - ✅ Edad: "4 semanas"
   - ✅ Progreso: Barra amarilla (7 kg vs 8 kg esperado = 87.5%)
   - ✅ Alert: "Por debajo del peso objetivo"
   - ✅ Alert: "Vitamina programada" (si está en día 30)

## 📊 Estados Posibles del Progreso

| Estado | Color | Icono | Rango |
|--------|-------|-------|-------|
| On Track | Verde 🟢 | ✓ | 95-105% del peso objetivo |
| Slightly Behind | Amarillo 🟡 | ⚠️ | 85-95% del objetivo |
| Critical | Naranja 🟠 | ⚠️ | <85% del objetivo |
| Above Target | Naranja 🟠 | ↑ | >105% del objetivo |
| No Data | Gris ⚪ | - | Sin biometrías |

## 🎨 Mejoras Visuales

- Gradientes en las tarjetas de lote
- Iconos modernos (🎂 para edad, 📊 para progreso)
- Colores semánticos consistentes
- Animaciones suaves en las barras de progreso
- Tipografía clara con Poppins

## 🚀 Próximos Pasos

Después de ver que funciona:

1. Puedes ajustar los umbrales de alerta en `batch_progress.dart`
2. Agregar más tipos de tareas a feeding_schedule
3. Crear notificaciones push para alertas críticas
4. Exportar reportes de progreso
