--*****************************************************
--CS 2258                               B.Senthil Kumar
--DBMS Lab				Asst. Prof
--	    		    Computer Science Department
--            		     SSN College of Engineering 
--	                   	     senthil@ssn.edu.in
--*****************************************************
-- 	          AIRLINES DATASET
--                 Version 1.0
--                February 05, 2013
--*****************************************************
--Sources:
--         To create airlines database run the following
--	two script files which will create and populate
-- 	the databases.
--
--******************************************************
-- run the SQL script files
set linesize 400;
set pagesize 60;
set echo on;
@F:/dbms/air_cre.sql
@F:/dbms/air_pop.sql

--**********END OF AIRLINES DB CREATION*****************


REM : Question No : 1 

REM : Display the flight number,departure date and time of a flight,
REM : its route details and aircraft name of type either Schweizer 
REM : or Piper that departs during 8.00 PM and 9.00 PM.

--*****************************************************************

select distinct f.flno,f.departs,f.dtime,f1.rID,r.orig_airport,r.dest_airport,r.distance 
from 
	fl_schedule f,flights f1,routes r,aircraft a
where 
	f.flno = f1.flightNo and f1.rID = r.routeID and f1.aid=a.aid and a.type in ('Schweizer','Piper') and f.dtime between 2000 and 2100;

--*****************************************************************







REM : Question No : 2

REM : For all the routes,display the flight number,origin and 
REM : destination airport,if a flight is assigned for that route.

--*****************************************************************

select f.flightNo,r.orig_airport,r.dest_airport,r.routeID
from 
	routes r,flights f 
where (r.routeID = f.rID);


--*****************************************************************

-- using left outer join

select f.flightNo,r.orig_airport,r.dest_airport,r.routeID
from 
	routes r left outer join flights f on (r.routeID = f.rID);



--*****************************************************************



REM : Question No : 3

REM : For all aircraft with cruishingrange over 5000 miles,find the  
REM : name of the aircraft and the average salary of all pilots certified
REM : for this aircraft.

--*****************************************************************

select a.aname,avg(e.salary),a.cruisingrange 
from 
	aircraft a,certified c, employee e 
where 
	a.aid=c.aid and c.eid=e.eid and a.cruisingrange > 5000 
group by 
	a.aname,a.cruisingrange;




--*****************************************************************






REM : Question No : 4

REM : Show the employee details such as id,name and salary who are not 
REM : pilots and whose salary is more than average salary of pilots

--*****************************************************************


select distinct e.eid,e.ename,e.salary from employee e,certified c 
where 
	e.eid not in (select eid from certified) and 
	e.salary > (select distinct avg(e1.salary) 
		    from 
		    	employee e1,certified c1 
		    where 
			e1.eid = c1.eid);


--*****************************************************************






REM : Question No : 5

REM : Find the id and name of pilots who were certified to operate some 
REM : aircrafts but at least one of that aircraft is not scheduled from
REM : any routes.

--*****************************************************************


select distinct e.eid,e.ename 
from 
	employee e,certified c,aircraft a
where 
	c.eid = e.eid and c.aid = a.aid and a.aid not in (select aid from flights);


--*****************************************************************







REM : Question No : 6

REM : Display the origin and destination of flights having atleast three
REM : departures with maximum distance covered.

--*****************************************************************

select distinct orig_airport,dest_airport
from
 routes
where
 distance = (select max(distance) 
	     from 
		routes 
	     where 
		distance in (select max(distance)
      			     from
   			     	routes r,flights f
			     where
				r.routeid = f.rid
      			     having
   				count(orig_airport) >=3 
      			     group by orig_airport
			    )
	    );

--*****************************************************************








REM : Question No : 7

REM : Display the name and salary of pilot whose salary is more than the
REM : average salary of any pilots for each route other than the flights
REM : originating from Madison airport.


--*****************************************************************

select emp.ename,emp.salary 
from 
	employee emp,certified c,flights f,routes r  
where 
	emp.eid = c.eid and c.aid = f.aid and r.routeid = f.rid and
	r.orig_airport != 'Madison' and 
	emp.salary > (select avg(e.salary) 
		      from 
				employee e,certified c,flights f
		      where 
				e.eid = c.eid and c.aid = f.aid and r.orig_airport != 'Madison') 
group by 
	emp.salary,emp.ename;



--*****************************************************************









REM : Question No : 8

REM : Display the flight number,aircraft type,source and destination airport 
REM : of the aircraft having maximum number of flights to Honolulu

--*****************************************************************

select f.flightNo,a.type,r.orig_airport,dest_airport 
from 
	routes r,flights f,aircraft a 
where 
	r.routeid = f.rid and f.aid = a.aid and
	dest_airport = 'Honolulu' and 
	a.type = (select ar.type 
		  from 
			routes r1,flights f1,aircraft ar 
		  where 
			r1.routeid = f1.rid and f1.aid = ar.aid and 
			dest_airport = 'Honolulu' 
		  having 
			count(ar.type) = (select max(count(a.type)) 
					  from 
						routes r,flights f,aircraft a
					  where 
						r.routeid = f.rid and f.aid = a.aid and
						dest_airport = 'Honolulu' 
					  group by 
						a.type) 
		  group by 
			ar.type) 
