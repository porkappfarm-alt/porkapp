# Plan de Implementación: Sistema de Roles y Panel de Administración

**Fecha de creación**: 17 de octubre de 2025
**Objetivo**: Refactorizar el sistema de autenticación para incluir manejo de roles (admin/user) y crear un panel de administración con funcionalidades específicas para administradores.

## 🔐 Proceso de Autorización

Este plan de implementación sigue un **modelo de autorización por fases**. Cada fase requiere aprobación explícita antes de su ejecución:

### Checkpoints de Autorización

1. **CHECKPOINT 1** - Migrations de Base de Datos
2. **CHECKPOINT 2** - Actualización de Modelos Flutter
3. **CHECKPOINT 3** - Refactorización del Sistema de Autenticación
4. **CHECKPOINT 4** - Modificación del Router y Rutas Protegidas
5. **CHECKPOINT 5** - Implementación de Funcionalidades del Panel Admin
6. **CHECKPOINT 6** - Creación de Pantallas del Panel Admin
7. **CHECKPOINT 7** - Testing y Validación
8. **AUTORIZACIÓN FINAL** - Merge a Producción

### Flujo de Trabajo

```
Inicio → Revisión del Plan → Autorización Checkpoint 1 → Ejecución Fase 1 →
Revisión de Resultados → Autorización Checkpoint 2 → ... → Merge Final
```

**Beneficios de este enfoque**:

- ✅ Control total sobre cada cambio
- ✅ Posibilidad de pausar en cualquier momento
- ✅ Revisión de resultados antes de continuar
- ✅ Minimiza riesgos de errores en cascada
- ✅ Permite ajustar el plan según sea necesario

### Estrategia de Ramas Dual (Supabase + Git)

Este proyecto requiere mantener sincronizadas dos ramas de desarrollo:

```
┌─────────────────────────────────────────────────────────┐
│                    RAMA SUPABASE                        │
│  feature/role-based-access                              │
│  • Migrations de base de datos                          │
│  • Políticas RLS                                        │
│  • Funciones SQL                                        │
│  • Tablas nuevas                                        │
└─────────────────────────────────────────────────────────┘
                          ↕️
              (sincronización coordinada)
                          ↕️
┌─────────────────────────────────────────────────────────┐
│                     RAMA GIT                            │
│  feature/role-based-access                              │
│  • Código Flutter/Dart                                  │
│  • Modelos actualizados                                 │
│  • Providers y lógica                                   │
│  • Pantallas y widgets                                  │
└─────────────────────────────────────────────────────────┘
```

**Ventajas**:

- 🔒 Producción permanece intacta durante el desarrollo
- 🧪 Testing completo antes del merge
- ⚡ Rollback fácil si algo sale mal
- 📊 Validación de migrations en ambiente aislado

**Consideraciones**:

- Los cambios en Supabase deben aplicarse **antes** que los cambios en código
- El testing debe hacerse apuntando a la rama de Supabase
- El merge final debe ser coordinado: primero Supabase, luego Git

---

## Estado Actual del Sistema### Esquema de Base de Datos Actual

La tabla `profiles` ya tiene el campo `role` con valores permitidos: 'admin' y 'user':

```sql
profiles:
  - id (uuid, FK a auth.users)
  - email (text)
  - role (text) -- valores: 'admin' | 'user', default: 'user'
  - status (text) -- valores: 'pending' | 'approved' | 'blocked'
  - created_at (timestamptz)
  - updated_at (timestamptz)
```

### Usuarios Actuales

- **Admin**: porkappfarm@gmail.com (role: admin, status: approved)
- **User**: gestoridtv@gmail.com (role: user, status: pending)

### Código de Autenticación Actual

- El modelo `User` en Dart **NO incluye** campos `role` ni `status`
- El `AuthStateNotifier` solo maneja estados básicos: initial/unauthenticated/authenticated
- El router no valida roles, solo autenticación
- No existe lógica para verificar permisos basados en roles

## Plan de Implementación Paso a Paso

> **⚠️ IMPORTANTE**: Este plan requiere **autorización explícita** antes de ejecutar cada fase. Al finalizar cada fase, se solicitará aprobación para continuar con la siguiente.

### Fase 1: Preparación de la Base de Datos

**Objetivo**: Asegurar que la base de datos esté lista para el sistema de roles

> **✋ CHECKPOINT 1**: Se solicitará autorización antes de ejecutar las migrations de base de datos

