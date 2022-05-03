-- DROP STATEMENTS HAVE BEEN ADDED BEFORE ALL VIEWS/INDEXES/TABLES
-- SO THAT FUTURE SCRIPT EXECUTIONS ARE CLEAN

-- VIEW 1
DROP VIEW SongAlbumListing;
CREATE VIEW SongAlbumListing AS SELECT 
    s.SongName AS "Song", sa.TrackNumber AS "Track Number", a.AlbumName AS "Associated Album"
    FROM song s INNER JOIN song_album sa
    ON (s.SongID = sa.SongID)
    INNER JOIN album a
    ON (sa.AlbumID = a.AlbumID);
    
-- Query View 1
SELECT * 
FROM SongAlbumListing
WHERE "Track Number" >= 8;

-- VIEW 2 
DROP VIEW NewMilleniumYearlyAlbumCounts;
CREATE VIEW NewMilleniumYearlyAlbumCounts AS SELECT 
    AlbumReleaseYear AS "Album Release Year", COUNT(AlbumReleaseYear) AS "Number of Albums"
    FROM album
    GROUP BY AlbumReleaseYear
    HAVING AlbumReleaseYear > 2000;

-- Query View 2
SELECT * 
FROM NewMilleniumYearlyAlbumCounts
WHERE "Number of Albums" > 2;