order by 
	f.flightNo;

--*****************************************************************









REM : Question No : 9

REM : Display the pilot(s) who are certified exclusively to pilot all aircraft in a type
--*****************************************************************


select distinct c.eid,a.type,count(*) 
from 
	certified c,aircraft a
where 
	c.aid = a.aid and
	c.eid in(select ca.eid 
		 from 
			Certified ca,aircraft aa 
		 where 
			(ca.aid = aa.aid)
		 having 
			count(distinct aa.type) = 1 
		 group by 
			ca.eid) 
group by 
	c.eid,a.type
having 
	count(*) = (select count(ar.aid) from aircraft ar where ar.type = a.type);


--*****************************************************************


REM : Question No : 10

REM : Name of an employee who is earning the maximum salary
among the airport having maximum number of departures.



--*****************************************************************

select distinct e.ename,e.salary 
from 
	employee e,certified c,flights f,fl_schedule fl
where 
	e.eid = c.eid and c.aid = f.aid and f.flightNo = fl.flno and
	e.salary = (select distinct max(e.salary) 
		    from 
		    	employee e,certified c,flights f,fl_schedule fl
		    where
			e.eid = c.eid and c.aid = f.aid and f.flightNo = fl.flno
		    having 
			(count(flno) = (select max(count(flno)) 
					from 
						fl_schedule 
					group by 
						flno
					)
		   	) 
		    group by 
			flno
		    );


--*****************************************************************


REM : Question 11

REM : Display the departure chart as follows:
REM : flight number,departure(date,airport,time),destination airport,arrival time,aircraft name
REM : for the flights from NewYork airport during 15 to 19th APril 2005. Make sure that
REM : the route contains atleast two flights in the above specified condition.

--*****************************************************************

select f.flightNo,fl.departs,r.orig_airport,fl.dtime,r.dest_airport,fl.atime,a.aname 
from 
	aircraft a,flights f,routes r,fl_schedule fl
where 
	a.aid = f.aid and f.rid = r.routeid and f.flightNo = fl.flno and
	r.orig_airport = 'New York' and 
	fl.departs between '15-APR-05' and '19-APR-05' and 
	(select count(f.flightNo) 
	 from 
		aircraft a,flights f,routes r,fl_schedule fl
	 where 
		a.aid = f.aid and f.rid = r.routeid and f.flightNo = fl.flno and
		r.orig_airport = 'New York' and 
		fl.departs between '15-APR-05' and '19-APR-05') >= 2;

--*****************************************************************

REM : Question 12

REM : A customer wants to travel from Madison to New York with no more than two changes of flight.
REM : List the flight numbers from Madison if the customer wants to arrive in New York by 6.50 p.m.

--*****************************************************************

(select distinct f.flightNo 
from 
	routes r,flights f,fl_schedule fl
where 
	r.routeid = f.rid and f.flightNo = fl.flno and
	r.orig_airport = 'Madison' and 
	r.dest_airport = 'New York' and 
	fl.atime <=1850
)
union
(select distinct f.flightNo 
from 
	routes r,flights f,fl_schedule fl,routes rm,flights fm,fl_schedule flm
where 
	r.routeid = f.rid and f.flightNo = fl.flno and rm.routeid = fm.rid and fm.flightNo = flm.flno and r.dest_airport = rm.orig_airport and
	r.orig_airport = 'Madison' and 
	rm.dest_airport = 'New York' and 
	fl.atime <= flm.dtime and 
	flm.atime <=1850)
union
(select distinct f.flightNo 
from 
	routes r,flights f,fl_schedule fl,routes rm,flights fm,fl_schedule flm,routes rm1,flights fm1,fl_schedule flm1
where 
	r.routeid = f.rid and f.flightNo = fl.flno and rm.routeid = fm.rid and fm.flightNo = flm.flno and r.dest_airport = rm.orig_airport and rm1.routeid = fm1.rid 
	and fm1.flightNo = flm1.flno and rm.dest_airport = rm1.orig_airport and
	r.orig_airport = 'Madison' and 
	rm.dest_airport = 'New York' and 
	(fl.atime<=flm.dtime and flm.atime<=flm1.dtime) and 
	flm1.atime <=1850);
)


--*****************************************************************


REM : Question 13

REM : Display the id and name of employee(s) who are not pilots.


--*****************************************************************


select e.eid,e.ename from employee e
where e.eid in
(select e1.eid from employee e1
minus
select c.eid from certified c);


--*****************************************************************





REM : Question 14

REM : Display the id and name of pilot(s) who pilot the aircrafts from
REM : Los Angels and Detroit airport.

--*****************************************************************


select distinct e.eid,e.ename 
from 
	employee e,certified c,flights f,aircraft a,routes r
where 
	e.eid=c.eid and c.aid = f.aid and f.aid = a.aid and r.routeID=f.rID and r.orig_airport='Los Angeles'
intersect
select distinct e.eid,e.ename 
from 
	employee e,certified c,flights f,aircraft a,routes r
where 
	e.eid=c.eid and c.aid = f.aid and f.aid = a.aid and r.routeID=f.rID and r.orig_airport='Detroit';

--*****************************************************************