#### 1.1. Crear Migration: Verificar y Documentar Estado de Roles

**Archivo**: `20251017_verify_roles_setup.sql`

```sql
-- Verificar que la tabla profiles tenga los constraints correctos
-- Documentar funciones y políticas RLS existentes relacionadas con roles
```

#### 1.2. Crear Migration: Funciones para Gestión de Roles

**Archivo**: `20251017_create_role_management_functions.sql`

```sql
-- Función para obtener el rol del usuario actual
CREATE OR REPLACE FUNCTION public.get_user_role(user_id UUID)
RETURNS TEXT AS $$
  SELECT role FROM public.profiles WHERE id = user_id;
$$ LANGUAGE sql SECURITY DEFINER;

-- Función para verificar si el usuario actual es admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- Función para verificar si el usuario actual es admin Y está aprobado
CREATE OR REPLACE FUNCTION public.is_approved_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role = 'admin'
    AND status = 'approved'
  );
$$ LANGUAGE sql SECURITY DEFINER;
```

#### 1.3. Crear Migration: Políticas RLS para Panel de Admin

**Archivo**: `20251017_create_admin_panel_policies.sql`

```sql
-- Permitir a los admins ver todos los perfiles
CREATE POLICY "Admins can view all profiles"
ON public.profiles FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role = 'admin'
  )
);

-- Permitir a los admins actualizar roles y status de otros usuarios
CREATE POLICY "Admins can update user profiles"
ON public.profiles FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role = 'admin'
    AND status = 'approved'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role = 'admin'
    AND status = 'approved'
  )
);

-- Los usuarios normales solo pueden ver su propio perfil
CREATE POLICY "Users can view own profile"
ON public.profiles FOR SELECT
TO authenticated
USING (id = auth.uid());
```

### Fase 2: Modelos y Tipos en Flutter

> **✋ CHECKPOINT 2**: Se solicitará autorización antes de modificar los modelos en Flutter

#### 2.1. Actualizar Modelo User

**Archivo**: `lib/features/auth/models/user.dart`

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? username,
    required String role,        // NUEVO: 'admin' | 'user'
    required String status,      // NUEVO: 'pending' | 'approved' | 'blocked'
    required DateTime createdAt,
    DateTime? lastLogin,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson({
    ...json,
    'createdAt': json['created_at'],
    'lastLogin': json['last_login'],
  });

  const User._();

  // NUEVO: Helpers para verificar rol y status
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isBlocked => status == 'blocked';
  bool get canAccessApp => isApproved && !isBlocked;
  bool get canAccessAdmin => isAdmin && isApproved;
}
```

#### 2.2. Crear Enums para Roles y Status

**Archivo**: `lib/features/auth/models/user_role.dart`

```dart
enum UserRole {
  admin('admin', 'Administrador'),
  user('user', 'Usuario');

  final String value;
  final String label;
  const UserRole(this.value, this.label);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }
}

enum UserStatus {
  pending('pending', 'Pendiente'),
  approved('approved', 'Aprobado'),
  blocked('blocked', 'Bloqueado');

  final String value;
  final String label;
  const UserStatus(this.value, this.label);

  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => UserStatus.pending,
    );
  }
}
```

### Fase 3: Refactorización de Auth Provider

> **✋ CHECKPOINT 3**: Se solicitará autorización antes de refactorizar el sistema de autenticación

#### 3.1. Actualizar AuthStateNotifier

**Archivo**: `lib/features/auth/providers/auth_provider.dart`

**Cambios**:

- Agregar estado para almacenar el `User` completo (con role y status)
- Crear provider para el usuario actual
- Crear providers derivados para verificar roles y permisos

```dart
// Provider para el usuario actual
final currentUserProvider = StateProvider<User?>((ref) => null);

// Provider para verificar si es admin
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAdmin ?? false;
});

// Provider para verificar si puede acceder al panel admin
final canAccessAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.canAccessAdmin ?? false;
});

// Provider para verificar si está aprobado
final isApprovedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isApproved ?? false;
});

// Actualizar AuthStateNotifier para cargar datos del perfil
class AuthStateNotifier extends StateNotifier<AuthState> {
  // ... código existente ...

  Future<void> _loadUserProfile() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      final response = await supabase
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .single();

      final user = User.fromJson(response);
      ref.read(currentUserProvider.notifier).state = user;

