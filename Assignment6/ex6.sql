--*****************************************************
--UCS1412                               B.Senthil Kumar
--Database Lab				Asst. Prof
--	    		    Computer Science Department
--            		     SSN College of Engineering 
--	                   	     senthil@ssn.edu.in
--*****************************************************
-- 	          PIZZA ORDERING DATASET
--                 Version 1.0
--                February 05, 2015
--*****************************************************
--Sources:
--         This dataset is prepared for the assignment
--	on DML, PL/SQL blocks in Database Programming.
--	This is a test dataset - pizza ordered on 28 & 29th Jun 2015.
--	Do NOT MODIFY the instances.
--
--******************************************************


REm customer(cust_id, cust_name, address, phone)
REM pizza (pizza_id, pizza_type, unit_price)
REM orders(order_no, cust_id, order_date ,delv_date, total_amt)
REM order_list(order_no, pizza_id, qty)

set serveroutput on;
REM ------------------------------------------------------------------------------------------
set echo on;
drop table order_list;
drop table orders;
drop table pizza;
drop table customer;


REM customer(cust_id, cust_name,address,phone)

create table customer(cust_id varchar2(4) constraint id_pk primary key,cust_name varchar2(15),address varchar2(30),phone number(10));

insert into customer values('c001','Hari','32 RING ROAD,ALWARPET',9001200031);
insert into customer values('c002','Ashok','42 bull ROAD,numgambakkam',9444120003);
insert into customer values('c003','Raj','12a RING ROAD,ALWARPET',9840112003);
insert into customer values('c004','Raghu','P.H ROAD,Annanagar',9845712993);
insert into customer values('c005','Sindhu','100 feet ROAD,vadapalani',9840166677);
insert into customer values('c006','Brinda','GST ROAD, TAMBARAM', 9876543210);



REM pizza (pizza_id, pizza_type, unit_price)

create table pizza(pizza_id varchar2(4) constraint pizzaid_pk primary key,pizza_type varchar2(10),unit_price number(3));

insert into pizza values('p001','pan',130);
insert into pizza values('p002','grilled',230);
insert into pizza values('p003','italian',200);
insert into pizza values('p004','spanish',260);
--insert into pizza values('p005','supremo',250);


REM orders(order_no, cust_id, order_date ,delv_date)


create table orders(order_no varchar2(5) constraint order_pk primary key,cust_id varchar2(4) constraint foriegn1 references customer(cust_id),order_date date,delv_date date);

insert into orders values('OP100','c001','28-JUN-2015','30-JUN-2015');
insert into orders values('OP200','c002','28-JUN-2015','30-JUN-2015');
insert into orders values('OP300','c003','29-JUN-2015','01-JUL-2015');
insert into orders values('OP400','c004','29-JUN-2015','01-JUL-2015');
insert into orders values('OP500','c001','29-JUN-2015','01-JUL-2015');
insert into orders values('OP600','c002','29-JUN-2015','01-JUL-2015');



REM order_list(order_no, pizza_id, qty)

create table order_list(order_no varchar2(5) constraint foriegn2 references orders(order_no),pizza_id varchar2(4) constraint foriegn3 references pizza(pizza_id),qty number(2),constraint prim_key primary key(order_no,pizza_id));


insert into order_list values('OP100','p001',3);
insert into order_list values('OP100','p002',2);
insert into order_list values('OP100','p003',1);
insert into order_list values('OP100','p004',5);

insert into order_list values('OP200','p003',2);
insert into order_list values('OP200','p001',6);
insert into order_list values('OP200','p004',8);

insert into order_list values('OP300','p003',3);

insert into order_list values('OP400','p001',3);
insert into order_list values('OP400','p004',1);

insert into order_list values('OP500','p003',6);
insert into order_list values('OP500','p004',5);
insert into order_list values('OP500','p001',null);

insert into order_list values('OP600','p002',3);

alter table orders add(total_amt number(5),discount number(2),bill_amount number);
--******************************************************
spool F:/dbms/ex6/ex6_spool.txt
set echo on;
--1 : 

