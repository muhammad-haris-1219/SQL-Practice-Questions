CREATE database Question;
use Question;

--How to find nth highest salary in sql
create table CTEBased(
[name] nvarchar(max),
gender varchar(max),
age decimal(6,3),
salary int
);
insert into  CTEBased values('ABC','male',23,8000 );
insert into  CTEBased values('XUV','female',45,98000 );
insert into  CTEBased values('XYZ','male',29,87000 );
insert into  CTEBased values('MNO','male',18,38000 );
insert into  CTEBased values('IJK','female',31,58000 );
insert into  CTEBased values('MPO','female',28,38000 );
insert into  CTEBased values('IoK','male',31,58000 );
select * from CTEBased;

with CTE as
(
select *, DENSE_RANK() over(order by salary desc) as ranking from CTEBased
)
select * from CTE where ranking<=2 order by ranking desc;
--or
select  distinct top 2  * from
(select distinct top 4 *from CTEBased order by  salary desc) as subquery order by salary asc;
--or
select  min(salary) as nth from CTEbased  where salary in
(select distinct top 4 salary from CTEBased order by salary desc) ;

--how to delete all duplicate rows except one from a sql server table
Create table  duplicate(
id int not null,
salary decimal(10,2),
gender varchar(255)
);
insert into  duplicate values(1,6000, 'male');
insert into  duplicate values(5,6090, 'female');
insert into  duplicate values(1,56000, 'male')
insert into  duplicate values(1,26000, 'male');
insert into  duplicate values(2,6000, 'female');
insert into  duplicate  values(2,76000, 'male');
insert into  duplicate values(4,6000, 'female');
insert into  duplicate values(3,6080, 'male');
insert into  duplicate values(4,9000, 'male');
insert into  duplicate values(5,3000, 'male');
truncate table duplicate;
select * from duplicate;
with duplicating  as 
( 
select *, ROW_NUMBER() over(partition by id order by id) as duplicated from duplicate
)
delete from duplicating where duplicated>1;


--find employees hired in last n years
Create table Employees
(
     ID int primary key identity,
     FirstName nvarchar(50),
     LastName nvarchar(50),
     Gender nvarchar(50),
     Salary int,
     HireDate DateTime
)
Insert into Employees values('Mark','Hastings','Male',60000,'5/10/2014')
Insert into Employees values('Steve','Pound','Male',45000,'4/20/2014')
Insert into Employees values('Ben','Hoskins','Male',70000,'4/5/2014')
Insert into Employees values('Philip','Hastings','Male',45000,'3/11/2014')
Insert into Employees values('Mary','Lambeth','Female',30000,'3/10/2014')
Insert into Employees values('Valarie','Vikings','Female',35000,'2/9/2014')
Insert into Employees values('John','Stanmore','Male',80000,'2/22/2014')
Insert into Employees values('Able','Edward','Male',5000,'1/22/2014')
Insert into Employees values('Emma','Nan','Female',5000,'1/14/2014')
Insert into Employees values('Jd','Nosin','Male',6000,'1/10/2013')
Insert into Employees values('Todd','Heir','Male',7000,'2/14/2013')
Insert into Employees values('San','Hughes','Male',7000,'3/15/2013')
Insert into Employees values('Nico','Night','Male',6500,'4/19/2013')
Insert into Employees values('Martin','Jany','Male',5500,'5/23/2013')
Insert into Employees values('Mathew','Mann','Male',4500,'6/23/2013')
Insert into Employees values('Baker','Barn','Male',3500,'7/23/2013')
Insert into Employees values('Mosin','Barn','Male',8500,'8/21/2013')
Insert into Employees values('Rachel','Aril','Female',6500,'9/14/2013')
Insert into Employees values('Pameela','Son','Female',4500,'10/14/2013')
Insert into Employees values('Thomas','Cook','Male',3500,'11/14/2013')
Insert into Employees values('Malik','Md','Male',6500,'12/14/2013')
Insert into Employees values('Josh','Anderson','Male',4900,'5/1/2014')
Insert into Employees values('Geek','Ging','Male',2600,'4/1/2014')
Insert into Employees values('Sony','Sony','Male',2900,'4/30/2014')
Insert into Employees values('Aziz','Sk','Male',3800,'3/1/2014')
Insert into Employees values('Amit','Naru','Male',3100,'3/31/2014')
update Employees set HireDate = DATEADD(year,round(rand()*2,0),HireDate);
select * from Employees where datediff(year,hiredate ,getdate())<=2;

