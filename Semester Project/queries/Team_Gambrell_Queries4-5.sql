-- Query 4
-- DESC: This query lists all songs and their associated genres for songs containing 'love' in the lyrics. 
SELECT RPAD(SongName, 50, '.') || SongGenre AS "Song Name and Genre"
FROM song
WHERE INSTR(LOWER(SongLyrics), 'love', 1, 1) > 0
ORDER BY SongName ASC; 

-- Query 5
-- DESC: This query lists all albums and the number of years since they have been released.
SELECT AlbumName AS Name, ROUND(MONTHS_BETWEEN( SYSDATE, TO_DATE( AlbumReleaseYear, 'RRRR' ) ) / 12) AS "Years Since Release"
FROM album
ORDER BY AlbumName ASC;

