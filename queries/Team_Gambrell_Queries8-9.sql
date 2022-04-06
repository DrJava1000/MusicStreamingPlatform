-- Query 8
-- DESC: This query lists all song genres and the number of songs
-- that are listed with that genre. 
SELECT SongGenre AS "Song Genre", COUNT(SongGenre) AS "Number of Songs"
FROM song
GROUP BY SongGenre
ORDER BY SongGenre ASC;

-- Query 9
-- DESC: This query shows counts for albums by release year. Listed counts are
-- shown for all available release years after 2000. 
SELECT AlbumReleaseYear AS "Album Release Year", COUNT(AlbumReleaseYear) AS "Number of Albums"
FROM album
GROUP BY AlbumReleaseYear
HAVING AlbumReleaseYear > 2000 
ORDER BY AlbumReleaseYear ASC;

