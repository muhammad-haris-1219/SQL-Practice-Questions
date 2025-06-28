CREATE database Question;
use Question;  
create table WholeData(
ID int not null,
HiredDate datetime,
[Name] varchar(max),
Email nvarchar(max),
Gender varchar(10),
Age int,
Department varchar(max),
Salary decimal(10,2),
Dept_ID int,
Province varchar(max),
City varchar(max),
DOB date,
Expertise varchar(max)
);  
bulk insert WholeData from 'D:\SQL\Practice\Question-Answers\WholeData.csv'
with(
fieldterminator=',', rowterminator='\n', firstrow=2
); 

--How to find nth highest salary in sql
create table highSalary( 
[name] nvarchar(max),
gender varchar(max),
Salary int
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

--find department with highest number of employees
Create Table Departments(
     DepartmentID int not null,
     DepartmentName varchar(50)
);
insert into Departments (DepartmentID, DepartmentName) select Dept_ID, Department from WholeData;
with duplication as(
select*, ROW_NUMBER() over(partition by DepartmentID order by DepartmentID) as duplicating from Departments
) delete from duplication where duplicating>1;
alter table departments add constraint PK_DepartmentID primary key(DepartmentID ) ;

Create Table Employee(
     EmployeeID int not null,
     EmployeeName nvarchar(50)
);
alter table Employee add departmentID int, 
foreign key (DepartmentID) references Departments(DepartmentID);
insert into Employee (EmployeeID,EmployeeName,DepartmentID) select ID,[Name],dept_ID from WholeData;
with duplication as(
select*, ROW_NUMBER() over(partition by employeeid order by employeeid  ) as duplicating from Employee
) delete from duplication where duplicating>1;
select top 1 DepartmentName, COUNT(*) as TotalEmployee from Employee join Departments on
Employee.DepartmentID=Departments.DepartmentID group by DepartmentName order by COUNT(*) desc;

--Date questions 
create table employeeDOB(
[Name] varchar(50),
[Date of Birth] date
);
insert into employeeDOB ([Name],[Date of Birth]) select [Name], DOB from WholeData;
drop table employeeDOB; 
--Write a SQL query to retrieve all people who are born on a given date (For example, 7th Nov 2001)
select * from employeeDOB where cast([Date of Birth] as date)='2001-07-11';
--Write a SQL query to retrieve all people who are born between 2 given dates 
select * from employeeDOB where cast([Date of Birth] as date) between '1995-12-08' and '2001-07-11';
--Write a SQL query to retrieve all people who are born on the same day and month excluding the year 
select * from employeeDOB where day([Date of Birth])=12 and MONTH([Date of Birth])=2;
--Write a SQL query to get all people who are born in a given year (Example, all people born in the year 2002)
select * from employeeDOB  where year([Date of Birth])=2002;
--Write a SQL query to retrieve all people who are born yesterday
select * from employeeDOB  where year([date of birth]) =year(dateadd(year,-1,'2005'));

--Find Yearly & Monthly Sales In Table Format 
create table monthlySales(
Products varchar(max),
[Date] Date,
Price int,
Quantity int
);
bulk insert monthlySales from 'D:\SQL\Practice\Question-Answers\monthlySales.csv'
with(
fieldterminator =',', rowterminator ='0x0a', firstrow=2
);
select Months, ISNULL([2015], 0) AS [2015], ISNULL([2016], 0) AS [2016], ISNULL([2017], 0) AS [2017], 
ISNULL([2018], 0) AS [2018], ISNULL([2019], 0) AS [2019], ISNULL([2020], 0) AS [2020], 
ISNULL([2021], 0) AS [2021], ISNULL([2022], 0) AS [2022], ISNULL([2023], 0) AS [2023], 
ISNULL([2024], 0) AS [2024], ISNULL([2025], 0) AS [2025] from
(select datename(year,[Date]) as Years, datename(MONTH,[Date]) as Months, sum(Price*Quantity) as Sales 
from monthlySales group by datename(year,[Date]), datename(MONTH,[Date])) as Total
pivot(
max(sales)
for Years in ([2015], [2016],[2017],[2018],[2019],[2020],[2021],[2022],[2023],[2024],[2025])
) as Summary;

--Write SQL Query To Find Candidates For A Particular Job 
with Skills as
(select ID from WholeData where Expertise in ('Excel','Power BI')
group by ID having COUNT(*)=2)
select WholeData.ID, Expertise, Gender, Email from Skills join WholeData 
on WholeData.ID=Skills.ID
where WholeData.Expertise in ( 'Power BI', 'Excel') ;

--write query alternative top 10 records
select top 10 * from WholeData where ID % 2=1; -- if ID sorted/arranged a/c to whole Num. series
--or
select top 10 * from WholeData where ID % 2<>0;

-- if ID not sorted/arranged or randomized 
With alternativeRecords as(
select *, row_number() over(order by id) as Numbering from WholeData
)
select * from alternativeRecords where Numbering % 2=1;
--or
select * from
(select *, row_number() over(order by id) as Numbering from WholeData) as Numbered 
where Numbering % 2=1;

--write query for max & min salaries & also counts a/c to department
select ID, max(salary) as MaxSalary from WholeData
group by id order by max(salary) desc;
select ID, min(Salary) as MinSalary from WholeData
group by ID order by min(Salary) asc ;
select Department, COUNT(*) as Employees from WholeData
group by Department order by COUNT(*) desc;

--How inserting one table data into another table without munual creating table
select * into Tabled from WholeData;
--how inserting one table structure into another table(without creating)
select * into Tabled from WholeData where 0 <> 0;

--retrive 1st, last record & also last 3 records
with Record as(
select *,ROW_NUMBER() over(order by id) as [Sr.#] from WholeData
)
select top 3 * from Record order by id desc;
--or
select  top 1 * from WholeData order by ID;
select  top 1 * from WholeData order by ID desc;
select  distinct top 3  * from WholeData where ID in
(select distinct top 3 ID from WholeData order by ID desc
) ; -- if ID has duplication then (distinct top)

--retrive all records which  are repeated name & email
select [Name],Email, COUNT(*) as Counts from WholeData 
group by [Name],Email 
having COUNT(*)>=2;

--display all records a/c to quarterly
select DATEPART(quarter, HiredDate ) As Quarters,*  from WholeData
where year(HiredDate)= 2018 order by Quarters;

--Custom Sorting In SQL also Order By Month In A Year 
select DATENAME(month,[date]) as [MonthName],
price from monthlySales order by month([date]) asc;
--or
select  DATENAME(month,[date]) as [MonthName], Price
from monthlySales order by case
when  DATENAME(month,[date]) = 'January' then 1
when  DATENAME(month,[date]) = 'February' then 2
when  DATENAME(month,[date]) = 'March' then 3
when  DATENAME(month,[date]) = 'April' then 4
when  DATENAME(month,[date]) = 'May' then 5
when  DATENAME(month,[date]) = 'June' then 6
when  DATENAME(month,[date]) = 'July' then 7
when  DATENAME(month,[date]) = 'August' then 8
when  DATENAME(month,[date]) = 'September' then 9
when  DATENAME(month,[date]) = 'October' then 10
when  DATENAME(month,[date]) = 'November' then 11
when  DATENAME(month,[date]) = 'December' then 12
else null end;

--To extract Number / Text from given Dataset
create function extractNumber(@string as nvarchar(max))
returns nvarchar(max) as
begin
declare @indexed int = patindex('%[^0-9]%' , @string);
while @indexed>0 
begin
set @string = STUFF(@string,@indexed,1,'');
set @indexed= patindex('%[^0-9]%' , @string);
end;
return @string;
end;

create function exceptNumber(@string as nvarchar(max))
returns nvarchar(max) as
begin
declare @indexed int = patindex('%[0-9]%' , @string);
while @indexed>0 
begin
set @string = STUFF(@string,@indexed,1,'');
set @indexed= patindex('%[0-9]%' , @string);
end;
return @string;
end;
select dbo.extractNumber('ff123g#@g') as [Number], dbo.exceptNumber('ff123g#@g') as [String];
select dbo.extractNumber(CONCAT(Email,ID,gender,Salary)) as [Number] ,
dbo.exceptNumber(CONCAT(Email,ID,gender,Salary)) as [Number] from WholeData;