      // Verificar estado del usuario
      if (user.isBlocked) {
        await signOut();
      } else if (user.isApproved) {
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    }
  }
}
```

### Fase 4: Actualizar Router con Protección de Rutas

> **✋ CHECKPOINT 4**: Se solicitará autorización antes de modificar el sistema de rutas

#### 4.1. Modificar Router para Validar Roles

**Archivo**: `lib/router.dart`

**Cambios**:

- Agregar validación de rol en el redirect
- Crear rutas para el panel de administración
- Crear pantallas para usuarios bloqueados/pendientes

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final currentUser = ref.watch(currentUserProvider);
  final canAccessAdmin = ref.watch(canAccessAdminProvider);

  return GoRouter(
    redirect: (context, state) {
      final currentLocation = state.uri.path;
      final isAdminRoute = currentLocation.startsWith('/admin');

      // Validaciones existentes de autenticación...

      // NUEVO: Validar acceso a rutas de admin
      if (isAdminRoute && !canAccessAdmin) {
        return '/dashboard'; // Redirigir a dashboard si no es admin aprobado
      }

      // NUEVO: Validar status del usuario
      if (authState == AuthState.authenticated && currentUser != null) {
        if (currentUser.isBlocked) {
          return '/blocked';
        }
        if (currentUser.isPending) {
          return '/pending';
        }
      }

      return null;
    },
    routes: [
      // ... rutas existentes ...

      // NUEVO: Ruta para usuarios bloqueados
      GoRoute(
        path: '/blocked',
        builder: (context, state) => const BlockedScreen(),
      ),

      // NUEVO: Ruta para usuarios pendientes
      GoRoute(
        path: '/pending',
        builder: (context, state) => const PendingApprovalScreen(),
      ),

      // NUEVO: Panel de administración (solo para admins)
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: 'feeding-plan',
            builder: (context, state) => const FeedingPlanScreen(),
          ),
          GoRoute(
            path: 'vaccination-plan',
            builder: (context, state) => const VaccinationPlanScreen(),
          ),
        ],
      ),
    ],
  );
});
```

### Fase 5: Crear Funcionalidades del Panel de Administración

> **✋ CHECKPOINT 5**: Se solicitará autorización antes de implementar las funcionalidades del panel de administración

#### 5.1. Crear Estructura de Features para Admin

```
lib/features/admin/
├── models/
│   ├── user_profile.dart
│   └── user_profile.freezed.dart
├── providers/
│   ├── user_management_provider.dart
│   ├── feeding_plan_provider.dart
│   └── vaccination_plan_provider.dart
├── presentation/
│   ├── admin_dashboard_screen.dart
│   ├── views/
│   │   ├── user_management_view.dart
│   │   ├── feeding_plan_view.dart
│   │   └── vaccination_plan_view.dart
│   └── widgets/
│       ├── user_list_item.dart
│       ├── user_status_badge.dart
│       └── admin_nav_card.dart
└── data/
    └── admin_repository.dart
```

#### 5.2. Gestión de Usuarios (Alta Prioridad)

**Funcionalidades**:

- Listar todos los usuarios
- Ver detalles de cada usuario
- Aprobar usuarios pendientes
- Cambiar status (approved/blocked)
- Cambiar rol (admin/user)
- Ver actividad reciente

**Providers necesarios**:

```dart
// lib/features/admin/providers/user_management_provider.dart
final usersListProvider = FutureProvider<List<UserProfile>>((ref) async {
  // Cargar lista de usuarios desde Supabase
});

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  // Estadísticas: total, pending, approved, blocked
});
```

#### 5.3. Plan de Alimentación (Prioridad Media)

**Funcionalidades**:

- Crear plantillas de alimentación por etapa
- Definir raciones diarias
- Establecer programas de alimentación
- Ver historial de cambios

**Tablas necesarias**:

```sql
-- Migration: 20251017_create_feeding_plans_table.sql
CREATE TABLE feeding_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  stage VARCHAR(50), -- 'crecimiento', 'engorde', 'reproductores'
  min_weight NUMERIC,
  max_weight NUMERIC,
  daily_ration NUMERIC NOT NULL, -- kg por animal
  feed_type VARCHAR(100),
  frequency INTEGER, -- veces al día
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 5.4. Plan de Vacunación (Prioridad Media)

**Funcionalidades**:

- Crear calendarios de vacunación
- Definir vacunas y dosis
- Establecer intervalos y recordatorios
- Ver historial de vacunaciones

**Tablas necesarias**:

```sql
-- Migration: 20251017_create_vaccination_plans_table.sql
CREATE TABLE vaccination_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  vaccine_name VARCHAR(255) NOT NULL,
  description TEXT,
  animal_type VARCHAR(50), -- 'fattening', 'sow', 'boar'
  age_in_days INTEGER, -- edad recomendada
  dose VARCHAR(50),
  route VARCHAR(50), -- 'intramuscular', 'subcutánea', etc.
  frequency_days INTEGER, -- cada cuántos días
  notes TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Fase 6: Creación de Pantallas

