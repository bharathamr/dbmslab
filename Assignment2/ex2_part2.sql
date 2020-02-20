REM : 11

REM : Displaying only first name,job id and salary from the table;

	select first_name,job_id,salary from employees;





REM : 12

REM : Displaying id, name(first & last), salary and annual salary of all the employees and ordering using first name...

select employee_id,concat(first_name, last_name) as full_name,salary as monthly_sal,salary*12 as Annual_salary
from employees order by first_name;






REM : 13


REM : List the different jobs for which the employees working for...

select distinct job_id from employees;




REM : 14

REM : Displaying the details of employees who are earning commissions...

select employee_id,first_name,job_id,salary,commission_pct from employees where commission_pct is not NULL;




REM : 15

REM : Displaying the details of employees who are managers...

select distinct employee_id as id, first_name,job_id,salary,department_id as dept_id
 from employees
 where job_id like '%MAN' or job_id like '%MGR';


 
REM : 16

REM : Displaying who are hired after '01-may-1999' or salary atleast 10000;

select employee_id,first_name,hire_date,job_id,salary,department_id from employees 
where job_id!='SA_REP' and (hire_date>'01-May-1999' or salary>=10000);




REM : 17

REM : Displaying the employees who's having salary between 5000 and 15000 and his/her name 
REM : starts with (A,J,K,S) and order by first name...

select first_name,salary,hire_date,department_id from employees 
where upper(substr(first_name,1,1)) in ('A','J','K','S') and 
salary between 5000 and 15000 order by first_name;




REM : 18 


REM : Displaying the experience months and years of employees who are hired after 1998...

select employee_id as "EMPLOYEE_ID",first_name as "FIRST NAME",last_name as "LAST NAME",hire_date as "HIRE_DATE",
(extract(year from current_date)-extract(year from hire_date)) as "EXP_YEAR",
((extract(year from current_date)-extract(year from hire_date))*12+(extract(month from current_date)-extract(month from hire_date))) as "EXP MONTHS" from employees
where extract(year from hire_date)>1998;




REM : 19


REM : Displaying the total number of departments...

select count(distinct department_id) as Total from employees;



REM : 20

REM : extracting count of employees hired in  year wise...

select extract(year from hire_date),count(employee_id) from employees group by extract(year from hire_date)
order by extract(year from hire_date);




REM : 21

REM : Dispalying min_salary,max_salary,avg_salary of employees excluding who are not in department and
REM : checking atleast 2 employees and salary > 10000 
REM : order by minimum salary in descending order....

select department_id,min(salary) as min_salary,max(salary) as max_salary,avg(salary) as avg_salary,
count(department_id) as no_employees from employees 
where department_id is not null having count(department_id) >=2 and avg(salary) >10000 
group by department_id order by min(salary) desc;
