# Plan de Implementación: Dashboard Refactorizado para Producción Porcícola

## 📊 Resumen Ejecutivo

Se refactorizará el dashboard actual para mostrar información relevante y accionable para un productor porcícola, utilizando los datos reales de la base de datos y siguiendo las mejores prácticas de Material Design para dashboards móviles.

---

## 🎯 Objetivos

1. **Información Contextual**: Mostrar métricas clave de producción en tiempo real
2. **Visualización Efectiva**: Usar gráficos y tarjetas que faciliten la toma de decisiones
3. **Navegación Rápida**: Acceso directo a las funcionalidades más utilizadas
4. **Alertas Proactivas**: Notificaciones visuales de situaciones que requieren atención

---

## 📋 Análisis de Datos Disponibles

### Tablas Principales en Uso:

#### 1. **Corrales (corrals)**

- Total de corrales y su estado (disponible, ocupado, mantenimiento)
- Capacidad vs ocupación actual
- Corrales con imagen

#### 2. **Lotes (batches)**

- Lotes activos vs finalizados
- Animales por lote
- Fecha de entrada y días en granja
- Peso promedio inicial

#### 3. **Animales (animals)**

- Total de animales activos
- Distribución por género y tipo (engorde, reproductoras, etc.)
- Estados: activos, vendidos, fallecidos, removidos
- Peso promedio actual

#### 4. **Biometrías de Lote (batch_biometrics)**

- Mediciones recientes
- Peso promedio, mínimo y máximo
- ADG (Average Daily Gain) promedio
- Mortalidad acumulada

#### 5. **Mediciones Individuales (biometric_measurements)**

- Historial de pesos por animal
- Ganancias de peso
- Días entre mediciones

#### 6. **Eventos de Animales (animal_events)**

- Tratamientos, alimentación, vacunaciones
- Mortalidad con causas
- Transferencias y ventas

---

## 🎨 Diseño del Nuevo Dashboard

### **Sección 1: Header con Información del Usuario** ✅ (Mantener Mejorado)

```
┌─────────────────────────────────────────────┐
│ 👤 Bienvenido, [Nombre Usuario]            │
│ 🏭 Granja: [Nombre Granja]                 │
│ 📅 Última actualización: hace [X] minutos   │
└─────────────────────────────────────────────┘
```

### **Sección 2: KPIs Principales** 🆕 (Rediseñar)

```
┌──────────────────────────────────────────────┐
│  📊 INDICADORES CLAVE                        │
├──────────┬──────────┬──────────┬────────────┤
│ 🐷       │ 🏠       │ ⚖️       │ 📈         │
│ Animales │ Corrales │ Peso Prom│ ADG Prom   │
│ 234      │ 12/15    │ 85.5 kg  │ 0.750 kg/d │
│ activos  │ en uso   │          │            │
└──────────┴──────────┴──────────┴────────────┘
```

**Métricas a Mostrar:**

1. **Total de Animales Activos** con desglose por tipo
2. **Corrales en Uso / Total** con indicador de ocupación
3. **Peso Promedio Actual** calculado de última biometría
4. **ADG Promedio** de todos los lotes activos
5. **Tasa de Mortalidad** del mes actual
6. **Días Promedio en Granja** de animales activos

### **Sección 3: Alertas y Notificaciones** 🆕 (Nueva)

```
┌──────────────────────────────────────────────┐
│  ⚠️ REQUIEREN ATENCIÓN                       │
├──────────────────────────────────────────────┤
│ 🔴 3 lotes sin biometría en 15+ días        │
│ 🟡 2 corrales cerca de capacidad máxima     │
│ 🟠 5 animales con ADG bajo (< 0.500 kg/d)   │
└──────────────────────────────────────────────┘
```

**Alertas Configuradas:**

- Lotes sin biometría reciente (>14 días)
- Corrales sobre 90% de capacidad
- Animales con bajo rendimiento (ADG < 0.5 kg/día)
- Mortalidad sobre promedio histórico
- Lotes próximos a fecha estimada de venta

### **Sección 4: Resumen de Lotes Activos** 🆕 (Nueva)

