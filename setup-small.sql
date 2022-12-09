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

LOAD DATA LOCAL INFILE './Artist-small.txt'
INTO TABLE Artist;

LOAD DATA LOCAL INFILE './Song-small.txt'
INTO TABLE Song;

LOAD DATA LOCAL INFILE './Album-small.txt'
INTO TABLE Album;

LOAD DATA LOCAL INFILE './AlbumReleases-small.txt'
INTO TABLE AlbumReleases;

LOAD DATA LOCAL INFILE './SongReleases-small.txt'
INTO TABLE SongReleases;

LOAD DATA LOCAL INFILE './AlbumTracks-small.txt'
INTO TABLE AlbumTracks;

LOAD DATA LOCAL INFILE './CountryHappiness-small.txt'
INTO TABLE CountryHappiness;

LOAD DATA LOCAL INFILE './SpotifyChart-small.txt'
INTO TABLE SpotifyChart;
