-- Ryan Gambrell
-- 2/17/2022

-- DROP PREVIOUS TABLES
DROP TABLE song_album; 
DROP TABLE artist_song;
DROP TABLE artist_album; 
DROP TABLE song; 
DROP TABLE album; 
DROP TABLE artist; 

-- DROP SEQUENCES
DROP SEQUENCE artist_ArtistID_seq; 
DROP SEQUENCE album_AlbumID_seq; 
DROP SEQUENCE song_SongID_seq; 

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

-- Artist Sequence
CREATE SEQUENCE artist_ArtistID_seq
    INCREMENT BY 1
    START WITH 1;

-- Album Sequence
CREATE SEQUENCE album_AlbumID_seq
    INCREMENT BY 1
    START WITH 1;
    
-- Song Sequence
CREATE SEQUENCE song_SongID_seq
    INCREMENT BY 1
    START WITH 1;
    
-- Delete Old Procedure for Storing Images
DROP PROCEDURE insertImage;

-- USED IN SQL PLUS: HR (hr) is granted ability to delete directories
-- GRANT DROP ANY DIRECTORY TO hr; 

-- Delete Images Directory
DROP DIRECTORY image_files; 

-- USED IN SQL PLUS: Grant the HR (hr) user the ability to create directories
-- GRANT CREATE ANY DIRECTORY TO hr; 

-- Specify Image Directory (to fetch images from)
CREATE DIRECTORY image_files AS 'C:\\MusicDBImages';

-- USED IN SQL PLUS: Grant Read capabilities to HR (hr) user for images directory 
-- GRANT READ ON DIRECTORY image_files TO hr;

-- Add Procedure for Storing Images (Album Art and Artist Pictures)
CREATE PROCEDURE insertImage (artRef IN BLOB, imageFileName IN VARCHAR2) IS
BEGIN
    DECLARE
        l_blob BLOB := artRef; 
        v_src_loc  BFILE := BFILENAME('IMAGE_FILES', imageFileName);
        v_amount   INTEGER;
    BEGIN
        DBMS_LOB.OPEN(v_src_loc, DBMS_LOB.LOB_READONLY);
        v_amount := DBMS_LOB.GETLENGTH(v_src_loc);
        DBMS_LOB.LOADFROMFILE(l_blob, v_src_loc, v_amount);
        DBMS_LOB.CLOSE(v_src_loc);
    END;
END;
/
   
-- Add Artists, their descriptions, and their portraits
BEGIN
    DECLARE
        currentPortrait BLOB; 
    BEGIN
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Aerosmith', 
        'Aerosmith were one of the most popular hard rock bands of the ''70s, 
        setting the style and sound of hard rock and heavy metal for the next two decades with their raunchy, bluesy swagger. 
        The Boston-based quintet found the middle ground between the menace of the Rolling Stones and the campy, sleazy flamboyance of the New York Dolls, 
        developing a lean, dirty riff-oriented boogie that was loose and swinging and as hard as a diamond.', EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, 'Aerosmith-portrait.jpg'); 
        
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'The Beatles', 
        'So much has been said and written about the Beatles -- and their story is so mythic in its sweep -- that it''s 
        difficult to summarize their career without restating clichés that have already been digested by tens of millions of rock fans. To start with the obvious, they were the greatest and most influential act of the rock era, 
        and they introduced more innovations into popular music than any other group of their time. Moreover, they were among the few artists of any discipline that were simultaneously the best at what they did and the most 
        popular at what they did. Relentlessly imaginative and experimental, the Beatles grabbed hold of the international mass consciousness in 1964 and never let go for the next six years, always staying ahead of the pack in 
        terms of creativity and never losing the ability to communicate their increasingly sophisticated ideas to a mass audience. Their supremacy as rock icons remains unchallenged to this day, decades after their breakup in 1970.', 
        EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, 'Beatles-portrait.jpg'); 
        
        -- No Description or Portrait for Honeyclaws 
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Honeyclaws', 'NOT AVAILABLE', EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Skrillex', 
        'Sonny Moore found club and mainstream stardom beginning in 2008, when he swapped his gig as the frontman in post-hardcore band From First to Last for the dancefloor-oriented 
        project Skrillex. He originally used the name for live DJ sets, but in 2009 the project moved into the studio with Skrillex remixing the likes of Lady Gaga ("Bad Romance") and Snoop Dogg ("Sensual Seduction"). In 2010, the 
        self-released digital download EP My Name Is Skrillex appeared, combining the Benny Benassi and Deadmau5 styles of electro with the same type of over the top samples and giant noise of electronica acts like the Chemical Brothers and Fatboy Slim.', 
        EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, '220px-Skrillex_@_portrait.jpg'); 
        
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Taylor Swift', 
        'Taylor Swift is that rarest of pop phenomena: a superstar who managed to completely cross over from country to the mainstream. 
        Others have performed similar moves -- notably, Dolly Parton and Willie Nelson both became enduring pop-culture icons based on their 1970s work -- but Swift shed her country roots like they were a second skin; 
        it was a necessary molting to reveal she was perhaps the sharpest, savviest populist singer/songwriter of her generation, one who could harness the zeitgeist, make it personal and, just as impressively, perform the reverse. 
        These skills were evident on her earliest hits, especially the neo-tribute "Tim McGraw," but her second album, 2008''s Fearless, showcased a songwriter discovering who she was and, in the process, finding a mass audience. 
        Fearless wound up having considerable legs not only in the U.S., where it racked up six platinum singles on the strength of the Top Ten hits "Love Story" and "You Belong with Me," but throughout the world, 
        performing particularly well in the U.K., Canada, and Australia. Speak Now, delivered almost two years later, consolidated that success and moved Swift into the stratosphere of superstardom. 
        Her popularity only increased over her next three albums -- Red (2012), 1989 (2014), Reputation (2017) -- and found her moving assuredly into a pop realm where she already belonged. 
        Even when she scaled back her approach with 2020''s stripped-down sibling releases folklore and Evermore, she remained atop the pop world, a position she maintained with re-recordings of her back catalog in 2021.', 
        EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, 'Taylor-Swift-portrait.jpg'); 
        
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Lynyrd Skynyrd', 
        'Lynyrd Skynyrd is the definitive Southern rock band, fusing the overdriven power of blues-rock with a rebellious Southern image and a hard rock swagger. Skynyrd never relied 
        on the jazzy improvisations of the Allman Brothers. Instead, they were a hard-living, hard-driving rock ' || chr(38) || ' roll band. They may have jammed endlessly on-stage, but their music remained firmly entrenched in blues, rock, and country. 
        Throughout the band''s early records, frontman Ronnie Van Zant demonstrated a knack for lyrical detail and a down-to-earth honesty that had more in common with country than rock ' || chr(38) || ' roll. During the height of Skynyrd''s popularity in 
        the mid-''70s, they adopted a more muscular and gritty blues-rock sound that yielded the classic rock standards "Sweet Home Alabama," "Simple Man," "What''s Your Name," "That Smell," "Gimme Three Steps," and "Free Bird." The group 
        ceased operations after the tragic deaths of Van Zant, Steve Gaines, and backup singer Cassie Gaines, who were killed in an airplane crash on October 20, 1977. Skynyrd re-formed in 1987 with Ronnie''s younger sibling Johnny Van Zant 
        on vocals, and guitarist and co-founder Gary Rossington, who would serve as the group''s sole constant member over the years. In 2018, after decades of performing and recording, the band embarked on a farewell tour, which was chronicled 
        on the 2020 concert LP and film Last of the Street Survivors Tour Lyve!', EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, 'lynyrd-skynyrd-portrait.jpg'); 
        
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Avenged Sevenfold', 
        'One of the more successful and accessible metalcore outfits of the early 21st century, Avenged Sevenfold endured changes both stylistic and internal during their rise from teenage troublemakers 
        to commercial success story. Part of the New Wave of American Heavy Metal movement, they debuted in 2001 with Sounding the Seventh Trumpet, and maintained a pure metalcore esthetic before adopting a more modern rock/heavy metal-forward style on 
        2005''s City of Evil. They broke into the mainstream in 2007 with the release of their eponymous fourth LP and continued to cast a spell both at home and abroad with subsequent efforts Nightmare (2010) and Hail to the King (2013) achieving gold and 
        platinum status, and 2016''s The Stage earning a Grammy nomination.', EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, 'avenged-sevenfold-portrait.jpg'); 
        
        INSERT INTO artist 
        VALUES (artist_ArtistID_seq.NEXTVAL, 'Ariana Grande', 
        'Ariana Grande is perhaps the quintessential pop star of the last half of the 2010s, capturing the era''s spirit and style. Emerging in 2013 with the hit single "The Way," Grande initially appeared 
        to be the heir to the throne of Mariah Carey, due in part to her powerhouse vocals. With its Babyface production, her debut Yours Truly underscored her debt to ''90s R' || chr(38) || 'B, but Grande quickly incorporated hip-hop and EDM into her music. "Problem," 
        a 2014 smash duet with Iggy Azalea, was the first indication of her development, an evolution reinforced by the hits "Bang Bang" and "Love Me Harder," which featured Jessie J ' || chr(38) || ' Nicki Minaj and the Weeknd, respectively. Grande maintained her popularity 
        with 2016''s Dangerous Woman, then really hit her stride with 2018''s Sweetener and its swift sequel Thank U, Next, whose title track became her first number one pop hit. That achievement was quickly equaled by "7 Rings," a glitzy anthem for the Instagram 
        age that consolidated her stardom and artistry, as well as "Positions," the lead single from 2020''s R' || chr(38) || 'B-heavy album of the same name.', EMPTY_BLOB()) RETURN ArtistPicture INTO currentPortrait;
        insertImage(currentPortrait, 'ariana_grande_portrait.jpg'); 
    END;
END;
/
    
-- Add Albums and Album Art
BEGIN
    DECLARE
        currentArt BLOB;
    BEGIN
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Abbey Road', EMPTY_BLOB(), INTERVAL '47:03' MINUTE TO SECOND, 'Rock', '1969', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Beatles_-_Abbey_Road.jpg');  
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Toys in the Attic', EMPTY_BLOB(), INTERVAL '37:08' MINUTE TO SECOND, 'Hard Rock', '1975', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Aerosmith_-_Toys_in_the_Attic.jpg');  
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'One Law', EMPTY_BLOB(), INTERVAL '44:34' MINUTE TO SECOND, 'Dance/Electronic', '2014', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'honey-claws-one-law-Cover-Art.jpg');  
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Recess', EMPTY_BLOB(), INTERVAL '46:34' MINUTE TO SECOND, 'EDM/Pop', '2014', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'skrillex_recess.jpg');  
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Nine Lives', EMPTY_BLOB(), INTERVAL '62:54' MINUTE TO SECOND, 'Hard Rock', '1997', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Aerosmith_-_Nine_Lives.jpg');  
        
        INSERT INTO album
        VALUES (album_AlbumID_seq.NEXTVAL, 'Money Jaws', EMPTY_BLOB(), INTERVAL '35:32' MINUTE TO SECOND, 'Dance/Electronic', '2012', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'honeyclaws_moneyjaws.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Let It Be', EMPTY_BLOB(), INTERVAL '35:10' MINUTE TO SECOND, 'Rock', '1970', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'LetItBe.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Scary Monsters and Nice Sprites', EMPTY_BLOB(), INTERVAL '44:02' MINUTE TO SECOND, 'Dubstep', '2012', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Skrillex_scary_monsters.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Sweetener', EMPTY_BLOB(), INTERVAL '47:25' MINUTE TO SECOND, 'R' || chr(38) || 'B', '2018', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'sweetener.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, '1989', EMPTY_BLOB(), INTERVAL '48:41' MINUTE TO SECOND, 'Synth-pop', '2014', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Taylor_Swift_-_1989.png'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Hail to the King', EMPTY_BLOB(), INTERVAL '53:27' MINUTE TO SECOND, 'Heavy Metal', '2013', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'hailtotheking.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Gimme Back My Bullets', EMPTY_BLOB(), INTERVAL '34:57' MINUTE TO SECOND, 'Southern Rock', '1976', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'GimmeBackMyBullets_LynyrdSkynyrdalbum.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Reputation', EMPTY_BLOB(), INTERVAL '55:38' MINUTE TO SECOND, 'Electropop', '2017', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'taylor-swift-reputation.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Dangerous Woman', EMPTY_BLOB(), INTERVAL '39:31' MINUTE TO SECOND, 'R' || chr(38) || 'B', '2016', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Ariana_Grande_-_Dangerous_Woman_(Official_Album_Cover).png'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Street Survivors', EMPTY_BLOB(), INTERVAL '35:26' MINUTE TO SECOND, 'Southern Rock', '1977', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'lynyrd-skynyrd-street-survivors-album-cover-donna-kennedy.jpg'); 
        
        INSERT INTO album 
        VALUES (album_AlbumID_seq.NEXTVAL, 'Nightmare', EMPTY_BLOB(), INTERVAL '66:46' MINUTE TO SECOND, 'Heavy Metal', '2010', 'N') RETURN AlbumArt INTO currentArt;
        insertImage(currentArt, 'Avenged_Sevenfold_-_Nightmare.png');
    END;
