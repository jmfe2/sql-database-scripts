— Crear todas las tablas

DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

DROP TABLE category;

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE state (
  id SERIAL,
  name TEXT UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE region (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE iso (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

— Crear la tabla donde se alojaran datos limpios

CREATE TABLE unesco (
	name TEXT, 
	description TEXT, 
	justification TEXT, 
	year INTEGER,
	longitude FLOAT, 
	latitude FLOAT, 
	area_hectares FLOAT,
	category_id INTEGER REFERENCES category(id) ON DELETE CASCADE,
	state_id INTEGER REFERENCES state(id) ON DELETE CASCADE,
	region_id INTEGER REFERENCES region(id) ON DELETE CASCADE,
	iso_id INTEGER REFERENCES iso(id) ON DELETE CASCADE
);

— Insertar datos a la tabla Unesco_raw

COPY unesco_raw(name,description,justification,year,longitude,latitude,area_hectares,category,state,region,iso) FROM stdin WITH (FORMAT CSV, D
ELIMITER ',', HEADER);

— Obtener datos únicos para todas las tablas con las que se relacionará con la tabla unesco

INSERT INTO category (name)
SELECT DISTINCT category
FROM unesco_raw
ON CONFLICT (name) DO NOTHING;

INSERT INTO state (name)
SELECT DISTINCT state
FROM unesco_raw
ON CONFLICT (name) DO NOTHING;

INSERT INTO region (name)
SELECT DISTINCT region
FROM unesco_raw
ON CONFLICT (name) DO NOTHING;

INSERT INTO iso (name)
SELECT DISTINCT iso
FROM unesco_raw
ON CONFLICT (name) DO NOTHING;

— Actualizar los _id en la tabla Unesco_raw
— Explicar como funciona, además el orden tiene que ser el mismo? No puede ser unesco_raw.somehting = something.name?
UPDATE unesco_raw
SET category_id = category.id
FROM category
WHERE category.name = unesco_raw.category;

UPDATE unesco_raw
SET state_id = state.id
FROM state
WHERE state.name = unesco_raw.state;

UPDATE unesco_raw
SET region_id = region.id
FROM region
WHERE region.name = unesco_raw.region;

UPDATE unesco_raw
SET iso_id = iso.id
FROM iso
WHERE iso.name = unesco_raw.iso;

— Insertar datos limpios en la tabla unesco desde la tabla (ahora completa) unesco_raw y sin tomar en cuenta los no normalizados

INSERT INTO unesco (
	name, 
	description, 
	justification, 
	year,
	longitude, 
	latitude, 
	area_hectares,
	category_id,
	state_id,
	region_id,
	iso_id)
SELECT name, 
	description, 
	justification, 
	year,
	longitude, 
	latitude, 
	area_hectares,
	category_id,
	state_id,
	region_id,
	iso_id
FROM unesco_raw;

— se verifica que los resultados coincidan con el ejercicio

SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY iso.name, unesco.name
  LIMIT 3;


