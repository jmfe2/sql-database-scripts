# sql-ejercicios

Este repositorio contiene mis ejercicios de SQL, principalmente en PostgreSQL, realizados durante mi aprendizaje. El objetivo es demostrar mi comprensión de los conceptos de bases de datos relacionales y mi habilidad para escribir consultas SQL para resolver problemas específicos.

## Estructura del Repositorio

Los ejercicios están organizados por assignment, cada uno con su propia sección que incluye:

* Descripción del problema
* Esquema de las tablas involucradas
* Resultado esperado de las consultas de evaluación

## Assignments Completados

### 1) Musical Tracks Many-to-One

**Descripción:**

Este assignment se centra en la creación de una relación muchos-a-uno entre canciones (`track`) y álbumes (`album`). El proceso implica:

* Cargar datos de canciones desde un archivo CSV a una tabla temporal (`track_raw`).
* Insertar los títulos de álbumes distintos en la tabla `album`.
* Establecer la columna `album_id` en la tabla `track_raw` para conectar cada canción con su álbum correspondiente.
* Copiar los datos de la tabla `track_raw` a la tabla `track`, excluyendo las columnas `artist` y `album`.

**Esquema de las Tablas:**

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
CREATE TABLE track_raw (
 title TEXT, artist TEXT, album TEXT, album_id INTEGER,
  count INTEGER, rating INTEGER, len INTEGER
);

Consulta de Evaluación y Resultado Esperado:

La siguiente consulta se utiliza para evaluar la correcta implementación de la relación muchos-a-uno:

SELECT track.title, album.title
    FROM track
    JOIN album ON track.album_id = album.id
    ORDER BY track.title LIMIT 3;

Resultado esperado:

track.title                       | album.title
-----------------------------------|-----------------------------------------
A Boy Named Sue (live)            | The Legend Of Johnny Cash
A Brief History of Packets        | Computing Conversations
Aguas De Marco                    | Natural Wonders Music Sampler 1999

<<<<<<< HEAD
2) Unesco Heritage Sites Many-to-One
Descripción:

Este assignment aborda la normalización de datos relacionados con los sitios del Patrimonio Mundial de la UNESCO. El proceso incluye:

Cargar datos desde un archivo CSV a la tabla unesco_raw.

=======

### 2) Unesco Heritage Sites Many-to-One

Descripción:

Este assignment aborda la normalización de datos relacionados con los sitios del Patrimonio Mundial de la UNESCO. El proceso incluye:

Cargar datos desde un archivo CSV a la tabla unesco_raw.

>>>>>>> 012f8e0 (Adding files to the repository)
Crear tablas de búsqueda (lookup) para category, state, region e iso.

Normalizar los datos en unesco_raw poblando las tablas de búsqueda y añadiendo las columnas de clave externa correspondientes.

Crear una nueva tabla unesco que contiene los datos normalizados, eliminando las columnas de texto redundantes.

Esquema de las Tablas (Parcial):

DROP TABLE unesco_raw;
CREATE TABLE unesco_raw (
 name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER
);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- ... (Es necesario crear tablas similares para state, region, iso)

Consulta de Evaluación y Resultado Esperado:

La siguiente consulta evalúa la correcta normalización y las relaciones entre las tablas:

SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY iso.name, unesco.name
  LIMIT 3;

Resultado esperado:

name                                                | year | category.name | state.name          | region.name             | iso.name
-----------------------------------------------------|------|---------------|---------------------|-------------------------|----------
Madriu-Perafita-Claror Valley                       | 2004 | Cultural      | Andorra             | Europe and North America| ad
Cultural Sites of Al Ain (Hafit, Hili, Bidaa Bint Saud and Oases Areas) | 2011 | Cultural      | United Arab Emirates| Arab States             | ae
Cultural Landscape and Archaeological Remains of the Bamiyan Valley | 2003 | Cultural      | Afghanistan         | Asia and the Pacific    | af

<<<<<<< HEAD
3) Musical Track Database plus Artists
=======
### 3) Musical Track Database plus Artists
>>>>>>> 012f8e0 (Adding files to the repository)
Descripción:

Este assignment extiende el primer ejercicio para construir una relación muchos-a-muchos entre canciones (track) y artistas (artist) utilizando una tabla de unión (tracktoartist). A diferencia de los ejercicios anteriores, se utilizan sentencias ALTER TABLE para eliminar columnas después de crear las relaciones de clave externa.

Esquema de las Tablas:

DROP TABLE album CASCADE;
CREATE TABLE album (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE track CASCADE;
CREATE TABLE track (
    id SERIAL,
    title TEXT,
    artist TEXT,
    album TEXT,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    count INTEGER,
    rating INTEGER,
    len INTEGER,
    PRIMARY KEY(id)
);

DROP TABLE artist CASCADE;
CREATE TABLE artist (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE tracktoartist CASCADE;
CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

Consulta de Evaluación y Resultado Esperado:

La siguiente consulta evalúa la relación muchos-a-muchos entre canciones y artistas:

SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
ORDER BY track.title
LIMIT 3;

Resultado esperado:

track.title                       | album.title                       | artist.name
-----------------------------------|------------------------------------|----------------------
A Boy Named Sue (live)            | The Legend Of Johnny Cash         | Johnny Cash
A Brief History of Packets        | Computing Conversations           | IEEE Computer Society
Aguas De Marco                    | Natural Wonders Music Sampler 1999 | Rosa Passos

Próximos Pasos
Continuaré añadiendo más assignments y ejercicios a este repositorio a medida que profundice en mi estudio de SQL y bases de datos relacionales.
<<<<<<< HEAD
=======

### (4 Regular Expressions)

create a regular expression to retrieve a subset data from the purpose column of the taxdata table in the readonly database (access details below). Write a regular expressions to retrieve that meet the following criteria:

SELECT purpose FROM taxdata WHERE purpose ~ '^[A-Z]' ORDER BY purpose DESC LIMIT 3;

Here are the first few lines:

YOUTH WRITING WORKSHOPS ACADEMIC SUPPORT
YOUTH WRESTLING CLUB SUPPORTED YOUTH WRESTLING
YOUTH WORK THERAPY PROGRAMS

Here is the schema for the taxdata table:

readonly=# \d+ taxdata
  Column  |          Type          |
----------+------------------------+
 id       | integer                |
 ein      | integer                |
 name     | character varying(255) |
 year     | integer                |
 revenue  | bigint                 |
 expenses | bigint                 |
 purpose  | text                   |
 ptid     | character varying(255) |
 ptname   | character varying(255) |
 city     | character varying(255) |
 state    | character varying(255) |
 url      | character varying(255) |
>>>>>>> 012f8e0 (Adding files to the repository)