END;
/

-- Add Songs
INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Come Together', EMPTY_BLOB(), INTERVAL '4:19' MINUTE TO SECOND, 'Blues Rock', 
'Here come old flat top
He come grooving up slowly
He got joo joo eyeball
He one holy roller
He got hair down to his knee
Got to be a joker he just do what he please
He wear no shoe shine
He got toe jam football
He got monkey finger
He shoot Coca-Cola
He say I know you, you know me
One thing I can tell you is you got to be free
Come together, right now, over me
He bag production
He got walrus gumboot
He got Ono sideboard
He one spinal cracker
He got feet down below his knee
Hold you in his armchair you can feel his disease
Come together, right now, over me
He roller coaster
He got early warning
He got muddy water
He one mojo filter
He say, "one and one and one is three"
Got to be good looking ''cause he''s so hard to see
Come together, right now, over me
Oh
Come together, yeah
Come together, yeah
Come together, yeah
Come together, yeah
Come together, yeah
Come together, yeah
Come together, yeah
Oh
Come together, yeah
Come together, yeah'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Sun King', EMPTY_BLOB(), INTERVAL '2:26' MINUTE TO SECOND, 'Blues Rock', 
'Aaaaah
Here come the sun king
Here come the sun king
Everybody''s laughing
Everybody''s happy
Here come the sun king
Cuando para mucho mi amore de felice corazón
Mundo paparazzi mi amore chicka ferdy parasol
Questo obrigado tanta mucho que can eat it carousel'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Sweet Emotion', EMPTY_BLOB(), INTERVAL '4:34' MINUTE TO SECOND, 'Hard Rock', 
'Sweet emotion
Sweet emotion
You talk about things that nobody cares
Wearing out things that nobody wears
You''re calling my name but I gotta make clear
I can''t say, baby, where I''ll be in a year
Some sweat hog mama with a face like a gent
Said my get up and go, must''ve got up and went
Well I got good news, she''s a real good liar
''Cause the backstage boogie sets your pants on fire
Sweet emotion
Sweet emotion
I pulled into town in a police car
Your daddy said I took it just a little too far
You''re telling her things but your girlfriend lied
You can''t catch me ''cause the rabbit done died
Yes it did
Stand in the front just a shakin'' your ass
I''ll take you backstage, you can drink from my glass
I''ll talk about something you can sure understand
''Cause a month on the road and I''ll be eating from your hand'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Walk This Way', EMPTY_BLOB(), INTERVAL '3:40' MINUTE TO SECOND, 'Hard Rock', 
'Backstroke lover always hidin'' ''neath the cover
''Till I talked to my daddy, he say
He said, "You ain''t seen nothing
''Till you''re down on a muffin
Then you''re sure to be a-changin'' your ways"
I met a cheerleader, was a real young bleeder
All the times I can reminisce
''Cause the best thing lovin'' with her sister and her cousin
Only started with a little kiss, like this
See-saw swingin'' with the boys in the school
With your feet flyin'' up in the air
Singin'' "Hey diddle-diddle with the kitty in the middle
Of the swing" like I didn''t care
So I took a big chance at the high school dance
With a missy who was ready to play
Wasn''t me she was foolin''
''Cause she knew what she was doin''
And I know love is here to stay
When she told me to
Walk this way, walk this way
Walk this way, walk this way
Walk this way, walk this way
Walk this way, walk this way
Ah, just give me a kiss
Like this
School girl sweetie with the classy kinda sassy
Little skirt''s climbin'' way up her knees
There was three young ladies in the school gym locker
When I noticed they was lookin'' at me
I was a high school loser, never made it with a lady
''Til the boys told me something I missed
Then my next door neighbor with a daughter had a favor
So I gave her just a little kiss, like this
See-saw swingin'' with the boys in the school
With your feet flyin'' up in the air
Singin'' "Hey diddle-diddle with the kitty in the middle
Of the swing" like I didn''t care
So I took a big chance at the high school dance
With a missy who was ready to play
Wasn''t me she was foolin''
''Cause she knew what she was doin''
When she told me how to walk this way
She told me to
Walk this way, walk this way
Walk this way, walk this way
Walk this way, walk this way
Walk this way, talk this way
Just give me a kiss
Like this'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Title Shot', EMPTY_BLOB(), INTERVAL '3:11' MINUTE TO SECOND, 'Dance/Electronic', 'NOT AVAILABLE'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Pass the Fire', EMPTY_BLOB(), INTERVAL '3:54' MINUTE TO SECOND, 'Dance/Electronic', 'NOT AVAILABLE'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Stranger', EMPTY_BLOB(), INTERVAL '4:49' MINUTE TO SECOND, 'EDM', 
'Here in the dark I can see where you are
I see so clearly
The beat of my heart just stops and starts
Whenever you''re near me
I just gotta thank you, all the love I gave you
Came and you took it all away
And now there is no pain, there''s everything to gain here
Now that I''m lost I think I''ll stay
And hell, there''s comfort in this fame, see I don''t feel the pain
And hell, I''ll forget your name here, you''ll become a stranger
Here in the dark I can see where you are
I see so clearly
The beat of my heart just stops and starts
Whenever you''re near me
I just gotta thank you, all the love I gave you
Came and you took it all away
And now there is no pain, there''s everything to gain here
Now that I''m lost I think I''ll stay
And hell, there''s comfort in this fame, see I don''t feel the pain'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Ragga Bomb', EMPTY_BLOB(), INTERVAL '4:18' MINUTE TO SECOND, 'EDM', 
'Ragga bomb
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem
Gwan drop de bomb pon dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem
Gwan drop de bomb pon dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem dem
Fake and funny bruddas man say we no check for
Dem a liar and will con you like deceptor
Chameleon dem change like transformer
Put dem pon a platter Cah dem a great pretender
Paparazzi camera flash when RTC look trash
When we ah roll out de club after a night on de lash
Have fe have fe have fe have fe have fe have fe have fe
Drop de bomb pon dem have fe
Have fe drop de bomb pon
Have fe drop de bomb pon
Have fe drop de bomb pon
Have fe drop de
Come unleash de real Ragga
You have call fe we if you tune need swagger
Top of de scale like a scholer
Odd on favourite you can ask paddy power
We a money spender and dem a money lender
Bad mind, grudgefull and dem a player hater
So when you see de punk give him you middle finger
Cah dem a fassyhole and dem can''t stand round dem
Ragga twins and skrillex man
Gwan drop de bomb pon dem
Business ago get fix ha
Yo weh we tell dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem
Gwan drop de bomb pon dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem dem
Well gimme well gimme space fe let rip
No talk when me a talk boy keep you mouth zip
Well you know see de light yet but you soon mek de trip
Up inna de sky like de good year blip
Double J pass de white rum let me take a sip
Cah me notice from wah day wah fassyhole ah ge we lip
Dem dirty stinking asshole a try catch me a slip
Have fe drop de bomb pon dem yo, come on
Have fe drop de bomb pon
Have fe drop de bomb pon
Have fe drop de bomb pon
Hahaha LA meets H town you done know
Cross the Atlantic business
Murderrrrrr Cha Murderrrrr
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem
Gwan drop de bomb pon dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem
Gwan drop de bomb pon dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem dem
Cha bruddas man say we no check for
Dem a liar and will con you like deceptor
Chameleon dem change like transformer
Put dem pon a platter Cah dem a great pretender
Cha pass de white rum let me teak a sip
Cah me notice from wah day wah fassyhole ah ge we lip
Dem dirty stinking asshole a try catch we a slip
No mess with Ragga Twins you get whip yo
To all ah me H Town massive gwan big up you chest
LA meets H Town
Gwan drop de bomb pon dem
Budybybybybyby Budybybybybyby
Bun a fire
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem
Gwan drop de bomb pon dem
Have fe drop de bomb pon dem
Have fe drop de bomb pon dem dem
Murder
LA Meets H Town you done know business
No ramping ting
Murderrrrrr
All ah de London massive gwan big up you chest Cah you done know
All ah de LA Massive large up Seen'); 

