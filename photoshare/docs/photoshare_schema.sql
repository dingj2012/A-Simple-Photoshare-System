DROP TABLE Pictures CASCADE;
DROP TABLE Users CASCADE;
DROP TABLE Albums CASCADE;
DROP TABLE Friends CASCADE;
DROP TABLE Comments CASCADE;
DROP TABLE Tags CASCADE;
DROP TABLE AlbumHas CASCADE;

DROP SEQUENCE Pictures_picture_id_seq;
DROP SEQUENCE Users_user_id_seq;
DROP SEQUENCE Tags_tagid_seq;
DROP SEQUENCE Comments_commentid_seq;
DROP SEQUENCE Albums_albumid_seq;

CREATE SEQUENCE Users_user_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 14
  CACHE 1;

CREATE TABLE Users
(
  user_id int4 NOT NULL DEFAULT nextval('Users_user_id_seq'),
  email varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  role_name varchar(255) NOT NULL DEFAULT 'RegisteredUser',
  firstname varchar(50) NOT NULL,
  lastname varchar(50) NOT NULL,
  dob char(8) NOT NULL,
  gender char(1),
  hometown varchar(100),
  PRIMARY KEY (user_id)
);

INSERT INTO Users (email, password, firstname, lastname, dob) VALUES ('test@bu.edu', 'test', 'test', 'test', 'testtest');
INSERT INTO Users (user_id, email, password, firstname, lastname, dob) VALUES (2, 'anon@bu.edu', 'anon', 'Anonymous',' ', 'anon');
INSERT INTO Users (user_id, email, password, firstname, lastname, dob) VALUES (13, 'bot@bu.edu', 'bot', 'bot', 'bot', 'botbot');

CREATE SEQUENCE Pictures_picture_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 14
  CACHE 1;

CREATE TABLE Pictures
(
  picture_id int4 NOT NULL DEFAULT nextval('Pictures_picture_id_seq'),
  caption varchar(255) NOT NULL,
  imgdata bytea NOT NULL,
  size int4 NOT NULL,
  content_type varchar(255) NOT NULL,
  thumbdata bytea NOT NULL,
  ownerid integer NOT NULL,
  PRIMARY KEY (picture_id),
  FOREIGN KEY (ownerid) REFERENCES Users(user_id)
); 

CREATE SEQUENCE Albums_albumid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 14
  CACHE 1;

CREATE TABLE Albums
(
	albumid integer NOT NULL DEFAULT nextval('Albums_albumid_seq'),
	ownerid integer NOT NULL,
	name varchar(45) NOT NULL,
	dateofcreation date NOT NULL,
	PRIMARY KEY (albumid),
	FOREIGN KEY (ownerid) REFERENCES Users(user_id)
);

CREATE SEQUENCE Comments_commentid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 14
  CACHE 1;

CREATE TABLE Comments 
(
	commentid integer NOT NULL DEFAULT nextval('Comments_commentid_seq'),
	ownerid integer,
	photoid integer,
	text varchar(255),
	dateofcomment date NOT NULL,
	ownername varchar(255),
	PRIMARY KEY (commentid),
	FOREIGN KEY (ownerid) REFERENCES Users(user_id),
	FOREIGN KEY (photoid) REFERENCES Pictures(picture_id)
);

CREATE SEQUENCE Tags_tagid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 14
  CACHE 1;

CREATE TABLE Tags
(
	pictureid integer NOT NULL,
	tagid integer NOT NULL DEFAULT nextval('Tags_tagid_seq'),
	tag varchar(100),
	PRIMARY KEY (tagid),
	FOREIGN KEY (pictureid) REFERENCES Pictures(picture_id)
);

CREATE TABLE AlbumHas
(
	albumid integer NOT NULL,
	pictureid integer NOT NULL,
	PRIMARY KEY (albumid, pictureid),
	FOREIGN KEY (albumid) REFERENCES Albums(albumid),
	FOREIGN KEY (pictureid) REFERENCES Pictures(picture_id)
);

CREATE TABLE Friends
(
	user1 integer NOT NULL,
	user2 integer NOT NULL,
	PRIMARY KEY (user1, user2),
	FOREIGN KEY (user1) REFERENCES Users(user_id),
	FOREIGN KEY (user2) REFERENCES Users(user_id)
);
