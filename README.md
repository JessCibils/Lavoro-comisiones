# Comisiones Consultoras - Vercel + Supabase

Esta carpeta contiene la version preparada para publicar en Vercel usando Supabase para login y base de datos.

## 1. Crear tablas en Supabase

En Supabase:

1. Abrir el proyecto.
2. Ir a **SQL Editor**.
3. Pegar el contenido de `supabase/schema.sql`.
4. Ejecutar.

## 2. Configurar login

En Supabase:

1. Ir a **Authentication > Providers**.
2. Dejar habilitado **Email**.
3. En **Authentication > URL Configuration**, agregar la URL de Vercel cuando exista.

## 3. Configurar la app

Abrir `public/index.html` y reemplazar:

- `TU_SUPABASE_URL`
- `TU_SUPABASE_ANON_KEY`

Estos datos estan en Supabase, en **Project Settings > API**.

## 4. Publicar en Vercel

Subir esta carpeta a GitHub y luego:

1. En Vercel, elegir **Add New > Project**.
2. Importar el repositorio.
3. Framework: **Other**.
4. Build command: vacio o `npm run build`.
5. Output directory: `public`.
6. Deploy.

## Seguridad

La app usa Supabase Auth y politicas RLS. Cada usuario autenticado solo puede leer y modificar sus propios datos.
