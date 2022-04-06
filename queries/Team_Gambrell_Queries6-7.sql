-- Query 6
-- DESC: This query lists all albums released before 1990 and 
-- displays the album length in a more appropriate format (without fractional seconds). 
SELECT AlbumName AS "Name", AlbumReleaseYear AS "Release Year", AlbumGenre AS "Genre", 
    EXTRACT(MINUTE FROM AlbumLength) || ':' 
    || TO_CHAR(EXTRACT(SECOND FROM AlbumLength), '00') AS "Length"
FROM album
WHERE TO_DATE(1990, 'RRRR') > TO_DATE( AlbumReleaseYear, 'RRRR')
ORDER BY AlbumReleaseYear ASC;

-- Query 7
-- DESC: This query lists all albums and an associated abbreviation 
-- that represents the decade of their release. 
SELECT AlbumName AS "Name", AlbumGenre AS "Genre", 
    case 
        WHEN AlbumReleaseYear >= 1960 AND AlbumReleaseYear < 1970 THEN '60s'
        WHEN AlbumReleaseYear >= 1970 AND AlbumReleaseYear < 1980 THEN '70s'
        WHEN AlbumReleaseYear >= 1980 AND AlbumReleaseYear < 1990 THEN '80s'
        WHEN AlbumReleaseYear >= 1990 AND AlbumReleaseYear < 2000 THEN '90s'
        WHEN AlbumReleaseYear >= 2010 AND AlbumReleaseYear < 2020 THEN '20-10s'
        END AS "Release Decade"
FROM album
ORDER BY AlbumReleaseYear ASC;

