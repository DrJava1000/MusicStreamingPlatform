-- Query 12
-- DESC: This query lists song names and genres for songs
-- that are listed as track 7 on their respective album. 
--
-- This is a scalar query as only one song is listed as track 7
-- on an album. 
SELECT SongName AS "Song Name", SongGenre as "Genre"
FROM song
WHERE SongID = (
    SELECT SongID
    FROM song_album
    WHERE TrackNumber = 7
)
ORDER BY SongName; 

-- Query 13
-- DESC: This query lists the names of artists that have
-- albums in a 'Rock' genre. 
--
-- This is a multi-value query at the first subquery as each artist has 
-- two albums in the database. The second nested query is a multi-value query
-- as multiple albums are of the 'Rock' genre. 
--
-- A double-nested query exists for the purposes of performing queries
-- against album attributes directly. 
SELECT ArtistName AS "Artist Name"
FROM artist
WHERE artistID IN (
    SELECT ArtistID
    FROM artist_album
    WHERE AlbumID IN (
        SELECT AlbumID
        FROM album
        WHERE AlbumGenre LIKE '%Rock'
    )
)
ORDER BY ArtistName;  