set echo on;
REM : 1
REM : The date of arrival should be always later than or on the same date of departure.


CREATE OR REPLACE TRIGGER date_arrival
BEFORE INSERT OR UPDATE ON fl_schedule
for each row
when(new.departs > new.arrives)
begin
raise_application_error(num=>-20001,msg=>'The date of arrival should be always later than or on the same date of departure.');
end;
/

REM : Test Cases...
REM : Failed insertion/updation
INSERT INTO fl_schedule values('AF-12','24-apr-05',1230,'22-apr-05',1450,220.25);
select * from fl_schedule where flno = 'G7-3664';
UPDATE fl_schedule set departs = '23-apr-05' where flno = 'G7-3664';

REM : successfull insertion/updation
INSERT INTO fl_schedule values('AF-12','20-apr-05',1230,'22-apr-05',1450,220.25);
select * from fl_schedule where flno = 'AF-12';
UPDATE fl_schedule set departs = '21-apr-05' where flno = 'G7-3664' and departs='22-apr-05';
select * from fl_schedule where flno = 'G7-3664' and departs ='21-apr-05' ;


REM : 2
REM : Flight number CX7520 is scheduled only on Tuesday, Friday and Sunday.
CREATE OR REPLACE TRIGGER days_flight
BEFORE INSERT OR UPDATE ON fl_schedule
for each row
declare
 week_ind int;
begin
if(:new.flno = 'CX-7520')
then
     week_ind:=to_char(:new.departs,'d');
     if (week_ind not in (1,4,6))
     then
            raise_application_error(num=>-20008,msg=>'Flight number CX-7520 is scheduled only on Tuesday, Friday and Sunday.');
     end if;
end if;
end;
/

REM : Test Cases..
REM : Failed insertion/updation
INSERT INTO fl_schedule values('CX-7520','23-apr-05',1230,'27-apr-05',1450,220.25);
select * from fl_schedule where flno = 'CX-7520';
update fl_schedule set departs='16-APR-05' where flno = 'CX-7520' and departs = '12-APR-05';

REM : successfull insertion/updation
INSERT INTO fl_schedule values('CX-7520','24-apr-05',1230,'27-apr-05',1450,220.25);
select * from fl_schedule where flno = 'CX-7520';
update fl_schedule set departs='10-APR-05' where flno = 'CX-7520' and departs = '12-APR-05';
select * from fl_schedule where flno = 'CX-7520' and departs = '12-APR-05';

REM : 3
REM : An aircraft is assigned to a flight only if its cruising range is more than the distance of the flights route.
CREATE OR REPLACE TRIGGER aircraft_assign
BEFORE INSERT OR UPDATE ON flights
for each row
declare
cruising_range aircraft.cruisingrange%type;
distance_route routes.distance%type;
cursor c1 is select cruisingrange from aircraft where aid = :new.aid;
cursor c2 is select distance from routes where routeID = :new.rID;
begin
open c1;
open c2;
fetch c1 into cruising_range;
fetch c2 into distance_route;
if(cruising_range < distance_route)
then 
	raise_application_error(num=>-20004,msg=>'Cruishing range is less than distance so flight cannot be assigned');
end if;
close c1;
close c2;
end;
/

REM : Test cases...
REM : Failed insertion/updation

select * from aircraft where aid = '16';
select * from routes where routeID = 'LW100';
insert into flights values('AM-7878','LW100',16);
select * from aircraft where aid = 2;
REM : successfull insertion/updation
insert into flights values('AM-7878','LW100',2);
select * from flights where flightNO = 'AM-7878';
update flights set aid = 16 where flightNo = '9E-3749';
update flights set aid = 5 where flightNo = '9E-3749';
select * from flights where flightNO = '9E-3749';