--how transform rows into columns in sql server
Create Table Countries
(
 Country nvarchar(50),
 City nvarchar(50)
)
Insert into Countries values ('USA','New York')
Insert into Countries values ('USA','Houston')
Insert into Countries values ('USA','Dallas')
Insert into Countries values ('India','Hyderabad')
Insert into Countries values ('India','Bangalore')
Insert into Countries values ('India','New Delhi')
Insert into Countries values ('UK','London')
Insert into Countries values ('UK','Birmingham')
Insert into Countries values ('UK','Manchester')
select Country, [City 1],[City 2],[City 3] from
(select *, 'City '+ cast(row_number() over(partition by country order by country) as varchar) as citing from Countries) as citites
pivot (
max(city)
for citing in ([city 1],[city 2],[city 3])
) as transformingData;
select * from Countries;

--find department with highest number of employees
Create Table Departments
(
     DepartmentID int primary key,
     DepartmentName nvarchar(50)
)
Create Table Employee
(
     EmployeeID int primary key,
     EmployeeName nvarchar(50),
     DepartmentID int foreign key references Departments(DepartmentID)
)
Insert into Departments values (1, 'IT')
Insert into Departments values (2, 'HR')
Insert into Departments values (3, 'Payroll')
Insert into Employee values (1, 'Mark', 1)
Insert into Employee values (2, 'John', 1)
Insert into Employee values (3, 'Mike', 1)
Insert into Employee values (4, 'Mary', 2)
Insert into Employee values (5, 'Stacy', 3)
select top 1 DepartmentName, count(*) as Total from Departments join Employee 
on Departments.DepartmentID =  Employee.DepartmentID 
group by DepartmentName order by count(*) desc;

--Real time example for right join
Create Table Depart
(
     DepartmentID int primary key,
     DepartmentName nvarchar(50)
)
Create Table Emp
(
     EmployeeID int primary key,
     EmployeeName nvarchar(50),
     DepartmentID int foreign key references Departments(DepartmentID)
)
Insert into Depart values (1, 'IT')
Insert into Depart values (2, 'HR')
Insert into Depart values (3, 'Payroll')
Insert into Depart values (4, 'Admin')
Insert into Emp values (1, 'Mark', 1)
Insert into Emp values (2, 'John', 1)
Insert into Emp values (3, 'Mike', 1)
Insert into Emp values (4, 'Mary', 2)
Insert into Emp values (5, 'Stacy', 2)

select DepartmentName, count( emp.DepartmentID) as Total  from emp   right  Join depart
on depart.DepartmentID=emp.DepartmentID group by DepartmentName order by total asc ;

-- find rows that contain only numerical data
Create Table TestTable
(
     ID int identity primary key,
     Value nvarchar(50)
)
Insert into TestTable values ('123')
Insert into TestTable values ('ABC')
Insert into TestTable values ('DEF')
Insert into TestTable values ('901')
Insert into TestTable values ('JKL')
select * from TestTable where ISNUMERIC([value])=1;
-- select all names that start with a given letter without like operator
Create table Students
(
     ID int primary key identity,
     Name nvarchar(50),
     Gender nvarchar(50),
     Salary int
)
Insert into Students values ('Mark', 'Male', 60000)
Insert into Students values ('Steve', 'Male', 45000)
Insert into Students values ('James', 'Male', 70000)
Insert into Students values ('Mike', 'Male', 45000)
Insert into Students values ('Mary', 'Female', 30000)
Insert into Students values ('Valarie', 'Female', 35000)
Insert into Students values ('Johm', 'Male', 80000)

select * from Students where [Name] like 'M%';
select * from Students where  substring([name], 1,1)='M';
select * from Students where  left([name], 1)='M';
select * from Students where  charindex('M', [name])=1;

