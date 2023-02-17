-- Name: Trisha Karani
-- JHEDID: tkarani1

DROP TABLE IF EXISTS AlbumReleases; 
DROP TABLE IF EXISTS SongReleases; 
DROP TABLE IF EXISTS AlbumTracks; 
DROP TABLE IF EXISTS Artist; 
DROP TABLE IF EXISTS SpotifyChart;
DROP TABLE IF EXISTS Song; 
DROP TABLE IF EXISTS Album; 
DROP TABLE IF EXISTS CountryHappiness; 
 

CREATE OR REPLACE TABLE Artist (
    artistID VARCHAR(100),
    artistName VARCHAR(100), 
    followers INT, 
    popularity INT, 
    artistType VARCHAR(50), 
    artistGenre VARCHAR(50), 
    PRIMARY KEY(artistID)
);


CREATE OR REPLACE TABLE Song (
    songID VARCHAR(100), 
    songName VARCHAR(100), 
    explicit TINYINT(1) DEFAULT 0, 
    duration INT, 
    acousticness FLOAT, 
    danceability FLOAT, 
    energy FLOAT, 
    instrumentalness FLOAT, 
    liveness FLOAT, 
    loudness FLOAT,
    speechiness FLOAT, 
    valence FLOAT,
    tempo FLOAT,
    lyrics TEXT, 
    PRIMARY KEY(songID)
);

CREATE OR REPLACE TABLE Album (
    albumID VARCHAR(100), 
    albumName VARCHAR(100), 
    numTracks INT, 
    PRIMARY KEY(albumID)
);

CREATE OR REPLACE TABLE AlbumReleases (
    albumID VARCHAR(100), 
    artistID VARCHAR(100), 
    releaseDate DATE,
    PRIMARY KEY(albumID, artistID),
    FOREIGN KEY(albumID) REFERENCES Album(albumID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(artistID) REFERENCES Artist(artistID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE TABLE SongReleases (
    songID VARCHAR(100),
    artistID VARCHAR(100), 
    songType VARCHAR(50), 
    numArtists INT, 
    PRIMARY KEY(songID, artistID),
    FOREIGN KEY(songID) REFERENCES Song(songID) ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY(artistID) REFERENCES Artist(artistID) ON DELETE CASCADE ON UPDATE CASCADE
); 

CREATE OR REPLACE TABLE AlbumTracks (
    songID VARCHAR(100),
    albumID VARCHAR(100),
    trackNumber INT, 
    PRIMARY KEY(songID, albumID),
    FOREIGN KEY(songID) REFERENCES Song(songID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(albumID) REFERENCES Album(albumID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE OR REPLACE TABLE CountryHappiness (
    year YEAR, 
    country VARCHAR(50), 
    happinessRank INT, 
    happinessScore FLOAT, 
    GDP FLOAT,
    PRIMARY KEY(country, year) 
);

CREATE OR REPLACE TABLE SpotifyChart (
    country VARCHAR(50), 
    startDate DATE, 
    endDate DATE, 
    pos INT, 
    songID VARCHAR(100), 
    numStreams INT,
    PRIMARY KEY(country, startDate, pos), 
    FOREIGN KEY(songID) REFERENCES Song(songID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(country) REFERENCES CountryHappiness(country) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK(startDate < endDate)
);

LOAD DATA LOCAL INFILE './Artist.txt' 
INTO TABLE Artist;

LOAD DATA LOCAL INFILE './Song.txt' 
INTO TABLE Song;

LOAD DATA LOCAL INFILE './Album.txt' 
INTO TABLE Album;

LOAD DATA LOCAL INFILE './AlbumReleases.txt' 
INTO TABLE AlbumReleases;

LOAD DATA LOCAL INFILE './SongReleases.txt' 
INTO TABLE SongReleases;

LOAD DATA LOCAL INFILE './AlbumTracks.txt' 
INTO TABLE AlbumTracks;

LOAD DATA LOCAL INFILE './CountryHappiness.txt' 
INTO TABLE CountryHappiness;

LOAD DATA LOCAL INFILE './SpotifyChart.txt' 
INTO TABLE SpotifyChart;

DELIMITER //

-- Insertion into the SongReleases table
DROP PROCEDURE IF EXISTS InsertSongIfIDExists //
CREATE PROCEDURE InsertSongIfIDExists(IN songID VARCHAR(100), IN artistID VARCHAR(100), IN songType VARCHAR(50), IN numArtists INT)
BEGIN
    INSERT INTO SongReleases VALUES (songID, artistID, songType, numArtists);
    -- SongReleases has foreign key constraints of SongID and artistID
    -- In this insert, we are checking if songID exists in Song and artistID exists in Artist before inserting
END; //

DROP PROCEDURE IF EXISTS InsertSongIfIDNotExists //
CREATE PROCEDURE InsertSongIfIDNotExists (IN songID VARCHAR(100), IN artistID VARCHAR(100), IN songType VARCHAR(50), IN numArtists INT)
BEGIN
    INSERT INTO Song VALUES (songID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO SongReleases VALUES (songID, artistID, songType, numArtists);
    -- SongReleases has foreign key constraints of SongID and artistID
    -- In this insert, we find that songID doesn't exist in the Song table
END; //

-- Deletion from CountryHappiness
DROP PROCEDURE IF EXISTS DeleteFromCountryHappiness //
CREATE PROCEDURE DeleteFromCountryHappiness(IN c VARCHAR(50))
BEGIN
    DELETE FROM SpotifyChart WHERE country = c;
    DELETE FROM CountryHappiness WHERE country = c;
    -- The country in CountryHappiness is a foreign key constraint for SpotifyChart
    -- Must delete all chart data for a country before deleting the country data
END; //

DROP PROCEDURE IF EXISTS DeleteFromAlbumTracks //
CREATE PROCEDURE DeleteFromAlbumTracks(IN s_id VARCHAR(100), IN a_id VARCHAR(100))
BEGIN
    DELETE FROM AlbumTracks WHERE songID = s_id and albumID = a_id;
    -- there are no foreign key constraints from the AlbumTracks table, so tuples can be deleted

END; //

DELIMITER ;