INSERT INTO song
VALUES(song_SongID_seq.NEXTVAL, 'Full Circle', EMPTY_BLOB(), INTERVAL '5:01' MINUTE TO SECOND, 'Hard Rock', 
'Yeah
If i could change the world
Like a fairy tale
I would drink the love
From your holy grail
I would start with love
Tell ol'' beelzeebub
To get outta town
''Cause you just lost your job
How did we get so affected (cause i think)
Love is love reflected
Time
Don''t let it slip away
Raise yo'' drinkin'' glass
Here''s to yesterday
In time
We''re all gonna trip away
Don''t piss heaven off
We got hell to pay
Come full circle
If
There''s a spell on you that
I could take away
I would do the deed
Yeah and by the way
Here''s to heaven knows
As the circle goes
It ain''t right
I''m uptight
Get off my toes
I used to think that every little thing i did was crazy
But now i think- the karma cops are comin'' after you
Time
Don''t let it slip away
Raise yo drinkin''glass
Here''s to yesterday
In time
We''re all gonna trip away
Don''t piss heaven off
We got hell to pay
Come full circle
Every time you get yourself caught up inside
Of someone else''s crazy dream
Own it, yeah that''s a mistake
Everybody''s gotta lotta nada killing them
Instead of killing me
Time
Don''t let it slip away
Raise yo'' drinkin''glass
Here''s to yesterday
In time
We''re all gonna trip away
Don''t piss heaven off
We got hell to pay
Come full circle
Time
Don''t let it slip away
Raise yo'' drinkin''glass
Here''s to yesterday
In time
We''re all gonna trip away
Don''t piss heaven off
We got hell to pay
Come full circle
Circle, circle, circle, circle, circle, circle, circle
Time don''t let it slip away
Raise'' yo'' drinkin glass
Here''s to yesterday
Time
We''re all gonna trip away
Don''t piss heaven off
We got hell to pay'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'The Farm', EMPTY_BLOB(), INTERVAL '4:27' MINUTE TO SECOND, 'Hard Rock', 
'(It''s not a place you can get to
By a boat or a train... it''s far, far away...
Oaahh!
There''s a cockroach in my coffee
There''s a needle in my arm
And I feel like New York City
Get me to the farm
Get me to the farm
Get me to the farm
Somebody get me to the farm
I got terminal uniqueness
I''m an egocentric man
I get caught up in my freakness
But I ain''t no Peter Pan
Get me to the farm
Get me to the farm
Get me to the farm
Get me...
Buckle up straightjack
Sanity is such a drag
Jellybean thorazene
Transcendental jet lag
Sanity I ain''t gotta
Feeling like a pinata
Sucker punch, blowin'' lunch
Motherload, pigeonholed
I''m feeling like I''m gonna explode
Yeah, I wanna shave my head and
I wanna be a Hare Krishna
Tattoo a dot right on my head
Heh, heh
And the prozac is my fixer
I am the living dead
(Follow the yellow brick road...
Follow the yellow brick road...)
Take me to the farm
Take me to the farm
Somebody get me to the farm
Somebody take me to the farm
Take me to the farm
Take me to the farm
Somebody take me to the farm
Somebody take me to the farm
Take me to the farm
Take me to the farm
Take me to the farm
Take me to the farm
Take me to the farm
Somebody get me to the farm
(Wake up, honey... Then I''m sure to
Get a brain, a heart, a home, the nerve)'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Turn Up the Bass', EMPTY_BLOB(), INTERVAL '3:55' MINUTE TO SECOND, 'EDM', 'NOT AVAILABLE'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Fade Away', EMPTY_BLOB(), INTERVAL '3:58' MINUTE TO SECOND, 'EDM', 'NOT AVAILABLE'); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Two of Us', EMPTY_BLOB(), INTERVAL '3:36' MINUTE TO SECOND, 'Rock', 
'"I Dig a Pygmy" by Charles Hawtrey and the Deaf Aids
Phase one, in which Doris gets her oats
Two of us riding nowhere
Spending someone''s hard-earned pay
You and me Sunday driving
Not arriving on our way back home
We''re on our way home
We''re on our way home
We''re going home
Two of us sending postcards
Writing letters on my wall
You and me burning matches
Lifting latches on our way back home
We''re on our way home
We''re on our way home
We''re going home
You and I have memories
Longer than the road that stretches out ahead
Two of us wearing raincoats
Standing solo in the sun
You and me chasing paper
Getting nowhere on our way back home
We''re on our way home
We''re on our way home
We''re going home
You and I have memories
Longer than the road that stretches out ahead
Two of us wearing raincoats
Standing solo in the sun
You and me chasing paper
Getting nowhere on our way back home
We''re on our way home
We''re on our way home
We''re going home
We''re going home
Better believe it
Goodbye'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Across the Universe', EMPTY_BLOB(), INTERVAL '3:48' MINUTE TO SECOND, 'Rock', 
'Words are flowing out like endless rain into a paper cup
They slither wildly as they slip away across the universe
Pools of sorrow, waves of joy are drifting through my opened mind
Possessing and caressing me
Jai guru deva, om
Nothing''s gonna change my world
Nothing''s gonna change my world
Nothing''s gonna change my world
Nothing''s gonna change my world
Images of broken light which dance before me like a million eyes
They call me on and on across the universe
Thoughts meander like a restless wind inside a letterbox they
They tumble blindly as they make their way across the universe
Jai guru deva, om
Nothing''s gonna change my world
Nothing''s gonna change my world
Nothing''s gonna change my world
Nothing''s gonna change my world
Sounds of laughter shades of life are ringing
Through my open ears inciting and inviting me
Limitless undying love which shines around me like a million suns
It calls me on and on across the universe
Jai guru deva, om
Nothing''s gonna change my world
Nothing''s gonna change my world
Nothing''s gonna change my world
Nothing''s gonna change my world
Jai guru deva
Jai guru deva
Jai guru deva
Jai guru deva
Jai guru deva
Jai guru deva'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Rock n Roll', EMPTY_BLOB(), INTERVAL '4:44' MINUTE TO SECOND, 'EDM', 
'Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
(Rock n'' roll)
Singin'' with you
Singin'' with you
Singin'' with you (uh)
Oh my gosh
(Rock n'' roll)
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rude boy bass, mash up the place
Singin'' with you
Singin'' with you
Singin'' with you
You can eat shit and fuckin''
And fuck you
(Rock n'' roll)
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Hello again, to all my friends, together we can play some rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
Rock n'' roll
I''m ben taylor, rock n'' roll
Good people, good times, right on
Rock n'' roll, kid smith is fun to say
Kid smith, yeah
Kid smith will take you to the mountain
Rock n'' roll
You have technicians here, making noise
No one is a musician
They are not artists because nobody can play the guitar'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Kill EVERYBODY', EMPTY_BLOB(), INTERVAL '4:58' MINUTE TO SECOND, 'EDM',
'I want to kill everybody in the world
I want to eat your heart
I want to kill everybody in the world
I want to eat your heart
I want to kill everybody in the world
I want to kill
I want to kill everybody in the world
I want to eat, want to eat your
I want to kill everybody in the world
I want to kill
I want to kill
I want to kill
I want to kill
I want to kill
I want to kill
I want to kill
I want to kill
I want to kill'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Breathin', EMPTY_BLOB(), INTERVAL '3:18' MINUTE TO SECOND, 'R' || chr(38) || 'B',
'Some days, things just take way too much of my energy
I look up and the whole room''s spinning
You take my cares away
I can so overcomplicate, people tell me to medicate
Feel my blood runnin'', swear the sky''s fallin''
How do I know if this shit''s fabricated?
Time goes by and I can''t control my mind
Don''t know what else to try, but you tell me every time
Just keep breathin'' and breathin'' and breathin'' and breathin''
And oh, I gotta keep, keep on breathin''
Just keep breathin'' and breathin'' and breathin'' and breathin''
And oh, I gotta keep, keep on breathin''
Sometimes it''s hard to find, find my way up into the clouds
Tune it out, they can be so loud
You remind me of a time when things weren''t so complicated
All I need is to see your face
Feel my blood runnin'', swear the sky''s fallin''
How do I know if this shit''s fabricated, oh?
Time goes by and I can''t control my mind
Don''t know what else to try, but you tell me every time
Just keep breathin'' and breathin'' and breathin'' and breathin''
And oh, I gotta keep, I keep on breathin''
Just keep breathin'' and breathin'' and breathin'' and breathin''
And oh, I gotta keep, I keep on breathin'', mmm, yeah
My, my air
My, my air
My, my air, my air
My, my air
My, my air
My, my air, yeah
Just keep breathin'' and breathin'' and breathin'' and breathin''
And oh, I gotta keep, I keep on breathin''
Just keep breathin'' and breathin'' and breathin'' and breathin''
And oh, I gotta keep, I keep on breathin'', mmm, yeah
Feel my blood runnin'', swear the sky''s fallin''
I keep on breathin''
Time goes by and I can''t control my mind
I keep on breathin'', mmm, yeah'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'No Tears Left to Cry', EMPTY_BLOB(), INTERVAL '3:25' MINUTE TO SECOND, 'R' || chr(38) || 'B', 
'Right now, I''m in a state of mind
I wanna be in like all the time
Ain''t got no tears left to cry
So I''m pickin'' it up, pickin'' it up
I''m lovin'', I''m livin'', I''m pickin'' it up
I''m pickin'' it up, pickin'' it up
I''m lovin'', I''m livin'', I''m pickin'' it up (Oh, yeah)
I''m pickin'' it up (Yeah), pickin'' it up (Yeah)
Lovin'', I''m livin'', so we turnin'' up
Yeah, we turnin'' it up
Ain''t got no tears in my body
I ran out, but boy, I like it, I like it, I like it
Don''t matter how, what, where, who tries it
We out here vibin'', we vibin'', we vibin''
Comin'' out, even when it''s rainin'' down
Can''t stop now, can''t stop so shut your mouth
Shut your mouth, and if you don''t know
Then now you know it, babe
Know it, babe, yeah
Right now, I''m in a state of mind
I wanna be in like all the time
Ain''t got no tears left to cry
So I''m pickin'' it up, pickin'' it up (Oh, yeah)
I''m lovin'', I''m livin'', I''m pickin'' it up
Oh, I just want you to come with me
We on another mentality
Ain''t got no tears left to cry (To cry)
So I''m pickin'' it up, pickin'' it up (Oh, yeah)
I''m lovin'', I''m livin'', I''m pickin'' it up
Pickin'' it up (Yeah), pickin'' it up (Yeah)
Lovin'', I''m livin'', so we turnin'' up (We turnin'' it up)
Yeah, we turnin'' it up
They point out the colours in you, I see ''em too
And, boy, I like ''em, I like ''em, I like ''em
We''re way too fly to partake in all this hate
We out here vibin'', we vibin'', we vibin''
Comin'' out, even when it''s rainin'' down
Can''t stop now, can''t stop, so shut your mouth
Shut your mouth, and if you don''t know
Then now you know it, babe
Know it, babe, yeah
Right now, I''m in a state of mind
I wanna be in like all the time
Ain''t got no tears left to cry
So I''m pickin'' it up, pickin'' it up (Oh, yeah)
I''m lovin'', I''m livin'', I''m pickin'' it up
Oh, I just want you to come with me
We on another mentality
Ain''t got no tears left to cry (To cry)
So I''m pickin'' it up, pickin'' it up (Oh, yeah)
I''m lovin'', I''m livin'', I''m pickin'' it up
Comin'' out, even when it''s rainin'' down
Can''t stop now (Hmm, oh)
Shut your mouth
Ain''t got no tears left to cry
Oh yeah, oh yeah
Oh, I just want you to come with me
We on another mentality
Ain''t got no tears left to cry (Cry)
So I''m pickin'' it up (Yeah), pickin'' it up (Oh yeah)
I''m lovin'', I''m livin'', I''m pickin'' it up
Pickin'' it up, pickin'' it up
Lovin'', I''m livin'', so we turnin'' up
Yeah, we turnin'' it up'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Blank Space', EMPTY_BLOB(), INTERVAL '3:51' MINUTE TO SECOND, 'Synth-pop', 
'Nice to meet you, where you been?
I could show you incredible things
Magic, madness, heaven, sin
Saw you there and I thought
"Oh, my God, look at that face
You look like my next mistake
Love''s a game, wanna play?" Ay
New money, suit and tie
I can read you like a magazine
Ain''t it funny rumors fly
And I know you heard about me
So hey, let''s be friends
I''m dying to see how this one ends
Grab your passport and my hand
I can make the bad guys good for a weekend
So it''s gonna be forever
Or it''s gonna go down in flames
You can tell me when it''s over, mmh
If the high was worth the pain
Got a long list of ex-lovers
They''ll tell you I''m insane
''Cause you know I love the players
And you love the game
''Cause we''re young and we''re reckless
We''ll take this way too far
It''ll leave you breathless
Or with a nasty scar
Got a long list of ex-lovers
They''ll tell you I''m insane
But I''ve got a blank space, baby
And I''ll write your name
Cherry lips, crystal skies
I could show you incredible things
Stolen kisses, pretty lies
You''re the King, baby, I''m your Queen
Find out what you want
Be that girl for a month
Wait, the worst is yet to come, oh, no
Screaming, crying, perfect storms
I can make all the tables turn
Rose garden filled with thorns
Keep you second guessing like
"Oh, my God, who is she?"
I get drunk on jealousy
But you''ll come back each time you leave
''Cause, darling, I''m a nightmare dressed like a daydream
So it''s gonna be forever
Or it''s gonna go down in flames
You can tell me when it''s over, mmh
If the high was worth the pain
Got a long list of ex-lovers
They''ll tell you I''m insane
''Cause you know I love the players
And you love the game
''Cause we''re young and we''re reckless (oh)
We''ll take this way too far
It''ll leave you breathless (oh)
Or with a nasty scar
Got a long list of ex-lovers
They''ll tell you I''m insane (insane)
But I''ve got a blank space, baby
And I''ll write your name
Boys only want love if it''s torture
Don''t say I didn''t say, I didn''t warn ya
Boys only want love if it''s torture
Don''t say I didn''t say, I didn''t warn ya
So it''s gonna be forever
Or it''s gonna go down in flames
You can tell me when it''s over (over)
If the high was worth the pain
Got a long list of ex-lovers
They''ll tell you I''m insane (I''m insane)
''Cause you know I love the players
And you love the game
''Cause we''re young and we''re reckless
We''ll take this way too far (ooh)
It''ll leave you breathless, mmh
Or with a nasty scar (leave a nasty scar)
Got a long list of ex-lovers
They''ll tell you I''m insane
But I''ve got a blank space, baby
And I''ll write your name'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Wildest Dreams', EMPTY_BLOB(), INTERVAL '3:40' MINUTE TO SECOND, 'Synth-pop',
'He said, "Let''s get out of this town
Drive out of the city, away from the crowds"
I thought heaven can''t help me now
Nothing lasts forever, but this is gonna take me down
He''s so tall and handsome as hell
He''s so bad but he does it so well
I can see the end as it begins
My one condition is
Say you''ll remember me standing in a nice dress
Staring at the sunset, babe
Red lips and rosy cheeks
Say you''ll see me again
Even if it''s just in your wildest dreams, ah-ha
Wildest dreams, ah-ha
I said, "No one has to know what we do"
His hands are in my hair, his clothes are in my room
And his voice is a familiar sound
Nothing lasts forever but this is getting good now
He''s so tall and handsome as hell
He''s so bad but he does it so well
And when we''ve had our very last kiss
My last request it is
Say you''ll remember me standing in a nice dress
Staring at the sunset, babe
Red lips and rosy cheeks
Say you''ll see me again
Even if it''s just in your wildest dreams, ah-ha
Wildest dreams, ah-ha
You''ll see me in hindsight
Tangled up with you all night
Burnin'' it down
Someday when you leave me
I bet these memories
Follow you around
You''ll see me in hindsight
Tangled up with you all night
Burnin'' it down
Someday when you leave me
I bet these memories
Follow you around
Say you''ll remember me standing in a nice dress
Staring at the sunset, babe
Red lips and rosy cheeks
Say you''ll see me again
Even if it''s just pretend
Say you''ll remember me standing in a nice dress
Staring at the sunset, babe
Red lips and rosy cheeks
Say you''ll see me again
Even if it''s just in your (Just pretend, just pretend)
Wildest dreams, ah-ha
In your wildest dreams, ah-ha
(Even if it''s just in your)
In your wildest dreams, ah-ha
In your wildest dreams, ah-ha'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Shepherd of Fire', EMPTY_BLOB(), INTERVAL '5:25' MINUTE TO SECOND, 'Heavy Metal',
'Lets take a moment and break the ice
So my intentions are known
See I pity in watching you suffer
I know the feeling of feeling of being damned alone
I got a storybook of my own
Don''t you see I am your pride
Agent of wealth
Bearer of needs
And you know it''s right
I am your war
Arming the strong
Aiding the weak
Know me by name
Shepherd of fire
Well I can promise you paradise
No need to serve on your knees
And when you''re lost in the darkest of hours
Take a moment and tell me who you see
Won''t tell ya who not to be
Now you know I am your pride
Agent of wealth
Bearer of needs
And you know it''s right
I am your war
Arming the strong
Aiding the weak
Know me by name
Shepherd of fire
Disciple of the cross and champion in suffering
Immerse yourself into the kingdom of redemption
Pardon your mind through the chains of the divine
Make way, the shepherd of fire
Through the ages of time
I''ve been known for my hate
But I''m a dealer of simple choices
For me it''s never too late
I am your pride
Agent of wealth
Bearer of needs
And you know it''s right
''Cause I am your war
Arming the strong
Aiding the weak
I am your wrath
I am your guilt
I am your lust
And you know it''s right
I am your love
I am your stall
I am your trust
Know me by name
Shepherd of fire'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Crimson Day', EMPTY_BLOB(), INTERVAL '4:58' MINUTE TO SECOND, 'Heavy Metal',
'Dark years, brought endless rain
Out in the cold I lost my way
But storms won''t last to clear the air
For something new
The sun came out and brought you through
A lifetime full of words to say
A hope that time will slow the passing day
I''ve been wrong, time''s over
And I''ve been shamed with no words to find
But if the sun will rise, bring us tomorrow
Walk with me
Crimson day
Don''t speak, no use for words
Lie in my arms, sleep secure
I wonder what you''re dreaming of
Lands rare and far
A timeless flight to reach the stars
A lifetime full of words to say
A hope that time will slow the passing day
I''ve been wrong, time''s over
And I''ve been shamed with no words to find
But if the sun will rise, bring us tomorrow
Walk with me
Crimson day
I''ve come so far to meet you here
To share this life with one I hold so dear
And I won''t speak but what is true
The world outside created just for you
It''s for you, for you
I''ve been wrong, time''s over
And I''ve been shamed with no words to find
But if the sun will rise, bring us tomorrow
Walk with me
Crimson day'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Trust', EMPTY_BLOB(), INTERVAL '4:25' MINUTE TO SECOND, 'Southern Rock',
'I''d like to tell y''all a story
About a friend of mine
Who liked to drink good whiskey oh Lord
And have a real good time
His woman you know she left him
And stole that boy''s brand new car
And ran out of town with a guitar picker
I said he gonna be a superstar sure you are
You can''t alway trust your woman
Well you can''t always trust your best friend
Beware of the ones that you need y''all
''Cause they might be the ones that do you in
Don''t talk no stuff to no slicker
Don''t tell your feelings to your friends
Don''t tell your woman that you love her because
That''s when your trouble begins
There are many ladies here among us
That''ll stab you in the back when you ain''t around
There are many so many of your very best friends
That''ll kick you in the head when you are down yes they will
You can''t always trust your woman
Well you can''t always trust your best friend
And beware of the ones that you need y''all
''Cause they might be the ones that do you in
Now don''t you backtalk the police
''Cause it''s his job to put you in the jail
They''ll lock you up boy and throw away the key
And your best friend won''t even draw your bail
There are many slickster''s here among us
That are all dressed up in suits and ties
But don''t you feel your pain Lord in front of them
Till you do you''ll kiss yourself goodnight alright
You can''t always trust your woman
You can''t always trust you best friend
And beware of the ones that you need y''all
''Cause they might be the ones that do you in
Do it again'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Double Trouble', EMPTY_BLOB(), INTERVAL '2:49' MINUTE TO SECOND, 'Southern Rock',
'Eleven times I been busted, eleven times I been to jail
Some of the times I been there nobody could go my bail
Well it seems to me, lord that this ol'' boy just don''t fit
Well I can jump in a rosebush and come out smelling like sh
Those misters dressed in blue never done so right by me
Some of the times I was innocent but the judge said guilty
I''m not one to complain son I tell you true (tell the truth boy, tell the truth)
When the black cat cross your trail, lord
It comes in misery times two
Double trouble that''s what my friends all call me
(Double trouble) (double trouble)
I said, double trouble
T-r-o-u-b-l-e (double trouble)
Well I was born down in the gutter
With a temper as hot as fire
Spent ninety days on a peat farm just doin'' the county''s time
Well now, even mama said son you''re bad news
And it won''t be too long before someone puts one through you
Double trouble that''s what my friends all call me
(Double trouble) (double trouble)
I said, double trouble
Double double (T-r-o-u-b-l-e )
Double trouble that''s what my friends all call me
(Double trouble) (double trouble)
I said, double double
T-r-o-u-b-l-e
(Double double) (trouble double)
(Double double) (trouble double)
(Double double) (double trouble)
(Double double) (trouble double)'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'End Game', EMPTY_BLOB(), INTERVAL '4:04' MINUTE TO SECOND, 'Electropop',
'I wanna be your endgame
I wanna be your first string
I wanna be your A-Team
I wanna be your endgame, endgame
Big reputation, big reputation
Ooh you and me we got big reputations, ah
And you heard about me, ooh
I got some big enemies
Big reputation, big reputation
Ooh you and me would be a big conversation, ah
And I heard about you, ooh
You like the bad ones too
You so dope, don''t overdose
I''m so stoked, I need a toast
We do the most
I''m in the Ghost like I''m whippin'' a boat
I got a reputation girl, that don''t precede me
I''m one call away, whenever you need me
I''m in a G5
Come to the A side
I got a bad boy persona that''s what they like
You love it
I love it too ''cause you my type
You hold me down and I protect you with my life
I don''t wanna touch you (I don''t wanna be)
Just anther ex-love (you don''t wanna see)
I don''t wanna miss you (I don''t wanna miss you)
Like the other girls do
I don''t wanna hurt you (I just wanna be)
Drinkin'' on a beach with (you all over me)
I know what they all say (I know what they all say)
But I ain''t tryna play
I wanna be your endgame
I wanna be your first string
I wanna be your A Team
I wanna be your endgame, endgame
Knew her when I was young
Reconnected when we were little bit older
Both sprung, I got issues and chips on both of my shoulders
Reputation precedes me, in rumors I''m knee deep
The truth is it''s easier to ignore it, believe me
Even when we''d argue, we don''t do it for long
And you understand the good and bad, end up in the song
For all your beautiful traits, and the way you do it with ease
For all my flaws, paranoia, and insecurities
I''ve made mistakes, and made some choices that''s hard to deny
After the storm, something was born on the fourth of July
I''ve passed days without fun, this endgame is the one
With four words on the tip of my tongue, I''ll never say
I don''t wanna touch you (I don''t wanna be)
Just anther ex-love (you don''t wanna see)
I don''t wanna miss you (I don''t wanna miss you)
Like the other girls do
I don''t wanna hurt you (I just wanna be)
Drinkin'' on a beach with (you all over me)
I know what they all say
But I ain''t tryna play
I wanna be your endgame
I wanna be your first string
I wanna be your A Team
I wanna be your endgame, endgame
Big reputation, big reputation
Ooh you and me we got big reputations, ahh
And you heard about me, ooh
I got some big enemies
Big reputation, big reputation
Ooh you and me would be a big conversation, ahh
And I heard about you, ooh
You like the bad ones too
I hit you like bang
We tried to forget it, but we just couldn''t
And I bury hatchets but I keep maps of where I put ''em
Reputation precedes me, they told you I''m crazy
I swear I don''t love the drama, it loves me
And I can''t let you go, your hand print''s on my soul
It''s like your eyes are liquor, it''s like your body is gold
You''ve been calling my bluff on all my usual tricks
So here''s the truth from my red lips
I wanna be your endgame
I wanna be your first string
I wanna be your A Team
I wanna be your endgame, endgame
I wanna be your endgame
I wanna be your first string
I wanna be your A Team
I wanna be your endgame, endgame'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Look What You Made Me Do', EMPTY_BLOB(), INTERVAL '3:31' MINUTE TO SECOND, 'Electropop',
'I don''t like your little games
Don''t like your tilted stage
The role you made me play of the fool
No, I don''t like you
I don''t like your perfect crime
How you laugh when you lie
You said the gun was mine
Isn''t cool, no, I don''t like you
But I got smarter, I got harder in the nick of time
Honey, I rose up from the dead, I do it all the time
I got a list of names, and yours is in red, underlined
I check it once, then I check it twice, oh!
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me-
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me do
I don''t like your kingdom keys
They once belonged to me
You asked me for a place to sleep
Locked me out and threw a feast (what?)
The world moves on, another day another drama, drama
But not for me, not for me, all I think about is karma
And then the world moves on, but one thing''s for sure
Maybe I got mine, but you''ll all get yours
But I got smarter
I got harder in the nick of time (nick of time)
Honey, I rose up from the dead
I do it all the time (I do it all the time)
I got a list of names, and yours is in red, underlined
I check it once, then I check it twice, oh!
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me-
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me do
I don''t trust nobody and nobody trusts me
I''ll be the actress starring in your bad dreams
I don''t trust nobody and nobody trusts me
I''ll be the actress starring in your bad dreams
I don''t trust nobody and nobody trusts me
I''ll be the actress starring in your bad dreams
I don''t trust nobody and nobody trusts me
I''ll be the actress starring in your bad dreams
I''m sorry
But the old Taylor can''t come to the phone right now
Why? Oh, ''cause she''s dead (oh)
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me-
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me do
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me-
Ooh, look what you made me do
Look what you made me do
Look what you just made me do
Look what you just made me do'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Into You', EMPTY_BLOB(), INTERVAL '4:04' MINUTE TO SECOND, 'R' || chr(38) || 'B',
'I''m so into you
I can barely breathe
And all I wanna do
Is to fall in deep
But close ain''t close enough
''Til we cross the line, yeah, yeah
So name a game to play
And I''ll role the dice, hey
Oh, baby, look what you started
The temperature''s rising in here
Is this gonna happen?
Been waiting and waiting for you
To make a move
(Woo, ooh, ooh)
Before I make a move
(Woo, ooh, ooh)
So baby, come light me up
And maybe I''ll let you on it
A little bit dangerous,
But baby, that''s how I want it
A little less conversation, and
A little more touch my body
''Cause I''m so into you
Into you
Into you
Got everyone watchin'' us
So baby, let''s keep it secret
A little bit scandalous
But baby, don''t let them see it
A little less conversation and
A little more touch my body
''Cause I''m so into you
Into you
Into you
Oh, yeah
This could take some time, hey
I made too many mistakes
Better get this right, right, baby
Oh, baby, look what you started
The temperature''s rising in here
Is this gonna happen?
Been waiting and waiting for you to make a move
(Woo, ooh, ooh)
Before I make a move
(Woo, ooh, ooh)
So baby, come light me up
And maybe I''ll let you on it
A little bit dangerous
But baby, that''s how I want it
A little less conversation, and
A little more touch my body
''Cause I''m so into you
Into you
Into you
Got everyone watchin'' us
So baby, let''s keep it secret
A little bit scandalous
But baby, don''t let them see it
A little less conversation and
A little more touch my body
''Cause I''m so into you
Into you (''Cause I''m so into you)
Into you
Tell me what you came here for
''Cause I can''t, I can''t wait no more
I''m on the edge with no control
And I need, I need you to know
You to know, oh
So baby, come light me up
And maybe I''ll let you on it
A little bit dangerous
But baby, that''s how I want it
A little less conversation, and
A little more touch my body
''Cause I''m so into you
Into you
Into you
Got everyone watchin'' us
So baby, let''s keep it secret
A little bit scandalous
But baby, don''t let them see it
A little less conversation and
A little more touch my body
''Cause I''m so into you
Into you
Into you
So come light me up
So come light me up, my baby
A little dangerous
A little dangerous my baby
A little less conversation and
A little more touch my body
''Cause I''m so into you
Into you
Into you'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Everyday', EMPTY_BLOB(), INTERVAL '3:14' MINUTE TO SECOND, 'R' || chr(38) || 'B', 
'Anytime I''m alone, I can''t help thinking about you
All I want, all I need, honestly, it''s just me and you
He giving me that good shit
That make me not quit, that good shit
He giving me that good shit
That make me not quit, that good shit
Oh, he give it to me
Everyday, everyday, everyday
He give it to me
Everyday, everyday, everyday
Oh, he give it to me
Everyday, everyday, everyday
He give it to me
Everyday, everyday, everyday
Anytime, anywhere, baby boy, I can misbehave
Breathe me in, breathe me out, fill me up
Running through your veins
He giving me that good shit
That make me not quit, that good shit
He giving me that good shit
That make me not quit, that good shit
Oh, he give it to me
Everyday, everyday, everyday
He give it to me
Everyday, everyday, everyday
Oh, he give it to me
Everyday, everyday, everyday
He give it to me
Everyday, everyday, everyday
Make me go
La, la, la, la, la, la, la, la
La, la, la, la, la, la
Everyday, everyday
La, la, la, la, la, la, la, la
La, la, la, la, la, la
Everyday, everyday
I put that work on you everyday
When the night fall ''til the sun come
You done fell in love with a bad guy
I don''t compromise my passion
It''s not what you do for me, I''m doing the same for you
I don''t be tripping or making mistakes
I made too many in my past (that''s right)
I fight for the things you believe in
I got your body and put it on drive and
I got the keys and
We about to take us a vacation
I''m about to put all this vintage loving on you
Baby like it was the late 80s
When you ride on me, baby rotate it
He giving me that good shit
That make me not quit, that good shit
Oh, he give it to me
Everyday, everyday, everyday
He give it to me
Everyday, everyday, everyday
Oh, he give it to me
Everyday, everyday, everyday
He give it to me
Everyday, everyday, everyday
Make me go
La, la, la, la, la, la, la, la
La, la, la, la, la, la
Everyday, everyday
La, la, la, la, la, la, la, la
La, la, la, la, la, la
Everyday, everyday
Give it to me, to me
(She got me on it)
Oh, he give it to me every day
(She got me on it)'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'You Got That Right', EMPTY_BLOB(), INTERVAL '3:44' MINUTE TO SECOND, 'Southern Rock', 
'Well I''ve heard lots''a people say they''re gonna settle down
You don''t see their faces and they don''t come around
Well I''m not that way I''ve got to move along
I like to drink and dance all night
Comes to a fix not afraid to fight
You got that right
Said you got that right
Sure got that right
Seems so long I''ve been out on my own
Travelin'' light and I''m always alone
Guess I was born with the travelin'' bone
When my times up I''m on my own
You won''t find me in an old folk''s home
You got that right
Said you got that right
Well you got that right
Sure got that right
I tried everything in my life (Uh-huh)
The things I like I try ''em twice
You got that right
You sure got that right
Travelin'' around the world singing my song
I got to go Lord I can''t stay long
Here comes that old travelin'' jones once again
I like to drink and dance all night
Comes to a fix not afraid to fight
You got that right
Said you got that right
Well you got that right
Sure got that right'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'I Never Dreamed', EMPTY_BLOB(), INTERVAL '5:21' MINUTE TO SECOND, 'Southern Rock', 
'My daddy told me always be strong son
Don''t you ever cry
You find the pretty girls, and then you love them
And then you say goodbye
I never dreamed that you would leave me
But now you''re gone
I never dreamed that I would miss you
Woman won''t you come back home
I never dreamed that you could hurt me
And leave me blue
I''ve had a thousand, maybe more
But never one like you
I never dreamed I could feel so empty
But now I''m down
I never dreamed that I would beg you
But woman I need you now
It seems to me, I took your love for granted
It feels to me, this time I was wrong, so wrong
Oh Lord, how I feel so lonely
I said woman, won''t you come back home
I tried to do what my daddy taught me,
But I think he knew
Someday I would find
One woman like you
I never dreamed it could feel so good Lord
That two could be one
I never knew about sweet love
So woman won''t you come back home
Oh baby won''t you come back home'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Welcome to the Family', EMPTY_BLOB(), INTERVAL '4:05' MINUTE TO SECOND, 'Heavy Metal', 
'Hey kid (hey kid)
Do I have your attention?
I know the way you''ve been living
Life''s so reckless, tragedy endless
Welcome to the family
Hey
There''s something missing
Only time will alter your vision
Never in question, lethal injection
Welcome to the family
Not long ago you find the answers were so crystal clear
Within a day you find yourself living in constant fear
Can you look at yourself now, can you look at yourself?
You can''t win this fight
In a way it seems there''s no one to call
When our thoughts are so numb
And our feelings unsure
We all have emptiness inside, we all have answers to find
But you can''t win this fight
Hey kid (hey kid)
I have to question
What''s with the violent aggression
Details blurry, lost him too early
Welcome to the family
Hey
Why won''t you listen?
Can''t help the people you''re missing
It''s been done, a casualty rerun
Welcome to the family
I try and help you with the things that can''t be justified
I need to warn you that there is no way to rationalize
So have you figured it out now, so have you figured it out?
You can''t win this fight
And in a way it seems there''s no one to call
When our thoughts are so numb
And our feelings unsure
We all have emptiness inside, we all have answers to find
But you can''t win this fight!
Here for you and all mankind
I''ve lost my mind
Psychotic rounds in rabid dementia
I won''t be fine
I see you''re a king who''s been dethroned
Cast out in a world you''ve never know
Stand down, place your weapon by your side
It''s our war in the end, we''ll surely lose but that''s alright
So have you figured it out now, so have you figured it out?
And in a way it seems there''s no one to call
When our thoughts are so numb
And our feelings unsure
We all have emptiness inside, we all have answers to find
But you can''t win this fight
Deep inside where nothing''s fine
I''ve lost my mind
You''re not invited, so step aside
I''ve lost my
Deep inside where nothing''s fine
I''ve lost my mind
You''re not invited, so step aside
I''ve lost my'
); 