--Date interview questions 
Create Table Employees
(ID int identity primary key,
       Name nvarchar(50),
       DateOfBirth DateTime)
Insert Into Employees Values ('Tom', '2018-11-19 10:36:46.520')
Insert Into Employees Values ('Sara', '2018-11-18 11:36:26.400')
Insert Into Employees Values ('Bob', '2017-12-22 10:40:10.300')
Insert Into Employees Values ('Alex', '2017-12-30 9:30:20.100')
Insert Into Employees Values ('Charlie', '2017-11-25 7:25:14.700')
Insert Into Employees Values ('David', '2017-10-09 8:26:14.800')
Insert Into Employees Values ('Elsa', '2017-10-09 9:40:18.900')
Insert Into Employees Values ('George', '2018-11-15 10:35:17.600')
Insert Into Employees Values ('Mike', '2018-11-16 9:14:17.600')
Insert Into Employees Values ('Nancy', '2018-11-17 11:16:18.600')
select  * from Employees;
update Employees set  DateOfBirth =DATEADD(year, ROUND(rand()*2,0), DateOfBirth) ;

--Write a SQL query to retrieve all people who are born on a given date (For example, 9th October 2023)
select * from Employees where cast(dateOFBirth as date) ='2023-10-09';
--Write a SQL query to retrieve all people who are born between 2 given dates 
select * from Employees where cast(dateOFBirth as date) between '2023-11-01' AND '2023-12-31';
--Write a SQL query to retrieve all people who are born on the same day and month excluding the year 
select * from Employees  where day(dateofbirth)=9 and MONTH(dateofbirth)= 10;
--Write a SQL query to get all people who are born in a given year (Example, all people born in the year 2017)
select * from Employees  where year(dateofbirth)=2023;
--Write a SQL query to retrieve all people who are born yesterday
select * from Employees where convert(date, dateofbirth) =  DATEADD(day,-1,convert(date, getdate())) ;

--How to delete parent child rows
Create table Department
(Id int primary key identity,
       [Name] nvarchar(50)
	   )
	   Insert into Department values ('IT')
Insert into Department values ('HR')
	
Create table Employ
( Id int primary key identity,
       [Name] nvarchar(50),
       DeptId int foreign key references Department(Id)
	   on delete cascade  on update cascade)
	   Insert into Employ values ('Mark', 1)
Insert into Employ values ('Mary', 1)
Insert into Employ values ('John', 2)
Insert into Employ values ('Sara', 2)
Insert into Employ values ('Steve', 2)
	   delete from Employ where DeptId=1;

--How getting  number from string by  function
Create table TestTable
(IDName nvarchar(50))
Insert into TestTable values('Nir10ma0la1')
Insert into TestTable values('1A0ru0na2')
Insert into TestTable values('S1h00ashi3')
Insert into TestTable values('N100aga4raj')
Insert into TestTable values('Sruj100a5n')
Insert into TestTable values('Sr1u0s0h6ti')
Insert into TestTable values('Ha1n0u0man7th')
Insert into TestTable values('Sh10iva08mma')
Insert into TestTable values('10Sonu09')
Insert into TestTable values('Nim10m1u0')
Insert into TestTable values('N*m10m1u0')
drop table TestTable;
select * from TestTable;
drop function ExtractionAlphabets;
create function ExtractionNumbers(@alpha varchar(max))
returns varchar(max)
as begin
declare @num int  =patindex('%[^0-9]%',@alpha);
while @num>0 begin
set @alpha = STUFF(@alpha,@num,1,'');
set @num =patindex('%[^0-9]%',@alpha);
end
return @alpha;
end;
create function ExtractionAlphabets(@integer varchar(max))
returns varchar(max)
as begin
declare @num int  =patindex('%[0-9]%',@integer);
while @num>0 begin
set @integer = STUFF(@integer,@num,1,'');
set @num =patindex('%[0-9]%',@integer);
end
return @integer;
end;
select Idname,dbo.ExtractionAlphabets(Idname) as Aphabets, dbo.ExtractionNumbers(Idname) as Numbers  from TestTable;

