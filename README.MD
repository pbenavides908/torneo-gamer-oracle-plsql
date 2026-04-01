# 🎮 Proyecto Torneo Gamer - Base de Datos Oracle PL/SQL

## 📌 Descripción

Este proyecto consiste en el diseño e implementación de una base de datos para la gestión de torneos de videojuegos (eSports), utilizando Oracle SQL y PL/SQL.

El sistema permite administrar:
- Jugadores
- Equipos
- Torneos
- Partidas
- Puntajes

El objetivo es simular un sistema real de gestión competitiva, aplicando buenas prácticas de modelado relacional y programación en base de datos.

---

## 🧠 Objetivo del Proyecto

Desarrollar una solución que permita:
- Organizar torneos gamer
- Registrar equipos y jugadores
- Gestionar partidas
- Calcular resultados y rankings

---

## 🏗️ Estructura del Proyecto

```
📁 torneo-gamer-db
│
├── 📁 sql
│   ├── 01_schema.sql     -- Creación de tablas
│   ├── 02_data.sql       -- Inserción de datos
│   ├── 03_queries.sql    -- Consultas SQL
│   └── 04_plsql.sql      -- Procedimientos, funciones y bloques PL/SQL
│
└── README.md
```

---

## 🗄️ Modelo de Datos

El sistema incluye las siguientes entidades principales:

- **jugadores**
- **equipos**
- **jugadores_equipos**
- **torneos**
- **partidas**
- **puntajes**

### Relaciones clave:
- Un jugador puede pertenecer a uno o varios equipos
- Un equipo puede tener múltiples jugadores
- Un torneo contiene múltiples partidas
- Cada partida involucra dos equipos
- Cada partida genera puntajes por equipo

---

## ⚙️ Tecnologías Utilizadas

- Oracle SQL  
- PL/SQL  
- SQL Developer / VS Code  

---

## 🚀 Cómo ejecutar el proyecto

### 1. Activar salida de consola
```sql
SET SERVEROUTPUT ON;
```

### 2. Ejecutar los scripts en orden
```sql
-- Crear estructura
@sql/01_schema.sql

-- Insertar datos
@sql/02_data.sql

-- Ejecutar consultas
@sql/03_queries.sql

-- Ejecutar lógica PL/SQL
@sql/04_plsql.sql
```

---

## 📊 Funcionalidades implementadas

### 🔹 SQL
- Consultas con `JOIN`
- Filtros con `WHERE`
- Ordenamientos con `ORDER BY`
- Agrupaciones con `GROUP BY`
- Funciones de agregación (`SUM`, `COUNT`, `AVG`)
- Formato de fechas y números con `TO_CHAR`

### 🔹 PL/SQL
- Bloques anónimos  
- Funciones  
- Procedimientos almacenados  
- Cursores  
- Manejo de excepciones  
- Uso de `%TYPE`  
- Uso de `DBMS_OUTPUT`  

---

## 📌 Ejemplos de funcionalidades

- Listar jugadores con sus equipos  
- Mostrar ranking de equipos por puntaje  
- Calcular puntos acumulados por equipo  
- Registrar ganador de una partida  
- Actualizar estado de torneos y partidas  
- Clasificar torneos según premio  

---

## 📈 Estado del Proyecto

### ✅ Completado
- Modelo relacional  
- Creación de tablas  
- Inserción de datos (20 registros por tabla)  
- Consultas SQL  
- Procedimientos y funciones PL/SQL  

### 🔜 Mejoras futuras
- Uso de `PACKAGE`  
- Implementación de `SAVEPOINT` y `ROLLBACK`  
- Optimización con `BULK COLLECT` y `FORALL`  
- Validaciones más avanzadas  
- Automatización de procesos  

---

## 👨‍💻 Autor

Proyecto desarrollado como práctica de base de datos Oracle PL/SQL.

---

## 📎 Notas

Este proyecto es de carácter educativo y simula un sistema real de gestión de torneos gamer.

---

## ⭐ Recomendaciones

Para mejorar este proyecto:
- Agregar capturas de ejecución  
- Mostrar resultados de consultas  
- Documentar casos de uso  
- Subirlo a GitHub con commits ordenados  

Ejemplo de commits:
```bash
feat: create database schema
feat: insert sample data
feat: add SQL queries
feat: add PL/SQL logic
docs: add README
```