INSERT INTO song 
VALUES(song_SongID_seq.NEXTVAL, 'Buried Alive', EMPTY_BLOB(), INTERVAL '6:44' MINUTE TO SECOND, 'Heavy Metal', 
'Take the time just to listen
When the voices screaming are much too loud
Take a look in the distance
Try and see it all
Chances are that you might find
That we share a common discomfort now
I feel I''m walking a fine line
Tell me only if it''s real
Still I''m on my way
(On and on it goes)
Vacant hope to take
Hey, I can''t live in here for another day
Darkness has kept the light concealed
Grim as ever
Hold onto faith as I dig another grave
Meanwhile the mice endure the wheel
Real as ever
And it seems I''ve been buried alive
I walked the fields through the fire
Taking steps until I found solid ground
Followed dreams reaching higher
Couldn''t survive the fall
Much has changed since the last time
And I feel a little less certain now
You know I jumped at the first sign
Tell me only if it''s real
Memories seem to fade
(On and on it goes)
Wash my view away
Hey, I can''t live in here for another day
Darkness has kept the light concealed
Grim as ever
Hold onto faith as I dig another grave
Meanwhile the mice endure the wheel
Real as ever
And I''m chained like a slave
Trapped in the dark
Slammed all the locks
Death calls my name
And it seems I''ve been buried alive
Take you down now
Burn it all out
Throw you all around
Get your fucking hands off me!
What''s it feel like?
Took the wrong route
Watch it fall apart
Now you''re knockin'' at the wrong gate
For you to pay the toll
A price for you alone
The only deal you''ll find
I''ll gladly take your soul
While it seems sick
Sober up quick
Psycho lunatic
Crushing you with hands of fate
Shame to find out when it''s too late
But you''re all the same
Trapped inside inferno awaits
Evil thoughts can hide
I''ll help release the mind
I''ll peel away the skin
Release the dark within
This is now your life
Strike you from the light
This is now your life
Die buried alive
This is now your life (what''s it feel like?)
Strike you from the light (let me take in your soul)
This is now your life (what''s it feel like?)
Die buried alive (let me take in your soul)
This is now your life
Die buried alive'
); 