```
┌──────────────────────────────────────────────┐
│  📦 LOTES ACTIVOS (Top 3 más recientes)     │
├──────────────────────────────────────────────┤
│ Lote-2025-001 | Corral A1                   │
│ 45 animales | 78 días | 92.3 kg prom       │
│ [━━━━━━━━━━━━━━━━] 75% al objetivo         │
├──────────────────────────────────────────────┤
│ Lote-2025-002 | Corral B2                   │
│ 38 animales | 52 días | 68.5 kg prom       │
│ [━━━━━━━━━━░░░░░░] 55% al objetivo         │
└──────────────────────────────────────────────┘
```

### **Sección 5: Gráfico de Tendencias** 🆕 (Nueva)

```
┌──────────────────────────────────────────────┐
│  📈 EVOLUCIÓN PESO PROMEDIO (30 días)       │
│                                              │
│  95kg │           ╱─────                    │
│  90kg │        ╱──                          │
│  85kg │     ╱──                             │
│  80kg │  ──                                 │
│       └────────────────────────────         │
│        Día 1  Día 10  Día 20  Día 30       │
└──────────────────────────────────────────────┘
```

**Gráficos a Implementar:**

1. Evolución de peso promedio (últimos 30 días)
2. ADG por lote (comparativo)
3. Distribución de pesos actual (histograma)

### **Sección 6: Accesos Rápidos** ✅ (Mantener Mejorado)

```
┌──────────────────────────────────────────────┐
│  🚀 ACCESOS RÁPIDOS                          │
├──────────┬──────────┬──────────┬────────────┤
│ ➕ Nueva │ ⚖️ Biomé-│ 🏠 Gesti │ 📊 Report  │
│ Biometría│ -trica   │ Corrales │ -es        │
└──────────┴──────────┴──────────┴────────────┘
```

**Acciones Rápidas:**

- Registrar nueva biometría
- Ver biometrías pendientes
- Gestionar corrales
- Registrar evento (tratamiento, alimentación)
- Ver reportes

---

## 🏗️ Arquitectura Técnica

### **1. Estructura de Carpetas**

```
lib/features/dashboard/
├── data/
│   ├── dashboard_repository.dart          # 🆕 Queries a Supabase
│   └── models/
│       ├── dashboard_kpis.dart            # 🆕 Modelo de KPIs
│       ├── dashboard_alert.dart           # 🆕 Modelo de alertas
│       └── batch_summary.dart             # 🆕 Resumen de lotes
├── domain/
│   └── dashboard_metrics.dart             # 🆕 Lógica de negocio
├── providers/
│   ├── dashboard_kpis_provider.dart       # 🆕 Riverpod provider
│   ├── dashboard_alerts_provider.dart     # 🆕 Provider de alertas
│   └── dashboard_charts_provider.dart     # 🆕 Datos para gráficos
├── presentation/
│   ├── views/
│   │   └── dashboard_view.dart            # ♻️ Refactorizar
│   └── widgets/
│       ├── kpi_card_v2.dart               # 🆕 Nueva tarjeta KPI
│       ├── alert_section.dart             # 🆕 Sección alertas
│       ├── batch_summary_card.dart        # 🆕 Tarjeta resumen lote
│       ├── weight_trend_chart.dart        # 🆕 Gráfico tendencias
│       ├── quick_action_button.dart       # ♻️ Mejorar
│       └── welcome_header.dart            # ♻️ Refactorizar
```

### **2. Queries SQL Necesarias**

#### **Query 1: KPIs Generales**

```sql
-- Total animales activos por tipo
SELECT
  animal_type,
  COUNT(*) as total,
  AVG(weight_at_entry) as avg_entry_weight
FROM animals
WHERE status = 'active'
GROUP BY animal_type;

-- Corrales ocupados
SELECT
  status,
  COUNT(*) as total,
  SUM(capacity) as total_capacity
FROM corrals
GROUP BY status;

-- Peso promedio actual (última biometría)
SELECT
  AVG(bm.weight) as current_avg_weight
FROM biometric_measurements bm
INNER JOIN (
  SELECT animal_id, MAX(created_at) as last_measurement
  FROM biometric_measurements
  GROUP BY animal_id
) last ON bm.animal_id = last.animal_id
  AND bm.created_at = last.last_measurement;

-- ADG promedio de lotes activos
SELECT
  AVG(bb.avg_adg) as overall_avg_adg
FROM batch_biometrics bb
WHERE bb.status = 'active';
```

#### **Query 2: Alertas**

