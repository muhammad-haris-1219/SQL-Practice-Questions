CREATE database Question;
use Question; 
create table WholeData(
ID int not null,
[Date] datetime,
[Name] varchar(max),
Email nvarchar(max),
Gender varchar(10),
Age int,
Department varchar(max),
salary decimal(10,2),
Dept_ID int
);
bulk insert WholeData from 'D:\SQL\Practice\Question-Answers\Data.csv'
with(
fieldterminator=',', rowterminator='\n', firstrow=2
);

--How to find nth highest salary in sql
create table highSalary( 
[name] nvarchar(max),
gender varchar(max),
salary int
);
insert into highSalary ([name], gender, salary)
select [Name], Gender, Salary from wholeData;
select * from highSalary;
with highing as(
select *, DENSE_RANK() over(order by salary desc) as ranking from highSalary
)
select * from highing where ranking <=2 order by salary desc;
--or
select top 1 * from
(select distinct top 2 * from  highSalary order by salary desc) as Topped  order by salary asc;
--or
select min(salary) as nth from highSalary where  salary in
(select distinct top 2 salary from  highSalary  order by salary desc ) 

--how to delete all duplicate rows except one from a sql server table
Create table  Duplication(
id int not null,
salary decimal(10,2),
gender varchar(255)
); 
insert into Duplication (id,salary,gender)
select id,salary,gender from  WholeData;
truncate table duplicate;
with Duplicating as(
select *, ROW_NUMBER() over(partition by id order by id) as Numbering from Duplication
)
select * from Duplicating where Numbering<2;