-- Add Aerosmith's Album and Song Mapping
INSERT INTO artist_album
VALUES (1, 2);
INSERT INTO artist_album
VALUES (1, 5);

INSERT INTO artist_song
VALUES (1, 3, 'Y');
INSERT INTO artist_song
VALUES (1, 4, 'Y');
INSERT INTO artist_song
VALUES (1, 9, 'Y');
INSERT INTO artist_song
VALUES (1, 10, 'Y');

INSERT INTO song_album
VALUES (3, 2, 4);
INSERT INTO song_album
VALUES (4, 2, 6);
INSERT INTO song_album
VALUES (9, 5, 5);
INSERT INTO song_album
VALUES (10, 5, 8);

-- Add The Beatles' Album and Song Mapping
INSERT INTO artist_album
VALUES (2, 1);
INSERT INTO artist_album
VALUES (2, 7);

INSERT INTO artist_song
VALUES (2, 13, 'Y');
INSERT INTO artist_song
VALUES (2, 14, 'Y');
INSERT INTO artist_song
VALUES (2, 1, 'Y');
INSERT INTO artist_song
VALUES (2, 2, 'Y');

INSERT INTO song_album
VALUES (13, 7, 1);
INSERT INTO song_album
VALUES (14, 7, 3);
INSERT INTO song_album
VALUES (1, 1, 1);
INSERT INTO song_album
VALUES (2, 1, 10);

