-- Query 1
--
-- This query prints out all songs/albums and their respective genres.
SELECT albumName AS "Song/Album Name", albumGenre AS "Genre"
FROM album
UNION
SELECT songName, songGenre
FROM song
ORDER BY 1;

-- Query 2
--
-- This query prints out all albums whose
-- listed artist has an id that matches the id of a song on the
-- album. 
SELECT albumID AS "Album ID", artistID AS "Matching Artist/Song ID"
FROM artist_album
INTERSECT
SELECT albumID, songID
FROM song_album
ORDER BY 1;