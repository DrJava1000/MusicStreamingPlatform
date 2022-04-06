
-- DROP PREVIOUS TABLES
DROP TABLE song_album; 
DROP TABLE artist_song;
DROP TABLE artist_album; 
DROP TABLE song; 
DROP TABLE album; 
DROP TABLE artist; 


-- Create Artist table
CREATE TABLE artist(
    ArtistID INTEGER,
    ArtistName VARCHAR2(40) NOT NULL,
    ArtistDescription NCLOB NOT NULL,
    ArtistPicture BLOB NOT NULL,
    CONSTRAINT artist_ArtistID_pk PRIMARY KEY (ArtistID)
);

-- Create Album table
CREATE TABLE album(
    AlbumID INTEGER,
    AlbumName VARCHAR2(40) NOT NULL,
    AlbumArt BLOB NOT NULL, 
    AlbumLength INTERVAL DAY TO SECOND NOT NULL,
    AlbumGenre VARCHAR2(40) NOT NULL,
    AlbumReleaseYear VARCHAR2(4) NOT NULL,
    isCompilation CHAR(1), 
    CONSTRAINT album_AlbumID_pk PRIMARY KEY (AlbumID)
); 

-- Create Song table
CREATE TABLE song(
    SongID INTEGER,
    SongName VARCHAR2(40) NOT NULL,
    SongArt BLOB,
    SongLength INTERVAL DAY TO SECOND NOT NULL,
    SongGenre VARCHAR2(40) NOT NULL,
    SongLyrics NCLOB,
    CONSTRAINT song_SongID_pk PRIMARY KEY (SongID)
); 

-- Create Artist-Album mapping table
CREATE TABLE artist_album(
    ArtistID INTEGER,
    AlbumID INTEGER,
    CONSTRAINT artist_album_ArtistID_AlbumID_pk PRIMARY KEY (ArtistID, AlbumID),
    CONSTRAINT artist_album_ArtistID_fk FOREIGN KEY (ArtistID)
                                                REFERENCES artist (ArtistID),
    CONSTRAINT artist_album_AlbumID_fk FOREIGN KEY (AlbumID)
                                                REFERENCES album (AlbumID)
); 

-- Create Artist-Song mapping table
CREATE TABLE artist_song(
    ArtistID INTEGER,
    SongID INTEGER,
    ArtistIsPrimary CHAR(1), 
    CONSTRAINT artist_song_ArtistID_SongID_pk PRIMARY KEY (ArtistID, SongID),
    CONSTRAINT artist_song_ArtistID_fk FOREIGN KEY (ArtistID)
                                                REFERENCES artist (ArtistID),
    CONSTRAINT artist_song_SongID_fk FOREIGN KEY (SongID)
                                                REFERENCES song (SongID)
); 

-- Create Song-Album mapping tool 
CREATE TABLE song_album(
    SongID INTEGER,
    AlbumID INTEGER,
    TrackNumber INTEGER,
    CONSTRAINT song_album_SongID_AlbumID_pk PRIMARY KEY (SongID, AlbumID),
    CONSTRAINT song_album_SongID_fk FOREIGN KEY (SongID)
                                                REFERENCES song (SongID),
    CONSTRAINT song_album_AlbumID_fk FOREIGN KEY (AlbumID)
                                                REFERENCES album (AlbumID)
); 

COMMIT; 