```sql
-- Lotes sin biometría reciente
SELECT
  b.id,
  b.name,
  b.animal_count,
  MAX(bb.measurement_date) as last_biometry,
  NOW() - MAX(bb.measurement_date) as days_since_last
FROM batches b
LEFT JOIN batch_biometrics bb ON b.id = bb.batch_id
WHERE b.status = 'active'
GROUP BY b.id
HAVING (NOW() - MAX(bb.measurement_date)) > INTERVAL '14 days';

-- Corrales sobre capacidad
SELECT
  c.id,
  c.name,
  c.capacity,
  COUNT(a.id) as current_animals,
  ROUND((COUNT(a.id)::numeric / c.capacity) * 100, 2) as occupancy_pct
FROM corrals c
INNER JOIN batches b ON c.id = b.corral_id
INNER JOIN animals a ON b.id = a.batch_id
WHERE b.status = 'active' AND a.status = 'active'
GROUP BY c.id
HAVING (COUNT(a.id)::numeric / c.capacity) > 0.9;

-- Animales con bajo ADG
SELECT
  a.id,
  a.identifier,
  bm.adg,
  b.name as batch_name
FROM animals a
INNER JOIN batches b ON a.batch_id = b.id
INNER JOIN biometric_measurements bm ON a.id = bm.animal_id
WHERE a.status = 'active'
  AND bm.adg < 0.500
  AND bm.created_at = (
    SELECT MAX(created_at)
    FROM biometric_measurements
    WHERE animal_id = a.id
  );
```

#### **Query 3: Resumen de Lotes**

```sql
-- Top 3 lotes más recientes con métricas
SELECT
  b.id,
  b.name,
  b.entry_date,
  b.animal_count,
  b.initial_avg_weight,
  c.name as corral_name,
  EXTRACT(DAY FROM (NOW() - b.entry_date)) as days_in_farm,
  bb.avg_weight as current_avg_weight,
  bb.avg_adg,
  CASE
    WHEN bb.avg_weight IS NOT NULL AND b.initial_avg_weight IS NOT NULL
    THEN ROUND(((bb.avg_weight - b.initial_avg_weight) / (120 - b.initial_avg_weight)) * 100, 2)
    ELSE 0
  END as progress_to_target
FROM batches b
INNER JOIN corrals c ON b.corral_id = c.id
LEFT JOIN LATERAL (
  SELECT avg_weight, avg_adg
  FROM batch_biometrics
  WHERE batch_id = b.id
  ORDER BY measurement_date DESC
  LIMIT 1
) bb ON true
WHERE b.status = 'active'
ORDER BY b.entry_date DESC
LIMIT 3;
```

#### **Query 4: Datos para Gráfico de Tendencias**

```sql
-- Evolución de peso promedio últimos 30 días
SELECT
  DATE(bb.measurement_date) as measurement_day,
  AVG(bb.avg_weight) as avg_weight_day
FROM batch_biometrics bb
WHERE bb.measurement_date >= NOW() - INTERVAL '30 days'
  AND bb.status = 'active'
GROUP BY DATE(bb.measurement_date)
ORDER BY measurement_day;
```

### **3. Modelos de Datos**

```dart
// dashboard_kpis.dart
class DashboardKPIs {
  final int totalActiveAnimals;
  final Map<String, int> animalsByType;
  final CorralOccupancy corralOccupancy;
  final double currentAvgWeight;
  final double avgADG;
  final double mortalityRate;
  final int avgDaysInFarm;

  // ... constructor, fromJson, copyWith
}

// dashboard_alert.dart
enum AlertSeverity { critical, warning, info }

class DashboardAlert {
  final String id;
  final AlertSeverity severity;
  final String title;
  final String description;
  final String? actionRoute;
  final DateTime createdAt;

  // ... constructor, fromJson
}

// batch_summary.dart
class BatchSummary {
  final String id;
  final String name;
  final String corralName;
  final int animalCount;
  final int daysInFarm;
  final double currentAvgWeight;
  final double avgADG;
  final double progressToTarget;

  // ... constructor, fromJson
}
```

### **4. Providers (Riverpod)**

```dart
// dashboard_kpis_provider.dart
@riverpod
Future<DashboardKPIs> dashboardKPIs(DashboardKPIsRef ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getKPIs();
}

// dashboard_alerts_provider.dart
@riverpod
Future<List<DashboardAlert>> dashboardAlerts(DashboardAlertsRef ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getAlerts();
}

// dashboard_charts_provider.dart
@riverpod
Future<List<WeightDataPoint>> weightTrendData(WeightTrendDataRef ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getWeightTrend(days: 30);
}
```

