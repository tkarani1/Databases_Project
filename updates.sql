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