-- Add Honeyclaws' Album and Song Mapping
INSERT INTO artist_album
VALUES (3, 3);
INSERT INTO artist_album
VALUES (3, 6);

INSERT INTO artist_song
VALUES (3, 5, 'Y');
INSERT INTO artist_song
VALUES (3, 6, 'Y');
INSERT INTO artist_song
VALUES (3, 11, 'Y');
INSERT INTO artist_song
VALUES (3, 12, 'Y');

INSERT INTO song_album
VALUES (5, 3, 3);
INSERT INTO song_album
VALUES (6, 3, 5);
INSERT INTO song_album
VALUES (11, 6, 9);
INSERT INTO song_album
VALUES (12, 6, 2);

-- Add Skrillex's Album and Song Mapping
INSERT INTO artist_album
VALUES (4, 4);
INSERT INTO artist_album
VALUES (4, 8);

INSERT INTO artist_song
VALUES (4, 7, 'Y');
INSERT INTO artist_song
VALUES (4, 8, 'Y');
INSERT INTO artist_song
VALUES (4, 15, 'Y');
INSERT INTO artist_song
VALUES (4, 16, 'Y');

INSERT INTO song_album
VALUES (7, 4, 3);
INSERT INTO song_album
VALUES (8, 4, 7);
INSERT INTO song_album
VALUES (15, 8, 1);
INSERT INTO song_album
VALUES (16, 8, 3);