> **✋ CHECKPOINT 6**: Se solicitará autorización antes de crear las pantallas del panel de administración

#### 6.1. Pantallas de Status

- **BlockedScreen**: Mensaje informando que la cuenta está bloqueada
- **PendingApprovalScreen**: Mensaje informando que la cuenta está pendiente de aprobación

#### 6.2. Panel de Administración

- **AdminDashboardScreen**: Dashboard principal con tarjetas de navegación
- **UserManagementScreen**: Lista de usuarios con acciones
- **FeedingPlanScreen**: Gestión de planes de alimentación
- **VaccinationPlanScreen**: Gestión de planes de vacunación

### Fase 7: Testing y Validación

> **✋ CHECKPOINT 7**: Se solicitará autorización antes de ejecutar los tests y validaciones finales

#### 7.1. Tests de Base de Datos

- Verificar políticas RLS
- Probar funciones de roles
- Validar permisos

#### 7.2. Tests de Flutter

- Tests unitarios para providers
- Tests de widgets para pantallas admin
- Tests de integración para flujo de autenticación con roles

## Orden de Ejecución

> **📋 NOTA**: Cada paso requiere autorización explícita antes de su ejecución. El proceso es iterativo y se puede pausar en cualquier checkpoint.

### Paso 1: Crear Nueva Rama

> **✋ AUTORIZACIÓN REQUERIDA**: Antes de crear las ramas de desarrollo

Este paso creará ramas de desarrollo en **dos lugares**:

#### 1.1. Rama en Supabase

- Nombre sugerido: `feature/role-based-access`
- Se creará usando el MCP de Supabase
- Duplicará la estructura de la base de datos actual
- Permitirá probar migrations sin afectar producción

#### 1.2. Rama en Git Local

- Nombre: `feature/role-based-access`
- Comandos a ejecutar:

```bash
git checkout -b feature/role-based-access
git push -u origin feature/role-based-access
```

**Beneficio**: Mantener sincronizadas las ramas de base de datos y código, facilitando el merge final coordinado.

### Paso 2: Migrations de Base de Datos (en orden)

> **✋ AUTORIZACIÓN REQUERIDA**: Corresponde a CHECKPOINT 1

1. `20251017_verify_roles_setup.sql`
2. `20251017_create_role_management_functions.sql`
3. `20251017_create_admin_panel_policies.sql`
4. `20251017_create_feeding_plans_table.sql`
5. `20251017_create_vaccination_plans_table.sql`

### Paso 3: Actualización de Modelos Flutter

> **✋ AUTORIZACIÓN REQUERIDA**: Corresponde a CHECKPOINT 2

