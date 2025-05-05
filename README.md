# 🎵 ETL de Tracks y Álbumes – SQL Relacional

Este proyecto es una práctica de modelado y transformación de datos en SQL, utilizando un esquema relacional con claves foráneas. Se enfoca en simular un pequeño proceso ETL (Extract, Transform, Load) para organizar y normalizar información musical extraída de un archivo CSV.

## 📌 Objetivo

Modelar una base de datos relacional que represente álbumes y canciones, cargando datos crudos en una tabla (`track_raw`) y distribuyéndolos de forma normalizada en las tablas `album` y `track`.

## 🛠️ Lo que implementa

- Creación de tablas normalizadas con claves primarias y foráneas.
- Carga de datos desde CSV con el comando `\copy`.
- Inserción de álbumes únicos en una tabla relacional.
- Actualización de claves foráneas mediante subconsultas (`UPDATE ... SET`).
- Inserción de registros en tabla final usando `INSERT ... SELECT`.
- Prueba final con `JOIN` entre `track` y `album`.

## 📂 Estructura de Tablas

```sql
CREATE TABLE album (
  id SERIAL,
  title VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE track (
    id SERIAL,
    title VARCHAR(128),
    len INTEGER, rating INTEGER, count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw
 (title TEXT, artist TEXT, album TEXT, album_id INTEGER,
  count INTEGER, rating INTEGER, len INTEGER);
```

## 📊 Resultado Esperado (JOIN final)

```sql
SELECT track.title, album.title
    FROM track
    JOIN album ON track.album_id = album.id
    ORDER BY track.title LIMIT 3;
```

Resultado esperado:

| track                     | album                               |
|--------------------------|-------------------------------------|
| A Boy Named Sue (live)   | The Legend Of Johnny Cash           |
| A Brief History of Packets | Computing Conversations           |
| Aguas De Marco           | Natural Wonders Music Sampler 1999 |

## ✅ Aprendizajes

- Relaciones uno-a-muchos en SQL (`FOREIGN KEY`)
- Limpieza y transformación de datos antes de insertarlos en tablas finales
- Subconsultas y `INSERT ... SELECT` como herramienta de transformación
- Validación de relaciones entre tablas con `JOIN`

## 📎 Requisitos

- PostgreSQL
- CSV con datos crudos
- Acceso a la terminal para ejecutar `\copy`