-- Add Taylor Swift's Album and Song Mapping
INSERT INTO artist_album
VALUES (5, 10);
INSERT INTO artist_album
VALUES (5, 13);

INSERT INTO artist_song
VALUES (5, 19, 'Y');
INSERT INTO artist_song
VALUES (5, 20, 'Y');
INSERT INTO artist_song
VALUES (5, 25, 'Y');
INSERT INTO artist_song
VALUES (5, 26, 'Y');

INSERT INTO song_album
VALUES (19, 10, 2);
INSERT INTO song_album
VALUES (20, 10, 9);
INSERT INTO song_album
VALUES (25, 13, 2);
INSERT INTO song_album
VALUES (26, 13, 13);

-- Add Lynyrd Skynyrd's Album and Song Mapping
INSERT INTO artist_album
VALUES (6, 12);
INSERT INTO artist_album
VALUES (6, 15);

INSERT INTO artist_song
VALUES (6, 23, 'Y');
INSERT INTO artist_song
VALUES (6, 24, 'Y');
INSERT INTO artist_song
VALUES (6, 29, 'Y');
INSERT INTO artist_song
VALUES (6, 30, 'Y');

INSERT INTO song_album
VALUES (23, 12, 3);
INSERT INTO song_album
VALUES (24, 12, 5);
INSERT INTO song_album
VALUES (29, 15, 5);
INSERT INTO song_album
VALUES (30, 15, 6);