CREATE OR REPLACE FUNCTION TotalOrder(Order_id IN varchar2) RETURN int IS
total int;
i int;
cursor c1 is select * from order_list where order_no = order_id;
Begin
total := 0;
i:=1;
for cur in c1 loop
	if(cur.qty is not null) then
	total := total + cur.qty;
	end if;
end loop;
RETURN total;
end;
/
REM : Order id input for TotalOrder function..

declare
order_id varchar2(5);
x int;
begin
order_id := '&order_id';
x:=TotalOrder(order_id);
if(x != 0) then
dbms_output.put_line('Order No : '||order_id);
dbms_output.put_line('Total Number Of Pizzas Ordered : '||x);
else
dbms_output.put_line(order_id||' Not Found');
end if;
end;
/
/


	
--2:	

create or replace procedure calculate is
tot number;
dis number;
bill number;
cursor c1 is select * from orders;
cursor c2 is select o.order_no,p.unit_price,o.qty from order_list o,pizza p where o.pizza_id = p.pizza_id;
begin
for cur in c1 loop
   tot :=0;
   for cur1 in c2 loop
           if(cur.order_no = cur1.order_no and cur1.qty is not null) then
                   tot := tot+(cur1.unit_price*cur1.qty);
           end if;
   end loop;
   update orders set total_amt=tot where order_no = cur.order_no;
   if(tot > 2000 and tot < 5000)then
           dis := 5;
   elsif(tot > 5000 and tot < 10000) then
           dis := 10;
   elsif(tot > 10000) then
           dis := 20;
   else
	   dis :=0;
   end if;
   update orders set discount=dis where order_no = cur.order_no;
   bill := tot - tot*(dis/100);
   update orders set bill_amount=bill where order_no = cur.order_no;
end loop;
end;
/

call calculate();
select * from orders;

--3 : 

create or replace procedure bill(oid IN varchar2) is
tot int;
i int;
dis int;
bil number;
c int;
cursor c1 is select o.order_no,c.cust_name,o.order_date,c.phone from orders o,customer c where c.cust_id = o.cust_id;
cursor c2 is select o.order_no,p.pizza_type,o.qty,p.unit_price,o1.discount,o1.bill_amount from order_list o,pizza p,orders o1 where o.pizza_id = p.pizza_id and o.order_no = o1.order_no;
begin
tot :=0;
dis := 0;
bil :=0;
i:=1;
  c:=0;
  for cur in c1 loop
   if(oid = cur.order_no) then
   c := 1;
   dbms_output.put_line('************************************************************');
   dbms_output.put_line('Order Number:'||oid||'  Customer Name:'||cur.cust_name);
   dbms_output.put_line('Order Date:'||cur.order_date||' Phone Number:'||cur.phone);
   dbms_output.put_line('************************************************************');
   end if;
  end loop;
  if(c=1) then
  dbms_output.put_line('SNO  PIZZA TYPE      QTY     PRICE   AMOUNT');
  for cur1 in c2 loop
   if(oid = cur1.order_no and cur1.qty is not null) then
  dbms_output.put_line(i||'  '||cur1.pizza_type||'           '||cur1.qty||'  	'||cur1.unit_price||'   '||cur1.qty*cur1.unit_price);
  i:=i+1;
  tot := tot+(cur1.qty*cur1.unit_price);
  dis := cur1.discount;
  bil := cur1.bill_amount;
   end if;
  end loop;
  dbms_output.put_line('------------------------------------------------------------');
  dbms_output.put_line('             Total = '||TotalOrder(oid)||'                   '||tot);
  dbms_output.put_line('------------------------------------------------------------');
  dbms_output.put_line('Total Amount         :Rs.'||tot);
  dbms_output.put_line('Discount('||dis||'%)         :Rs.'||tot*(dis/100));
  dbms_output.put_line('------------------------------------------------------------');
  dbms_output.put_line('Amount to be paid    :Rs.'||bil);
  dbms_output.put_line('------------------------------------------------------------');
  dbms_output.put_line('Great Offers! Discount up to 25% on Diwali Festival Day...');
  dbms_output.put_line('************************************************************');
  else
     dbms_output.put_line('Not Available');
  end if;
end;
/
REM : Order id input for bill procedure..
declare
order_id varchar2(5);
c int;
begin
order_id := '&order_id';
bill(order_id);
end;
/

/

spool off;