--Find Monthly Sales In Descending Order also yearly
drop table Product_Sales_Table;
create table Product_Sales_Table
(
id int primary key identity,
p_name varchar(50) not null,
price_of_1 int not null,
order_date date not null,
sales int not null
);
insert into Product_Sales_Table values 
('Mouse',500,'2023/01/05',25),
('Hardisk',1500,'2024/01/06',14),
('SSD',2000,'2023/02/08',16),
('Keyboard',700,'2023/02/09',13),
('Airpods',2500,'2023/03/11',19),
('USB',800,'2024/03/12',26),
('Handfree',400,'2023/04/18',14),
('Monitor',1500,'2023/04/19',8),
('Microphone',1800,'2023/05/14',28),
('Graphic Card',4500,'2022/05/15',11);
select [Month],ISNULL([2022], 0) as [2022] ,isnull([2023],0) as [2023],isnull([2024],0) as [2024] from
(select year(order_date) as [Year], DATENAME(month, order_date) as [Month], sum(price_of_1* sales) as Total
from Product_Sales_Table group by year(order_date), DATENAME(month, order_date)  ) as a 
pivot(
sum(Total)
for [Year] in ([2022],[2023],[2024])
) as pivoting  order by [Month] desc;

--Write SQL Query To Find Candidates For A Particular Job 
create table Candidates
(
candidate_id int,
skills varchar(100)
);
insert into Candidates values
(1001,'Python'),
(1001,'MySQL'),
(1008,'JavaScript'),
(1008,'ASP.NET'),
(1008,'SQL'),
(1003,'PHP'),
(1004,'React'),
(1004,'JavaScript'),
(1002,'ASP.NET'),
(1002,'SQL'),
(1002,'JavaScript'),
(1006,'Power BI'),
(1006,'Python'),
(1009,'Vue JS'),
(1009,'JavaScript'),
(1009,'PHP'),
(1007,'MongoDB'),
(1005,'SQL'),
(1005,'JavaScript'),
(1005,'ASP.NET');
select candidate_id ,COUNT(skills) from Candidates 
where skills in ('JavaScript','SQL','ASP.NET') group by candidate_id
having COUNT(skills)>=3;
--or
select candidate_id, Skill_Sets from 
(select candidate_id, COUNT(skills) as Skill_Sets from Candidates 
where skills in ('JavaScript','SQL','ASP.NET') group by candidate_id) as skill_Counts
where Skill_Sets  >=3;

create table [Table](
ID int primary key,
[Date] date ,
[Name] varchar(max),
Email nvarchar(max),
Gender varchar(max),
Salary decimal(10,3),
Depart_ID int
);
bulk insert dbo.[Table] from 'C:\Users\dell\Desktop\sql file.csv'
with(
fieldterminator =',', rowterminator='0x0a',firstRow = 2
);

--write query alternative top 10 records
select top 10 * from [table] where ID %2=1;
--write query for max & min salaries & also counts a/c to department
select Depart_ID, max(Salary) as Salary from [table]
group by Depart_ID  order by Salary desc; 
select Depart_ID, min(salary) as Salary from [table]
group by Depart_ID  order by Salary desc; 
select Depart_ID, count(*) as Counts from [table]
group by Depart_ID order by Counts desc; 

--inserting one table data into another table(without creating)
select * into tabled from [Table];  
--inserting one table structure into another table(without creating)
select * into tabledd from [Table] where 0<>0;  

--retrive 1st & last record also last 3 records
select * from [table] where ID in (select max(ID) from [table]);
select * from [table] where ID in (select min(ID) from [table]);
select top 3 * from [table] order by ID desc;

--retrive all records which  are same name & email
select [Name], Email, count(*) as Counts from [Table] group by [Name], Email having count(*)>=2;
 
--display all records a/c to quarterly
select *,DATEPART(QUARTER,[date]) as [Quarter] from [Table] where year([date])=2022;

--Custom Sorting In SQL also Order By Month In A Year 
select 
--MONTH([Date]) as Month_Value,
DATENAME(month,[Date]) as [Month],sum(Salary)
from [table]  group by DATENAME(month,[Date]),MONTH([Date]) order by MONTH([Date]);



