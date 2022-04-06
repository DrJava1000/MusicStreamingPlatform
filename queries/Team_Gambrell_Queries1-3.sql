-- Query 1
-- DESC: This query displays the album release year, name, and length for albums released after 2000 
-- or for albums longer than 50 minutes.
SELECT AlbumReleaseYear AS "RELEASE YEAR", AlbumName AS Name, AlbumLength AS Length
FROM album
WHERE TO_NUMBER(AlbumReleaseYear) > 2000 OR AlbumLength > INTERVAL '50:00' MINUTE TO SECOND
ORDER BY AlbumReleaseYear ASC; 

-- Query 2
-- DESC: This query prompts for a search keyword/pattern and showcases the song id, name, and 
-- genre for all songs that contain that keyword/pattern in lyrics
ACCEPT lyricKeyword PROMPT 'Enter a word or text pattern to find all stored songs with that pattern/keyword in their lyrics: ';
SELECT SongID AS ID, SongName AS Name, SongGenre AS Genre
FROM song
WHERE LOWER(SongLyrics) LIKE LOWER('% &lyricKeyword %')
ORDER BY SongID ASC;

-- Query 3
-- DESC: This query searches for the album length, id, and name for albums that are between 40 
-- and 50 minutes. For all albums between these lengths, the query returns the longest 
-- (specifically the latter 50%)  
SELECT AlbumLength AS Length, AlbumID AS ID, AlbumName AS Name
FROM album
WHERE AlbumLength BETWEEN INTERVAL '40:00' MINUTE TO SECOND AND INTERVAL '50:00' MINUTE TO SECOND
ORDER BY AlbumLength ASC
FETCH FIRST 50 PERCENT ROWS ONLY; 