1. Actualizar `user.dart`
2. Crear `user_role.dart`
3. Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs`

### Paso 4: Refactorización de Auth

> **✋ AUTORIZACIÓN REQUERIDA**: Corresponde a CHECKPOINT 3

1. Actualizar `auth_provider.dart`
2. Crear providers para roles

### Paso 5: Actualización del Router

> **✋ AUTORIZACIÓN REQUERIDA**: Corresponde a CHECKPOINT 4

1. Modificar `router.dart` con validaciones de roles
2. Crear pantallas de status

### Paso 6: Implementar Panel de Admin

> **✋ AUTORIZACIÓN REQUERIDA**: Corresponde a CHECKPOINT 5 y 6

1. Crear estructura de carpetas
2. Implementar gestión de usuarios
3. Implementar plan de alimentación
4. Implementar plan de vacunación

### Paso 7: Testing

> **✋ AUTORIZACIÓN REQUERIDA**: Corresponde a CHECKPOINT 7

1. Probar con usuario admin
2. Probar con usuario normal
3. Probar flujos de aprobación
4. Probar restricciones de acceso

### Paso 8: Merge a Producción

> **✋ AUTORIZACIÓN FINAL REQUERIDA**: Antes de hacer merge a producción

Este paso incluye el merge coordinado en ambos lugares:

#### 8.1. Validación Final en Ramas de Desarrollo

1. Probar todas las funcionalidades en la rama Supabase
2. Verificar que el código en la rama Git funciona correctamente
3. Revisar que no hay conflictos

#### 8.2. Merge en Supabase

1. Ejecutar merge de la rama de Supabase a producción
2. Verificar que las migrations se apliquen correctamente
3. Validar políticas RLS y funciones

#### 8.3. Merge en Git

1. Merge de `feature/role-based-access` a `main`
2. Push a repositorio remoto
3. Eliminar rama local si ya no es necesaria

#### 8.4. Documentación

1. Actualizar DOCUMENTATION.md con nuevas funcionalidades
2. Actualizar README.md si es necesario
3. Marcar checkpoints como completados en este documento

## Archivos a Crear/Modificar

### Crear (17 archivos nuevos)

1. `supabase/migrations/20251017_verify_roles_setup.sql`
2. `supabase/migrations/20251017_create_role_management_functions.sql`
3. `supabase/migrations/20251017_create_admin_panel_policies.sql`
4. `supabase/migrations/20251017_create_feeding_plans_table.sql`
5. `supabase/migrations/20251017_create_vaccination_plans_table.sql`
6. `lib/features/auth/models/user_role.dart`
7. `lib/features/auth/screens/blocked_screen.dart`
8. `lib/features/auth/screens/pending_approval_screen.dart`
9. `lib/features/admin/models/user_profile.dart`
10. `lib/features/admin/providers/user_management_provider.dart`
11. `lib/features/admin/providers/feeding_plan_provider.dart`
12. `lib/features/admin/providers/vaccination_plan_provider.dart`
13. `lib/features/admin/data/admin_repository.dart`
14. `lib/features/admin/presentation/admin_dashboard_screen.dart`
15. `lib/features/admin/presentation/views/user_management_view.dart`
16. `lib/features/admin/presentation/views/feeding_plan_view.dart`
17. `lib/features/admin/presentation/views/vaccination_plan_view.dart`

### Modificar (3 archivos)

1. `lib/features/auth/models/user.dart`
2. `lib/features/auth/providers/auth_provider.dart`
3. `lib/router.dart`

## Estimación de Tiempo

- **Fase 1**: 1 hora (Base de datos)
- **Fase 2**: 1 hora (Modelos)
- **Fase 3**: 2 horas (Auth provider)
- **Fase 4**: 2 horas (Router)
- **Fase 5**: 4 horas (Features admin)
- **Fase 6**: 3 horas (Pantallas)
- **Fase 7**: 2 horas (Testing)

**Total estimado**: 15 horas

## Notas Importantes

- La tabla `profiles` ya tiene el campo `role`, lo que simplifica la implementación
- Se deben preservar las migraciones y políticas existentes
- El sistema debe ser retrocompatible con usuarios existentes
- **Todos los cambios deben pasar por las ramas de desarrollo (Supabase + Git) antes de producción**
- Se debe mantener la documentación actualizada durante todo el proceso
- Las ramas de Supabase y Git deben mantenerse sincronizadas durante el desarrollo
- El merge final debe coordinarse en ambos lugares para evitar inconsistencias

## Riesgos y Mitigaciones

1. **Riesgo**: Conflicto con políticas RLS existentes

   - **Mitigación**: Revisar políticas antes de crear nuevas, usar nombres descriptivos

2. **Riesgo**: Usuarios existentes sin rol definido

   - **Mitigación**: Ya todos tienen rol 'user' por defecto

3. **Riesgo**: Romper autenticación actual

   - **Mitigación**: Trabajar en rama separada, probar exhaustivamente

4. **Riesgo**: Performance en lista de usuarios

   - **Mitigación**: Implementar paginación desde el inicio

5. **Riesgo**: Desincronización entre ramas de Supabase y Git

   - **Mitigación**:
     - Aplicar cambios de base de datos antes que el código
     - Documentar cada cambio en ambas ramas
     - Probar la integración regularmente
     - Hacer merge coordinado al final

6. **Riesgo**: Código apuntando a rama incorrecta de Supabase durante desarrollo

   - **Mitigación**:
     - Configurar proyecto para usar el project_id de la rama Supabase
     - Validar conexión antes de cada fase de testing
     - Documentar cómo cambiar entre ramas

7. **Riesgo**: Merge parcial (solo en Git o solo en Supabase)
   - **Mitigación**:
     - Checklist de merge que incluya ambos lugares
     - Validación post-merge en producción
     - Plan de rollback preparado

---

## 🚀 Cómo Proceder con la Implementación

### Paso Inicial: Revisión del Plan

1. **Lee el plan completo** para entender el alcance
2. **Identifica prioridades**: ¿Necesitas todas las funcionalidades o algunas pueden esperar?
3. **Valida la estimación de tiempo** con tu cronograma

### Para Iniciar la Implementación

**Comando para el agente**:

```
"Estoy listo para comenzar. Procede con el Paso 1: Crear Nueva Rama"
```

El agente:

1. Creará la rama de desarrollo en **Supabase** (`feature/role-based-access`)
2. Creará la rama de desarrollo en **Git** (`feature/role-based-access`)
3. Presentará un resumen de lo que hará en el CHECKPOINT 1
4. **Esperará tu autorización explícita** antes de ejecutar las migrations

**Importante**: A partir de este momento, todos los cambios se harán en las ramas de desarrollo hasta el merge final.

### Flujo de Trabajo por Checkpoint

```
CHECKPOINT → Autorización → Ejecución → Validación → Commit → Siguiente
    │
    ├─ Si es DB:    Cambios en rama Supabase
    │               └─ Migration aplicada
    │
    └─ Si es Código: Cambios en rama Git
                    └─ Commit realizado
