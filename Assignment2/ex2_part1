REM : dropping classes table before creating....

drop table classes;


REM : creating table classes...

create table classes(class varchar2(20) constraint prim primary key,
		     type varchar2(2) constraint check1 check(type in('bb', 'bc')),
		     country varchar2(15),
		     numGuns number(1),
		     bore number(2),
		     displacement number(5));


REM : inserting first two tuples into classes by explicitly mentioning their column names...

	insert into classes(class,type,country,numguns,bore,displacement) values('Bismark','bb','Germany',8,14,32000);
	insert into classes(class,type,country,numguns,bore,displacement) values('Iowa','bb','USA',9,16,46000);

REM : Displaying classes table...

	select * from classes;

REM : inserting remaining tuples without entering column names...

	insert into classes values('Kongo','bc','Japan',8,15,42000);
	insert into classes values('NorthCarolina','bb','USA',9,16,37000);
	insert into classes values('Revenge','bb','Gt.Britain',8,15,29000);
	insert into classes values('Renown','bb','Gt.Britian',6,15,32000);

REM : Displaying classes table...

	select * from classes;

REM : creating an intermediate point for the transaction to roll to point to discard the recent deletions...


	savepoint step_1;
	delete from classes;
	select * from classes;
	rollback to step_1;
	select * from classes;

REM : Updating Bismark displacement to 34000...

	update classes set Displacement = 34000 where class = 'Bismark';
	select * from classes;

	
REM : Incrementing salary for those who have atleast 9 guns or atleast 15 bore...
	update classes set displacement = displacement + (displacement * 0.1) where numguns >= 9 or bore>= 15;
	select * from classes;

REM : Deleting Kongo class from the classes table...

	delete from classes where class = 'Kongo';
	select * from classes;

REM : Displaying my overall changes to the table...

	select * from classes;

REM : Discarding the changes without discarding the earlier changes...

	rollback to step_1;
	select * from classes;

REM : Commiting the table to make the changes permanent by stopping you to roll back...
	
	commit;
	rollback to step_1;