-- Add Avenged Sevenfold's Album and Song Mapping
INSERT INTO artist_album
VALUES (7, 11);
INSERT INTO artist_album
VALUES (7, 16);

INSERT INTO artist_song
VALUES (7, 21, 'Y');
INSERT INTO artist_song
VALUES (7, 22, 'Y');
INSERT INTO artist_song
VALUES (7, 31, 'Y');
INSERT INTO artist_song
VALUES (7, 32, 'Y');

INSERT INTO song_album
VALUES (21, 11, 1);
INSERT INTO song_album
VALUES (22, 11, 6);
INSERT INTO song_album
VALUES (31, 16, 2);
INSERT INTO song_album
VALUES (32, 16, 4);

-- Add Ariana Grande's Album and Song Mapping
INSERT INTO artist_album
VALUES (8, 9);
INSERT INTO artist_album
VALUES (8, 14);

INSERT INTO artist_song
VALUES (8, 17, 'Y');
INSERT INTO artist_song
VALUES (8, 18, 'Y');
INSERT INTO artist_song
VALUES (8, 27, 'Y');
INSERT INTO artist_song
VALUES (8, 28, 'Y');

INSERT INTO song_album
VALUES (17, 9, 9);
INSERT INTO song_album
VALUES (18, 9, 10);
INSERT INTO song_album
VALUES (27, 14, 4);
INSERT INTO song_album
VALUES (28, 14, 9);

COMMIT; 