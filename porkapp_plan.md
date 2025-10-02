
# 📌 Plan de Implementación — PorkApp (con Supabase)

Este documento define el plan de implementación de PorkApp, simplificado a las siguientes funcionalidades:
1. Autenticación con Supabase  
2. Gestión de Corrales  
3. Gestión de Lotes  
4. Gestión de Animales  
5. Gestión de Biometrías  

---

## **Fase 1 — Autenticación con Supabase**
🔑 Objetivo: permitir acceso seguro y controlado.

### Backend (Supabase Auth + DB)
- Activar **email + password** en Supabase.  
- Tabla `users` con control de estado (`active`) y rol (dueño, técnico, operario).  

```sql
create table users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  username text unique not null,
  active boolean default true,
  role text default 'farmer', -- farmer, admin, owner
  created_at timestamp default now(),
  last_login timestamp
);
```

### App (Flutter)
- Dependencias:  
  ```yaml
  supabase_flutter: ^2.0.0
  flutter_secure_storage: ^9.0.0
  ```  
- Flujo:  
  - **Splash:** valida si hay sesión activa.  
  - **Login:** `supabase.auth.signInWithPassword(email, password)`.  
  - Si `active=false` → acceso bloqueado.  
- Tokens almacenados en **Secure Storage**.  

### Dashboard Web (dueño/admin)
- Crear y administrar usuarios.  
- Activar/desactivar usuarios.  
- Reset de contraseñas.  

---

## **Fase 2 — Gestión de Corrales**
🏠 Objetivo: administrar espacios físicos donde se alojan los animales.

### Base de datos
```sql
create table corrals (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  location text,
  capacity int,
  notes text,
  created_at timestamp default now()
);
```

### App
- CRUD de corrales (crear, editar, eliminar, listar).  
- Campos: nombre, ubicación, capacidad, notas.  
- Relación con lotes y animales.  

---

## **Fase 3 — Gestión de Lotes**
📦 Objetivo: controlar grupos de animales dentro de corrales.

### Base de datos
```sql
create table batches (
  id uuid primary key default gen_random_uuid(),
  corral_id uuid references corrals(id) on delete cascade,
  name text not null,
  created_at date not null,
  headcount_start int not null,
  initial_avg_weight numeric,
  notes text
);
```

### App
- CRUD de lotes.  
- Asignación de lote a un corral.  
- Registro de cantidad inicial y peso promedio inicial.  

---

## **Fase 4 — Gestión de Animales**
🐷 Objetivo: registrar animales individuales dentro de un lote.

### Base de datos
```sql
create table animals (
  id uuid primary key default gen_random_uuid(),
  batch_id uuid references batches(id) on delete cascade,
  ear_tag text unique,            -- arete o identificador individual
  birth_date date,
  sex text check (sex in ('M','F')),
  weight_at_entry numeric,
  status text default 'alive',    -- alive, sold, dead
  created_at timestamp default now()
);
```

### App
- CRUD de animales individuales.  
- Identificación por número de arete o código.  
- Estado del animal (vivo, vendido, muerto).  

---

## **Fase 5 — Gestión de Biometrías**
📊 Objetivo: registrar mediciones de peso de cada animal.

### Base de datos
```sql
create table biometrics (
  id uuid primary key default gen_random_uuid(),
  animal_id uuid references animals(id) on delete cascade,
  date date not null,
  weight numeric not null,
  notes text,
  created_at timestamp default now()
);
```

### App
- CRUD de biometrías.  
- Medidas: **peso** y **notas**.  
- Visualización gráfica por animal (línea de tiempo de peso).  

---

## **Roadmap resumido**
1. **Fase 1 — Autenticación con Supabase** ✅  
2. **Fase 2 — Gestión de Corrales**  
3. **Fase 3 — Gestión de Lotes**  
4. **Fase 4 — Gestión de Animales**  
5. **Fase 5 — Gestión de Biometrías**  

---

## 🔗 Diagrama de relaciones (ERD simplificado)

```
Corrals (1) ─── (N) Batches (1) ─── (N) Animals (1) ─── (N) Biometrics
```

- **Corral** → contiene lotes.  
- **Lote** → agrupa animales.  
- **Animal** → tiene varios registros de biometría (peso + notas).  


📍 Definición del enrutamiento (GoRouter)
Rutas principales

Siempre arranca en /login.

El login exitoso redirige a /dashboard.

Barra inferior conecta Corrales → Dashboard → Lotes (con Animales) → Biometrías.


mas detallado: 

/login → Pantalla de autenticación.

/dashboard → Vista principal (resumen).

/corrals → Gestión de corrales.

/batches → Gestión de lotes.

/batches/:batchId → Detalle de lote específico.

Dentro de cada lote → gestión de Animales.

/biometrics → Módulo de biometrías (peso, medidas, etc.).

Flujo esperado

Usuario abre app → se muestra Login (/login).

Tras login exitoso → context.go('/dashboard').

Desde Dashboard se navega con la barra inferior (BottomNav):

Corrales → /corrals

Dashboard → /dashboard

Lotes → /batches

Al seleccionar un lote → /batches/:batchId (incluye sus animales).

Biometrías → /biometrics