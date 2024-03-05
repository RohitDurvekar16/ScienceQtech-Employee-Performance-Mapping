-- 1. Create a database named employee, then import datCa_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.
create database employee;
Imported tables using Table Data Import Wizard in mysql

-- 2. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.

select Emp_id as 'EMP ID'
      ,First_name as 'First Name'
      ,last_name as 'Last Name'
      ,Gender
      ,Dept as Department
from emp_record_table; 

-- 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
      ● less than two
      ●	greater than four 
      ●	between two and four

select Emp_id as 'EMP ID'
      ,First_name as 'First Name'
      ,last_name as 'Last Name'
      ,Gender
      ,Dept as Department
      ,Emp_rating as 'EMP Rating'
      ,case 
          when Emp_rating < 2
              then  "less than two"
          when Emp_rating > 4
	      then "Greater than four"
          Else
	      "Between two and four"
      end as 'EMP Rating'
from emp_record_table;   

-- 4. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.

select * from emp_record_table;
select concat(first_name," ",last_name) as 'Name'
       ,dept as Department
from emp_record_table
where dept = "FINANCE"; 

-- 5. Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

select m.emp_id 
      ,m.first_name as 'Manager Name'
      ,e.first_name
      ,count(*) over (partition by m.first_name) as 'count'
from emp_record_table m join emp_record_table e    
on e.manager_id = m.emp_id
order by m.emp_id; 

-- 6. Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

select * from emp_record_table where dept = "FINANCE"
union all     
select * from emp_record_table where dept = "HEALTHCARE";  

-- 7. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept.
      Also include the respective employee rating along with the max emp rating for the department.

select Emp_id as 'EMP ID'
       ,First_name as 'First Name'
       ,last_name as 'Last Name'
       ,Gender
       ,Dept as Department
       ,Emp_rating as 'EMP Rating'
       ,max(emp_rating) over (partition by dept) as 'Rating'
from emp_record_table
order by dept,emp_rating desc;  

-- 8. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

select emp_id as 'ID'
      ,first_name as 'Name'
      ,ROLE
      ,Salary
      ,max(salary) over (partition by role ) as 'Max Salary'
      ,min(salary) over (partition by role ) as 'Min Salary'
from emp_record_table;  

-- 9. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

select emp_id as 'EMPID'
      ,concat(first_name," ",last_name) as 'NAME'
      ,Exp As EXPERINCE
      ,dense_rank() over (order by Exp desc) as RANKS
from emp_record_table;   

-- 10. Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
      Take data from the employee record table.

create view  Employees as
select concat(first_name," ",last_name) as 'NAME'
      ,country
      ,salary
from emp_record_table
where salary > 6000
order by salary desc;

-- 11. Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

select * from emp_record_table
where emp_id in( select emp_id from emp_record_table where exp>10);

-- 12. Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
      Take data from the employee record table.

-- Procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `Emp_yrs_Exp`()
BEGIN
     select * from emp_record_table where exp > 3;
END
-- Query
Call Emp_yrs_Exp;

-- 13. Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
       The standard being:
       For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
       For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
       For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
       For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
       For an employee with the experience of 12 to 16 years assign 'MANAGER'.

-- Function 
CREATE DEFINER=`root`@`localhost` FUNCTION `Status_Function`(eid varchar(4)) RETURNS varchar(100) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
     declare ex int;
     declare st varchar(100);
     select exp into ex from project.data_science_team where emp_id = eid;
     if ex > 12 then 
          set st = 'MANAGER';
     elseif ex > 10 then 
          set st = 'LEAD DATA SCIENTIST';
     elseif ex > 5 then 
          set st = 'SENIOR DATA SCIENTIST';
     elseif ex > 2 then 
          set st = 'ASSOCIATE DATA SCIENTIST';
     else    
		set st = 'JUNIOR DATA SCIENTIST';
     end if;     
RETURN  st;
END
-- Query
select emp_id 
      ,first_name
      ,exp
      ,status_function(emp_id) as 'New role'
from employee.data_science_team;   

14. Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

-- Created Index on first_name column of emp_record_table to optimize performance
select * from emp_record_table where first_name = "Eric";

15. Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

select emp_id as 'EMP ID'
      ,first_name  as 'FIRST NAME'
      ,role AS 'ROLE'
      ,dept as DEPARTMENT
      ,salary as SALARY
      ,(salary * 0.05) * emp_rating as BONUS
from emp_record_table;      

16. Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

select  Emp_id as 'EMP ID'
       ,concat(First_name," ", last_name) as 'Name'
       ,Dept as Department
       ,continent as 'Continent'
       ,country as Country
       ,avg(salary) over (partition by continent) as 'Average Salary by Continent'
       ,avg(salary) over (partition by country) as 'Average Salary by Country'
from emp_record_table
order by continent;      
      








