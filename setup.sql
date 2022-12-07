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
    explicit INT, 
    duration INT, 
    acousticness INT, 
    danceability INT, 
    energy INT, 
    instrumentalness INT, 
    liveness INT, 
    loudness INT,
    speechiness INT, 
    valence INT,
    tempo INT,
    lyrics VARCHAR(5000), 
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
    releaseDate DATETIME,
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
    country VARCHAR(50), 
    year DATETIME, 
    rank INT, 
    score INT, 
    GDP INT,
    PRIMARY KEY(country, year) 
);

CREATE OR REPLACE TABLE SpotifyChart (
    country VARCHAR(50), 
    startDate DATETIME, 
    endDate DATETIME, 
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