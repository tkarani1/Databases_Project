-- Name: Trisha Karani
-- JHEDID: tkarani1

-- 1
-- What top charting song had the most streams in a country (say the U.S.) in a year (2018)?
WITH 
MostStreams AS (
    SELECT songID, MAX(numStreams) as maxStreams
    FROM SpotifyChart
    WHERE YEAR(startDate) = 2018 and YEAR(endDate) = 2018 and country = 'United States')

SELECT songName, MostStreams.songID, MostStreams.maxStreams
FROM Song JOIN MostStreams ON Song.songID = MostStreams.songID;

-- maybe also get artist names 

-- 2
-- What percent of top charting songs are explicit?
WITH 
TopSongs AS (SELECT DISTINCT songID as songID
            FROM SpotifyChart),

SongCount AS (SELECT count(songID) as num_songs
            FROM TopSongs), 

ExpCount AS (SELECT sum(explicit) as exp_count
            FROM TopSongs JOIN Song ON TopSongs.songID = Song.songID)

SELECT ROUND(100 * exp_count / num_songs,2) AS PercentExplicit
        FROM SongCount JOIN ExpCount;


-- 3
-- What are the average metrics for songs by artists from a certain genre (say, "pop")
WITH 
PopArtists AS (
    SELECT * 
    FROM Artist
    WHERE artistGenre = "pop" ), 
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

-- 4
-- What top charting songs include the word "love"?
WITH 
TopSongs AS (SELECT DISTINCT songID as songID
            FROM SpotifyChart
            WHERE pos <= 5)
SELECT songName 
FROM Song JOIN TopSongs ON Song.songID = TopSongs.songID
WHERE LOWER(lyrics) LIKE "% love %";
-- um maybe too many songs

-- 5
-- Which songs by [artist] (Post Malone) have the word [] (love)?
WITH
ArtistSongID AS (SELECT DISTINCT songID
                FROM SongReleases JOIN Artist ON SongReleases.artistID = Artist.artistID
                WHERE artistName LIKE "Post Malone")
SELECT songName
    FROM Song JOIN ArtistSongID ON Song.songID = ArtistSongID.songID
    WHERE LOWER(lyrics) LIKE "% love %";


-- 6
-- Which albums had more than one song in the top 10 of the charts?
WITH 
Top10Song AS (SELECT DISTINCT songID AS sid 
                FROM SpotifyChart
                WHERE pos <= 25), -- this is an empty set in the small data set for 10, use 25 for testing
Top10SongAlbums AS (SELECT * 
                FROM AlbumTracks JOIN Top10Song ON AlbumTracks.songID = Top10Song.sid),
AlbumSongCount AS (SELECT *, count(*) AS NumTop10Songs
                FROM Top10SongAlbums
                GROUP BY albumID),
UniqueAlbums AS (SELECT DISTINCT albumID 
    FROM AlbumSongCount
    WHERE NumTop10Songs > 1)
SELECT albumName 
    FROM UniqueAlbums JOIN Album ON UniqueAlbums.albumID = Album.albumID;

-- 7 
-- Which artists had collaborations that were on the charts?
WITH 
Collabs AS (SELECT * FROM SongReleases WHERE numArtists > 1), -- this is an empty set in the small data set
ChartCollabs AS (SELECT DISTINCT artistID 
                FROM Collabs JOIN SpotifyChart ON Collabs.songID = SpotifyChart.songID)

SELECT artistName
FROM Artist JOIN ChartCollabs ON Artist.artistID = ChartCollabs.artistID;


-- 9 
-- What was the minimum number of streams for a song to be #1 in each country?
SELECT country, YEAR(startDate) as year, min(numStreams) as minStreams      -- double check that this works
    FROM SpotifyChart 
    WHERE pos <25  -- change to pos = 1 in final version
    GROUP BY country, YEAR(startDate);




-- 11
-- What is the average danceability for top 10 songs in each country vs their happiness score?
WITH
Top10SongPerCountry AS (SELECT country, YEAR(startDate) as year, songID 
                    FROM SpotifyChart 
                    WHERE pos <= 25),
TopSongDance AS (SELECT danceability, year, country, songName, Song.songID
                FROM Top10SongPerCountry JOIN Song ON Top10SongPerCountry.songID = Song.songID), 
AvgDancePerCountry AS (SELECT  country, year, ROUND(avg(danceability), 2) as AverageDanceability
                    FROM TopSongDance
                    GROUP BY country, year)
