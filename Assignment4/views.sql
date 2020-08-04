@D:/dbms/air_cre;
@D:/dbms/air_pop;
set echo on;
set linesize 200;
set pagesize 50;

REM : Dropping views....

drop view schedule_15;
drop view airtype;
drop view losangeles_route;
drop view losangeles_flight;

REM : 1
REM : Create a view Schedule_15 that display the flight number, route, airport(origin, destination)
REM : departure (date, time), arrival (date, time) of a flight on 15 apr 2005. Label the view column
REM : as flight, route, from_airport, to_airport, ddate, dtime, adate, atime respectively.

create view schedule_15(flight,route,from_airport,to_airport,ddate,dtime,adate,atime)
as 
select 
	f.flightNo,r.routeId,r.orig_airport,r.dest_airport,
	fl.departs,fl.dtime,fl.arrives,fl.atime 
from 
	routes r,flights f,fl_schedule fl where f.rid = r.routeId 
	and f.flightNo = fl.flno and fl.departs = '15-apr-2005';

select * from schedule_15;

savepoint point1;

--Error updatings...
	update schedule_15 set from_airport='Los Vegas' where flight='RP-5018';
	update schedule_15 set to_airport='Los Vegas' where flight='RP-5018'
	update schedule_15 set route='MM203' where flight='RP-5018';
	update schedule_15 set flight='9E-3749' where route='MD200';

REM : updating the values in views will also update the table....

	update schedule_15 set dtime = 1130 where flight = 'HA-1';
--View table
	select * from schedule_15 where flight = 'HA-1';
--Base table
	select flno,dtime from fl_schedule where flno = 'HA-1';


	update schedule_15 set atime = 1130 where flight = 'HA-1';
--View table
	select * from schedule_15 where flight = 'HA-1';
--Base table
	select flno,atime from fl_schedule where flno = 'HA-1';


	update schedule_15 set ddate = '16-APR-05' where flight = 'SQ-11';
--View table
	select * from schedule_15 where flight = 'SQ-11';
--Base table
	select flno,departs from fl_schedule where flno = 'SQ-11';


	update schedule_15 set adate = '16-APR-05' where flight = 'HA-1';
--View table
	select * from schedule_15 where flight = 'HA-1';
--Base table
	select flno,arrives from fl_schedule where flno = 'HA-1';

REM : deleting the values in views will also delete in the base table....
	delete from schedule_15 where flight = 'HA-1';
--View table
	select * from schedule_15 where flight = 'HA-1';
--Base table
	select * from fl_schedule where flno = 'HA-1';

REM : Insertion cannot be done in view tables...
insert into schedule_15 values('HA-1','LH106','Los Angeles','Honolulu','15-apr-05','1230','16-apr-05','2055');

rollback to point1;

REM : 2
REM : Define a view Airtype that display the number of aircrafts for each of its type. Label the
REM : column as craft_type, total.

create view airtype(craft_type,total)
as
select a.type,count(a.type) from aircraft a group by a.type;

select * from airtype;


REM : update cannot be done on airtype views....
	update airtype set total = 5 where craft_type='Saab';
	update airtype set craft_type='Saab' where total = 1;

REM : deleting the values in views will also delete in the base table....
	delete from airtype where craft_type='Saab';

REM : Insertion cannot be done in this view tables...
	insert into airtype values('spicejet','4');


REM : 3
REM : Create a view Losangeles_Route that display the information about Los Angeles route.
REM : Ensure that the view always contain/allows only information about the Los Angeles route.


create view losangeles_route
as
select * from routes
where
 orig_airport = 'Los Angeles' or dest_airport  = 'Los Angeles';

select * from losangeles_route;
savepoint point2;

REM : updating the values in views will also update the table....
	update losangeles_route set distance = 1130 where routeid = 'LW100';
--View table
	select * from losangeles_route where routeid = 'LW100';
--Base table
	select * from routes
where
 routeid = 'LW100';

	update losangeles_route set orig_airport = 'Tokyo' where routeid = 'LC101';
--View table
	select * from losangeles_route where routeid = 'LC101';
--Base table
	select * from routes
where
 routeid = 'LC101';

	update losangeles_route set dest_airport = 'Tokyo' where routeid = 'LW100';
--View table
	select * from losangeles_route where routeid = 'LW100';
--Base table
	select * from routes
where
 routeid = 'LW100';

--Error updating...
	update losangeles_route set routeid = 'AM101' where dest_airport = 'New York';


REM : deleting cannot be done in this view....
	delete from losangeles_route where routeid = 'LW100';

REM : Insertion can be done in this view tables which will also insert it into the base table...
insert into losangeles_route values('LH107','Los Angeles','Los vegas','4500');

--View table
	select * from losangeles_route where routeid = 'LH107';
--Base table
	select * from routes where routeid = 'LH107';
rollback to point2;

REM : 4
REM : Create a view named Losangeles_Flight on Schedule_15 (as defined in 1) that display flight,
REM : departure (date, time), arrival (date, time) of flight(s) from Los Angeles.

create view losangeles_flight
as
select flight,ddate,dtime,adate,atime from schedule_15
where
 from_airport = 'Los Angeles';

select * from losangeles_flight;
savepoint point3;
REM : updating the values in views will also update the table....
	update losangeles_flight set dtime = 1130 where flight = 'SQ-11';
--View table
	select * from losangeles_flight where flight = 'SQ-11';
--Base table
	select * from fl_schedule
where
flno = 'SQ-11';

	update losangeles_flight set atime = 1130 where flight = 'HA-1';
--View table
	select * from losangeles_flight where flight = 'HA-1';
--Base table
	select flight ,atime from schedule_15 where flight = 'HA-1';


	update losangeles_flight set ddate = '16-APR-05' where flight = 'HA-1';
--View table
	select * from losangeles_flight where flight = 'HA-1';
--Base table
	select flight ,ddate from schedule_15 where flight = 'HA-1';


	update losangeles_flight set adate = '16-APR-05' where flight = 'SQ-11';
--View table
	select * from losangeles_flight where flight = 'SQ-11';
--Base table
	select flight ,adate from schedule_15 where flight = 'SQ-11';

REM : deleting can be done in this view....
	delete from losangeles_flight where flight = 'SQ-11';

--View table
	select * from losangeles_flight where flight = 'SQ-11';
--Base table
	select * from fl_schedule
where
flno = 'SQ-11';

REM : Insertion can not be done in this view tables since a key is non preserved key...
insert into losangeles_flight values('SQ-11','15-APR-05','1130','16-APR-05','2055');

rollback to point3;
