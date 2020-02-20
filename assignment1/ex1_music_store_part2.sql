REM : Deleting table based on hierarchy

drop table sungby;

drop table artist;

drop table song;

drop table album;

drop table musician;

drop table studio;



create table musician(
Musician_ID varchar2(4) constraint pk1 primary key,
Name char(20) constraint name_null not null,
birthplace char(15));

create table studio(
studio_name char(20) constraint pk2 primary key,
address char(25),
phone number(10));

create table album(
album_name char(20),
album_ID varchar2(4) constraint pk3 primary key,
yearofrelease number(4) constraint year_check check(yearofrelease >=1945),
no_tracks number(2),
studio_name char(20) constraint fk1 references studio(studio_name),
album_genre varchar2(3) constraint genre_check check( album_genre in('CAR', 'DIV', 'MOV', 'POP')),
Musician_ID varchar2(4) constraint fk2 references musician(Musician_ID) );

create table song(
album_ID varchar2(4) constraint fk3 references album(album_ID),
track_no varchar2(2),
primary key(album_ID,track_no),
song_name char(20) constraint name_null1 not null,
song_genre char(3) constraint gen_check check( song_genre in('PHI', 'REL', 'LOV', 'PAT')),
length number(2),
constraint chk check((length>7 AND song_genre='PAT') OR song_genre!='PAT'));

create table artist(
artist_ID varchar2(4) constraint pk4 primary key,
artist_name char(20) constraint name_uq1 unique);

create table sungby(
album_ID varchar2(4),
artist_ID varchar2(4) constraint fk5 references artist(artist_ID),
track_no varchar2(2),
foreign key(album_ID,track_no) references song(album_ID,track_no) on delete cascade,
primary key(album_ID,artist_ID,track_no),
recorded_date date);








desc musician;
desc album;
desc song;
desc artist;
desc sungby;
desc studio;










REM: Altering.....

alter table artist add gender varchar2(1);
desc artist;

alter table song modify song_name char(30);
desc song;

alter table studio add unique (phone);

desc studio;

alter table sungby modify recorded_date date not null;
desc sungby;


alter table song drop constraint gen_check;
alter table song add constraint gen_check check( song_genre in('PHI', 'REL', 'LOV', 'PAT','NAT'));










REM: Entering datas into Musician tables

insert into musician values('M001','Anirudh','chennai');
insert into musician values('M002','','trichy');
insert into musician values('M002','Imman','trichy');
insert into musician values('M003','Ajaz','palani');

REM: Musician ID is primary key so duplicate is not allowed
insert into musician values('M001','Ani','chennai');

select * from musician;







REM: Entering datas into studio tables

insert into studio values('AGS','Nungambakkam','8466522201');
insert into studio values('Le studio','Vadapalani','7896452123');
insert into studio values('Bass studio','anna nagar','9564723654');

REM: Phone number is unique so duplicate is not allowed
insert into studio values('Lahari','palani','7896452123');

select * from studio;








REM: Entering datas into Album tables

REM: Album Genre check does not contains NOV so it will display error
insert into album values('Jersey','A001','2000','3','Bass studio','NOV','M001');

insert into album values('Jersey','A001','2000','3','Bass studio','MOV','M001');
insert into album values('Maharishi','A002','2015','2','Le studio','POP','M002');

REM: Number of tracks is Not Null constrait so null will not be accepted
insert into album values('Bigil','A003','2016','','AGS','DIV','M003');

insert into album values('Bigil','A003','2016','1','AGS','DIV','M003');

REM: Year of release must be greater than 1945 so it will display error
insert into album values('Maya','A004','1943','2','Le studio','POP','M002');

select * from album;












REM: Entering datas into Song tables

insert into song values('A001','T1','Adento','REL','03');

REM: Song genre does not contains PHP so it will display error
insert into song values('A001','T2','Jersey','PHP','04');

insert into song values('A001','T2','Jersey','PHI','04');

REM: song length must be greater than 7 for PAT genre songs otherwise it will display error
insert into song values('A002','T1','padara','PAT','05');

insert into song values('A002','T1','padara','PAT','08');

select * from song;











REM: Entering datas into Artist tables


insert into artist values('a001','shreya','F');
insert into artist values('a002','sid sriram','M');

REM: Artist Name is unique key so it's value must be unique otherwise it will diplay error
insert into artist values('a003','shreya','F');

REM: Artist ID is also primary key so it should not contain duplicate values or else it will display error

insert into artist values('a002','anirudh','M');
insert into artist values('a003','anirudh','M');

select * from artist;















REM: Entering datas into sungby tables

insert into sungby values('A001','a001','T1','02JAN2015');
insert into sungby values('A001','a001','T2','03JAN2015');
insert into sungby values('A002','a003','T1','');
insert into sungby values('A002','a003','T1','05MAR2016');


select * from sungby;















REM: Retreiving tuples using artist ID, album ID, musician ID, and track number, studio name

select * from artist where artist_id='a001';
select * from album where album_id='A002';
select * from musician where musician_id='M003';
select * from song where album_id = 'A001' and track_no = 'T2';
select * from studio where studio_name = 'AGS';










REM: Deleting information

delete from song where track_no = 'T2';

select * from song;
select * from sungby;
