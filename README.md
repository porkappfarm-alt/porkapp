# PorkApp

Aplicación móvil para la gestión de granjas porcinas.

## Estructura de Navegación

La aplicación utiliza una navegación basada en pestañas con las siguientes secciones principales:

1. **Dashboard**
   - Vista general del sistema
   - Accesos rápidos a funciones principales
   - Resumen de métricas importantes

2. **Corrales**
   - Gestión de espacios físicos
   - Distribución y capacidad
   - Estado y mantenimiento

3. **Lotes**
   - Gestión de grupos de animales
   - Vista detallada de cada lote
   - Acceso a los animales del lote
   - Control de producción

4. **Biometría**
   - Análisis y métricas
   - Seguimiento de peso y salud
   - Indicadores de rendimiento

### Gestión de Animales

Los animales se gestionan siempre en el contexto de un lote específico. Para acceder a los animales:

1. Navegar a la sección de "Lotes"
2. Seleccionar el lote deseado
3. Acceder a la lista de animales del lote

Rutas de acceso a animales:
- `/batches` - Lista de lotes
- `/batches/:batchId` - Detalle del lote
- `/batches/:batchId/animals` - Animales del lote
- `/batches/:batchId/animals/:animalId` - Detalle del animal

## Desarrollo

### Requisitos
- Flutter SDK
- Dart SDK
- Supabase Account

### Configuración
1. Clonar el repositorio
2. Ejecutar `flutter pub get`
3. Configurar las variables de entorno
4. Ejecutar la aplicación con `flutter run`

## Licencia

Este proyecto es propiedad de PorkApp Farm.
