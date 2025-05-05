-- Crear tabla de álbumes
CREATE TABLE album (
  id SERIAL PRIMARY KEY,
  title VARCHAR(128) UNIQUE
);

-- Crear tabla de canciones (tracks)
CREATE TABLE track (
  id SERIAL PRIMARY KEY,
  title VARCHAR(128),
  len INTEGER,
  rating INTEGER,
  count INTEGER,
  album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
  UNIQUE(title, album_id)
);

-- Eliminar y crear tabla adicional para carga de datos
DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw (
  title TEXT,
  artist TEXT,
  album TEXT,
  album_id INTEGER,
  count INTEGER,
  rating INTEGER,
  len INTEGER
);

-- Cargar archivo CSV en la tabla temporaadicional 

-- Opción A (recomendada si usas psql desde la terminal):
-- \copy track_raw(title, artist, album, len, rating, count) 
-- FROM 'tracks.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Opción B (si deseas pegar los datos manualmente por stdin, menos común):
-- COPY track_raw(title, artist, album, len, rating, count) 
-- FROM stdin WITH (FORMAT CSV, DELIMITER ',');
-- Después deberías pegar los datos directamente y terminar con: \. u otra opcion, de acuerdo a tu sistema operativo
COPY track_raw  (title, artist, album, len, rating, count) 
FROM stdin 
WITH (FORMAT CSV, DELIMITER ',');

-- Insertar álbumes únicos
INSERT INTO album (title)
SELECT DISTINCT album
FROM track_raw
ON CONFLICT (title) DO NOTHING;

-- Actualizar album_id en track_raw
UPDATE track_raw
SET album_id = album.id
FROM album
WHERE album.title = track_raw.album;

-- Insertar datos limpios en la tabla track
INSERT INTO track (title, len, rating, count, album_id)
SELECT title, len, rating, count, album_id
FROM track_raw;

-- Verificar que los resultados coincidan con el ejercicio
SELECT track.title, album.title
FROM track
JOIN album ON track.album_id = album.id
ORDER BY track.title
LIMIT 3;

