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
delete Duplicating where Numbering>1;

--find employees hired in last n years
Create table Employees
( ID int primary key identity,
     [Name] varchar(max),
     Gender varchar(10),
     Salary int,
     HireDate Date);
insert into employees ([Name], Gender,Salary, HireDate)
select [Name], Gender,Salary, HiredDate from WholeData;
--update Employees set HireDate = DATEADD(year,round(rand()*2,0),HireDate);
select * from Employees where datediff(year,hiredate ,getdate())<=2;

--how transform rows into columns in sql server
select City, [Sindh], [Punjab],[KPK],[Balochistan] from
(select Province, City, COUNT(City) as Citing from WholeData group by Province, City ) as Merged
pivot(
max(citing)
for Province in ([Sindh], [Punjab],[KPK],[Balochistan])
) as Transformed;

-- select all names that start with a given letter without like operator
Create table findLetters(  
	 ID int,
     [Name] varchar(50),
     Gender varchar(50),
     Salary int); 
insert into findLetters( ID,name,gender, Salary) select ID, [Name] ,Gender, Salary from WholeData;

select * from findLetters where [Name] like 'M%';
--or
select * from findLetters where SUBSTRING(name,1,1) = 'M';
--or
select * from findLetters where left(name,1) = 'M';
--or
select * from findLetters where CHARINDEX('M', name)=1;