---

## 📦 Dependencias Adicionales

```yaml
dependencies:
  # Gráficos
  fl_chart: ^1.1.0 # ✅ YA INSTALADO

  # Animaciones
  flutter_animate: ^4.5.0 # 🆕 Para animaciones fluidas

  # Shimmer loading
  shimmer: ^3.0.0 # 🆕 Para efectos de carga
```

---

## 🚀 Plan de Implementación por Fases

### **Fase 1: Infraestructura de Datos** (2-3 días)

- [ ] Crear `dashboard_repository.dart`
- [ ] Implementar queries SQL optimizadas
- [ ] Crear modelos de datos (KPIs, Alerts, BatchSummary)
- [ ] Configurar providers de Riverpod
- [ ] Pruebas unitarias de repository

### **Fase 2: Widgets Base** (2-3 días)

- [ ] Refactorizar `welcome_header.dart`
- [ ] Crear `kpi_card_v2.dart` con animaciones
- [ ] Crear `alert_section.dart`
- [ ] Crear `batch_summary_card.dart`
- [ ] Mejorar `quick_action_button.dart`

### **Fase 3: Gráficos y Visualizaciones** (2-3 días)

- [ ] Implementar `weight_trend_chart.dart` con fl_chart
- [ ] Crear gráfico de distribución de pesos
- [ ] Crear gráfico comparativo de ADG por lote
- [ ] Animaciones y transiciones suaves

### **Fase 4: Integración Dashboard** (1-2 días)

- [ ] Refactorizar `dashboard_view.dart`
- [ ] Integrar todos los widgets
- [ ] Implementar pull-to-refresh funcional
- [ ] Manejo de estados (loading, error, empty)
- [ ] Optimización de rendimiento

### **Fase 5: Pulido y Testing** (1-2 días)

- [ ] Pruebas de integración
- [ ] Ajustes de diseño y UX
- [ ] Optimización de queries
- [ ] Documentación de código
- [ ] Testing en dispositivos reales

---

## 🎯 Métricas de Éxito

1. **Tiempo de carga**: Dashboard debe cargar en < 2 segundos
2. **Actualizaciones**: Pull-to-refresh funcional y rápido
3. **UX**: Navegación fluida con animaciones a 60 FPS
4. **Datos precisos**: Métricas reflejan estado real de la granja
5. **Acciones rápidas**: Acceso a funciones clave en ≤ 2 taps

---

## 🔍 Consideraciones Técnicas

### **Optimizaciones de Rendimiento**

- Cacheo de datos con `AsyncValue` de Riverpod
- Queries optimizadas con índices en BD
- Paginación en listas grandes
- Lazy loading de gráficos complejos

### **Manejo de Estados**

- Loading states con shimmer effects
- Error states con opción de retry
- Empty states con ilustraciones
- Skeleton screens durante carga inicial

### **Accesibilidad**

- Semantics para screen readers
- Contraste de colores AA/AAA
- Tamaños de texto escalables
- Gestos alternativos

---

## 📝 Notas Adicionales

### **Mejores Prácticas Aplicadas:**

- Material Design 3 guidelines
- Dashboard móvil optimizado para pantallas pequeñas
- Información jerarquizada (más importante arriba)
- Colores consistentes con identidad de marca (#6B0338)
- Iconografía clara y reconocible
- Feedback visual inmediato

### **Referencias de Diseño:**

- Material Design Dashboard patterns
- Agricultural app best practices
- Mobile-first responsive design
- Data visualization guidelines (fl_chart)

---

## ✅ Checklist de Autorización

Antes de proceder con la implementación, confirmar:

- [ ] ✅ El plan de datos y queries SQL es correcto
- [ ] ✅ La estructura de carpetas es clara
- [ ] ✅ Los KPIs seleccionados son relevantes
- [ ] ✅ Las alertas configuradas son útiles
- [ ] ✅ El diseño visual es apropiado
- [ ] ✅ Las fases de implementación son realistas
- [ ] ✅ Las dependencias adicionales son aceptables

---

**🚦 ESPERANDO AUTORIZACIÓN PARA PROCEDER**