```

### Para Autorizar Cada Fase

Después de revisar lo que se ejecutará, usa uno de estos comandos:

- ✅ **Autorizar**: `"Autorizo la ejecución del CHECKPOINT [número]"`
- ⏸️ **Pausar**: `"Pausa la implementación. Tengo preguntas sobre [tema]"`
- 🔄 **Modificar**: `"Modifica [aspecto] del CHECKPOINT [número] antes de continuar"`
- ❌ **Cancelar**: `"Cancela la implementación de esta fase"`

### Durante la Implementación

Después de cada checkpoint ejecutado:

1. El agente reportará los resultados
2. Mostrará los cambios realizados
3. Ejecutará validaciones básicas
4. **Esperará tu autorización** para continuar con el siguiente checkpoint

### Al Finalizar

Cuando todas las fases estén completadas y probadas:

```
"Autorizo el merge a producción"
```

El agente:

1. Realizará una validación final en ambas ramas
2. Ejecutará el merge de la rama Supabase a producción
3. Ejecutará el merge de la rama Git a main
4. Actualizará la documentación
5. Proporcionará un resumen completo de los cambios

**Nota**: El merge en Supabase aplicará todas las migrations a la base de datos de producción de forma irreversible. Por eso es crítico validar todo en la rama de desarrollo primero.

---

## 📝 Registro de Ejecución

Este documento servirá como referencia durante toda la implementación. Se recomienda actualizar esta sección conforme se complete cada fase:

### Estado de Ramas

- [ ] **Rama Supabase creada**: `feature/role-based-access`
- [ ] **Rama Git creada**: `feature/role-based-access`

### Estado de Checkpoints

- [ ] **CHECKPOINT 1** - Migrations de Base de Datos (en rama Supabase)
- [ ] **CHECKPOINT 2** - Actualización de Modelos Flutter (en rama Git)
- [ ] **CHECKPOINT 3** - Refactorización del Sistema de Autenticación (en rama Git)
- [ ] **CHECKPOINT 4** - Modificación del Router y Rutas Protegidas (en rama Git)
- [ ] **CHECKPOINT 5** - Implementación de Funcionalidades del Panel Admin (en rama Git)
- [ ] **CHECKPOINT 6** - Creación de Pantallas del Panel Admin (en rama Git)
- [ ] **CHECKPOINT 7** - Testing y Validación (en ambas ramas)
- [ ] **MERGE SUPABASE** - Merge a Producción (Base de datos)
- [ ] **MERGE GIT** - Merge a Main (Código)

### Commits Importantes

_Esta sección registrará los commits relevantes durante la implementación._

### Notas de Implementación

_Esta sección se actualizará durante la implementación con notas relevantes, problemas encontrados y soluciones aplicadas._

---

**Última actualización**: 17 de octubre de 2025
**Estado del plan**: ✅ Listo para ejecutar
**Requiere autorización para**: Crear rama y ejecutar CHECKPOINT 1
