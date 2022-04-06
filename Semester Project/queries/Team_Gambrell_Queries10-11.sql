-- Query 10
-- DESC: This query lists songs and their associated album information (album name and track number) for albums that are marked with the Rock genre. 
SELECT s.SongName AS "Song", sa.TrackNumber AS "Track Number", a.AlbumName AS "Associated Album"
FROM song s INNER JOIN song_album sa
ON (s.SongID = sa.SongID)
INNER JOIN album a
ON (sa.AlbumID = a.AlbumID)
WHERE a.AlbumGenre LIKE '%Rock'
ORDER BY s.SongName; 

-- Query 11 (SEE BELOW INSERT STATEMENTS)
-- DESC: This query lists all songs with their genre and associated artist.
-- Within this query, a rogue artist and rogue song have been added that aren't linked to 
-- anyone in the database. These records should show as N/A. 

-- Rogue Song -> 'Thunder' by Imagine Dragons
-- As this row is just temporary, an image isn't being loaded. 
INSERT INTO song 
VALUES(33, 'Thunder', EMPTY_BLOB(), INTERVAL '3:04' MINUTE TO SECOND, 'Synth-pop',
'Just a young gun with a quick fuse
I was uptight, wanna let loose
I was dreaming of bigger things and
Wanna leave my own life behind
Not a "Yes sir", not a follower
Fit the box, fit the mold
Have a seat in the foyer, take a number
I was lightning before the thunder
Thunder, thunder
Thunder, thun-, thunder
Thun-thun-thunder, thunder
Thunder, thunder, thun-, thunder
Thun-thun-thunder, thunder
Thunder, feel the thunder
Lightning and the thunder
Thunder, feel the thunder
Lightning and the thunder
Thunder, thunder
Thunder
Kids were laughing in my classes
While I was scheming for the masses
Who do you think you are?
Dreaming ''bout being a big star
You say you''re basic, you say you''re easy
You''re always riding in the back-seat
Now I''m smiling from the stage while
You were clapping in the nosebleeds
Thunder, thunder, thun-
Thunder, thun-thun-thunder
Thunder, thunder
Thunder, thun-, thunder
Thun-thun-thunder, thunder
Thunder, feel the thunder
Lightning and the thunder
Thunder, feel the thunder
Lightning and the thunder
Thunder
Thunder, feel the thunder
Lightning and the thunder
Thunder
Thunder, feel the thunder
Lightning and the thunder, thunder
Thunder, feel the thunder
Lightning and the thunder, thunder
Thunder, feel the thunder
Lightning and the thunder, thunder
Thunder, feel the thunder (feel the)
Lightning and the thunder, thunder
Thunder, thunder, thun-
Thunder, thun-thun-thunder, thunder
Thunder, thunder, thun-
Thunder, thun-thun-thunder, thunder
Thunder, thunder, thun-
Thunder, thun-thun-thunder, thunder
Thunder, thunder, thun-, thunder
Thun-thun-thunder, thunder'
); 

-- Add link for triple joining rogue song
INSERT INTO artist_song(SongID)
VALUES(33);

-- Rogue Artist -> Rihanna
-- As this artist is just temporary, an profile picture isn't being loaded. 
INSERT INTO artist 
VALUES (9, 'Rihanna', 
'Rihanna established her pop credentials in 2005 with "Pon de Replay," a boisterous debut single that narrowly missed the top of the Billboard Hot 100 and 
fast-tracked her to becoming one of the most popular, acclaimed, and dynamic artists in postmillennial contemporary music. Mixing and matching pop, dancehall, 
EDM, and adult contemporary material, Rihanna has been a near-constant presence in the upper reaches of the pop chart. Through 2017, she headlined 11 number 
one hits, some of which -- "Umbrella" and "Only Girl (In the World)" among them -- led to her eight Grammy Awards. And more than just a singles artist, Rihanna has 
continually pushed ahead stylistically with her LPs, highlighted by the bold Good Girl Gone Bad (2007), steely Rated R (2009), and composed Anti (2016), all of 
which confounded expectations and placed within ...', 
EMPTY_BLOB());

-- Add link for triple joining rogue artist
INSERT INTO artist_song(ArtistID)
VALUES(9);

-- Actual Query
SELECT NVL(s.SongName, 'N/A') AS "Song", NVL(a.ArtistName, 'N/A') AS "Artist", NVL(s.SongGenre, 'N/A') AS "Genre"
FROM song s FULL OUTER JOIN artist_song ars
ON (s.SongID = ars.SongID)
FULL OUTER JOIN artist a
ON (ars.ArtistID = a.ArtistID)
ORDER BY s.SongName; 

-- DELETE ROGUE ARTIST
DELETE FROM artist
WHERE ArtistID = 9;

-- DELETE TRIPLE JOIN LINKS FOR ROGUE ARTIST
DELETE FROM artist_song
WHERE ArtistID = 9;

-- DELETE ROGUE SONG
DELETE FROM song
WHERE SongID = 33;

-- DELETE TRIPLE JOIN LINKS FOR ROGUE SONG
DELETE FROM artist_song
WHERE SongID = 33;

