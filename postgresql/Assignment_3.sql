-- Drop and create the tables

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
    track TEXT,
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

-- Insert data into the tables
COPY track (title, artist,album,count,rating,len) FROM stdin WITH (FORMAT CSV, DELIMITER ',') ;

--Update the rest of the tables using the data from the track table

INSERT INTO album (title) SELECT DISTINCT album FROM track;
UPDATE track SET album_id = (SELECT album.id FROM album WHERE album.title = track.album);

INSERT INTO artist (name) SELECT DISTINCT artist FROM track;

INSERT INTO tracktoartist (track, artist) SELECT DISTINCT title, artist FROM track;
UPDATE tracktoartist SET track_id = (SELECT track.id FROM track WHERE track.title = tracktoartist.track);
UPDATE tracktoartist SET artist_id = (SELECT artist.id FROM artist WHERE artist.name = tracktoartist.artist);

-- We are now done with these text fields and we will remove columns we don't need anymore


ALTER TABLE track DROP COLUMN album;
ALTER TABLE track DROP COLUMN artist;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE tracktoartist DROP COLUMN artist;

-- We run the query to review if this results is the correct one

SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
LIMIT 3;


