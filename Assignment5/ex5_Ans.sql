
--1
--Check whether the given pizza type is available. If not display appropriate message

--Corresponding Table
select * from pizza;

declare
pizza_name varchar2(10);
id pizza.pizza_id%type;
cursor c1 is select pizza_id from pizza where pizza_type=pizza_name;
begin
pizza_name:='&pizza_name';
open c1;
fetch c1 into id;
if(c1%FOUND) then
dbms_output.put_line(pizza_name || ' is available');
else
dbms_output.put_line(pizza_name || ' is not available');
end if;
close c1;
end;
/

/

--2:
--For the given customer name and a range of order date, find whether a customer had
--placed any order, if so display the number of orders placed by the customer along 
--with the order number.

--Corresponing table for 2
select * from orders o,customer c where o.cust_id = c.cust_id;

declare
customer_name varchar2(20);
range_date1 date;
range_date2 date;
id customer.cust_id%type;
flag int;
cursor c1 is select * from orders;
cursor c2 is select cust_id from customer where cust_name = customer_name;
begin
	customer_name := '&name';
	range_date1 := '&date1';
	range_date2 := '&date2';
	flag := 0;
	open c2;
	fetch c2 into id;
	if(c2%found) then
	dbms_output.put_line('Customer Name = '|| customer_name);
	dbms_output.put_line('Orders : ');
	for cur in c1 loop
		if(cur.cust_id = id and cur.order_date >= range_date1 and cur.order_date <=range_date2 ) then
			dbms_output.put_line(cur.order_no);
			flag:=flag+1;
		end if;
	end loop;
	if (flag =0) then
	dbms_output.put_line('No Orders');
	else
	dbms_output.put_line('Total Order = '|| flag);
	end if;
	else
	dbms_output.put_line('Customer Not Available');
	end if;
	close c2;
	end;
/

/


--3:
--Display the customer name along with the details of pizza type and its quantity 
--ordered for the given order number.

--Corresponding Table for 3
select c.cust_id,os.order_no,p.pizza_type,o.qty from order_list o,pizza p,orders os,customer c 
where c.cust_id = os.cust_id and os.order_no = o.order_no and o.pizza_id = p.pizza_id;


declare
oid varchar2(5);
total int;
customer_name customer.cust_name%type;
customer_id customer.cust_id%type;
cursor c1 is select c.cust_name from customer c,orders o where c.cust_id=o.cust_id and order_no = oid; 
cursor c2 is select o.order_no,p.pizza_type,o.qty from order_list o,pizza p where o.pizza_id = p.pizza_id;
begin
	total :=0;
	oid := '&oid';
	open c1;
	fetch c1 into customer_name;
	if(c1%found) then
	dbms_output.put_line('Customer name : '||customer_name);
	dbms_output.put_line('Ordered Following Pizza');
	dbms_output.put_line('PIZZA TYPE	QTY');
	for cur in c2 loop
		if(cur.order_no = oid and cur.qty is not null) then
			dbms_output.put_line(cur.pizza_type||'		'||cur.qty);
			total:=total+cur.qty;
		end if;
	end loop;
	dbms_output.put_line('------------------------------');
	dbms_output.put_line('Total Qty : '||total);
	else
	dbms_output.put_line('Order id Not Available');
	end if;
	close c1;
	end;
/

/

--4 :
--Display the total number of orders that contains one pizza type, two pizza type and 
--so on.

--Corresponding table for 4
select order_no,count(order_no) as count from order_list group by order_no;

declare
one int;
two int;
three int;
four int;
cursor c3 is select order_no,count(order_no) as count from order_list group by order_no;
begin
 one:=0;
 two:=0;
 three:=0;
 four:=0;
 for cur in c3 loop
  if(cur.count = 1) then
   one := one+1;
  elsif(cur.count = 2) then
   two := two+1;
  elsif(cur.count = 3) then
   three := three+1;
  elsif(cur.count = 4) then
   four := four+1;
  end if;
 end loop;
 dbms_output.put_line('Number Of Orders That Contains ');
 dbms_output.put_line('Only ONE Pizza type '||one);
 dbms_output.put_line('Two Pizza type  '||two);
 dbms_output.put_line('Three Pizza type  '||three);
 dbms_output.put_line('ALL Pizza type  '||four);
 end;
/

	
	
		


	
	