SELECT CH.country, CH.year, happinessScore, AverageDanceability
FROM CountryHappiness as CH JOIN AvgDancePerCountry as DC 
ON CH.country = DC.country and CH.year = DC.year; 





-- 13
-- Plot GDP vs. Percent of top songs with "money" in each year for each country.
-- double check this
WITH 
TopSongsPerCountry AS (SELECT country, songID, YEAR(startDate) as year 
                        FROM SpotifyChart), 
NumSongsPerCountry AS (SELECT COUNT(DISTINCT songID) as num_songs, country, year
                        FROM TopSongsPerCountry
                        GROUP BY country, year),
SongsWithMoney AS (SELECT Song.songID, country 
                    FROM Song JOIN TopSongsPerCountry ON Song.songID = TopSongsPerCountry.songID
                    WHERE LOWER(lyrics) LIKE "% love %"), -- change to "money" in final version
MoneySongsPerCountry AS (
                        SELECT SongsWithMoney.country, COUNT(DISTINCT songID) as num_money_songs, num_songs, year
                        FROM SongsWithMoney JOIN NumSongsPerCountry ON SongsWithMoney.country = NumSongsPerCountry.country
                        GROUP BY country, year)
SELECT M.country, GDP, M.year, ROUND(100 * num_money_songs / num_songs) AS PercentAboutMoney
                    FROM MoneySongsPerCountry as M JOIN CountryHappiness as C
                    ON M.country = C.country and M.year = C.year; 
    


-- 15
-- How long after [song] by [artist] was released did it appear on the charts?
-- error check that the song exists
-- did song even appear on chart.. 

WITH 
ArtistSongs AS (SELECT Song.songID, artistName, songName, Artist.artistID
            FROM Artist JOIN SongReleases JOIN Song 
                ON Artist.artistID = SongReleases.artistID and SongReleases.songID = Song.songID),
ThisSong AS (
    SELECT songName, songID, artistName, artistID 
            FROM ArtistSongs
            WHERE songName LIKE "WHO? WHAT!" and artistName LIKE "Travis Scott"),
ThisSongAlbum AS (
    SELECT ThisSong.songID, AlbumReleases.albumID, releaseDate 
                FROM AlbumTracks JOIN AlbumReleases JOIN ThisSong 
                ON ThisSong.songID = AlbumTracks.songID and AlbumTracks.albumID = AlbumReleases.albumID),
ChartDate AS ( 
    SELECT MIN(startDate) as earliestonchart, SpotifyChart.songID, releaseDate
                FROM SpotifyChart JOIN ThisSongAlbum ON SpotifyChart.songID = ThisSongAlbum.songID
                    WHERE startDate >= releaseDate)
SELECT DATEDIFF(earliestonchart, releaseDate) AS TimeToChart
        FROM ChartDate;


-- 8  CHECK THIS
-- From [date 1] to [date 2], what was the most common artist genre in [country]?
-- error check if date 1 < date 2
-- error check country in table 
-- q: what to do if multiple 
-- in php: 
-- WITH 

-- SongsInDates AS (SELECT DISTINCT songID AS top_sid
--             FROM SpotifyChart
--             WHERE startDate >= 2018-08-02 and endDate <= 2018-08-07 and country = 'United States')
-- ArtistsInDates AS (SELECT artistID
--                     FROM SongReleases JOIN SongsInDates ON SongReleases.songID = SongsInDates.top_sid)
-- ArtistInfo AS (SELECT )   

-- 10 
-- How many weeks was [song] (ex: Better Now) by [artist] on the top charts?
-- error check if song is not on the charts / not a song
-- per country

-- 14
-- What was the largest one week position drop for a song?


-- 12 
-- Which artist with the least number of followers made the top charts in each country in [year]?
-- WITH 
-- ArtistSong AS (SELECT Artist.artistID, artistName, followers, songID
--                 FROM Artist JOIN SongReleases ON Artist.artistID = SongReleases.artistID),
-- ArtistOnChart AS (
--     SELECT artistID, followers, ArtistSong.songID, country, YEAR(startDate) as year
--                 FROM  ArtistSong JOIN SpotifyChart ON  ArtistSong.songID =  SpotifyChart.songID 
--                 WHERE YEAR(startDate) = 2018) 
-- SELECT artistID, min(followers) AS min_followers
--         FROM ArtistOnChart
--         GROUP BY country



