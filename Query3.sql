DROP PROCEDURE IF EXISTS Query3;

DELIMITER //

CREATE PROCEDURE Query3(IN this_genre VARCHAR(50))

BEGIN

IF (SELECT COUNT(artistGenre) FROM Artist WHERE artistGenre = this_genre > 0) THEN

WITH 
PopArtists AS (
    SELECT * 
    FROM Artist
    WHERE artistGenre = this_genre ), 
PopArtistSongID AS (
    SELECT songID as sid
    FROM PopArtists JOIN SongReleases ON PopArtists.artistID = SongReleases.artistID
    ), 
PopSongs AS (
    SELECT * 
    FROM Song JOIN PopArtistSongID ON Song.songID = PopArtistSongID.sid
    ) 
SELECT ROUND(avg(duration), 2) as avg_duration, 
    ROUND(avg(danceability), 2) as avg_danceability, 
    ROUND(avg(energy), 2) as avg_energy, 
    ROUND(avg(instrumentalness), 2) as avg_instrumentalness, 
    ROUND(avg(liveness), 2) as avg_liveness,
    ROUND(avg(speechiness), 2) as avg_speechiness,
    ROUND(avg(valence), 2) as avg_valence,
    ROUND(avg(tempo), 2) as avg_tempo
    FROM PopSongs;

END IF; 

END; //

DELIMITER ;