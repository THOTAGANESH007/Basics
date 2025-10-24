
-- create a database
create database practice;

-- display the databases 
show databases;

-- use the database
use practice;

-- create a table
create table matches(
id int auto_increment,
name varchar(30) not null,
team varchar(30),
primary key(id)
);

-- key constraints
-- unique => Every record should be unique(can be null (only 1 null value can be inserted) #not true)
-- not null => The record to be inserted should not be null
-- default => To provide a default value
-- auto_increment
-- primary key
-- foreign key => foreign key value_of_the_key references parent_table(primary key) #mostly preferred


-- describe a table structure
desc matches;
show columns from matches;

-- insert the values into the table
insert into matches(name,team) values("Pat","Aus");
insert into matches(name,team) values("MSD","Ind");
insert into matches(name,team) values("Rohit","Ind");
insert into matches(name,team) values("Lara","WI");
insert into matches(name,team) values("Viv","WI");
insert into matches(name,team) values("Ponting","Aus");


insert into matches(name,team) 
values
("Rahul","Ind"),
("Watson","Aus");

-- retrive the values from the table
select * from matches;
select * from matches where team="Aus";


create table checking(
id int primary key auto_increment,
name varchar(30) unique not null,
email varchar(30) unique not null,
phone int unique
);
drop table checking;

desc checking;

insert into checking (name, email, phone) values("N1","a@g.com",9992);

insert into checking (name, email, phone)values("N2","a@g.com",9992);

select * from checking;

-- DataTypes
--	1)Numeric
--		--tinyint
--		--smallint
--		--mediumint
--		--int
--		--bigint
--		--float
--		--double
--		--decimal(total_digits, decimal_places

--	2)String
--		--char(n)
--		--varchar(n)
--		--tinytext
--		--mediumtext
--		--longtext
--		--binary
--		--varbinary
--		--blob

--	3)Date & Time
--		--date
--		--datetime
--		--timestamp
--		--time
		
--	Comparision Operators

--	=,!= (<>), <, <=, >, >=
--	between (range is inclusive)
--	in (is used inplace for the "OR" to optimize the length of the query)
--	is null , is not null => used to check the objects 
--	like(pattern matching) %a=>ends with, a%=> starts with, %a%=>contains substring, a___=>exact length
--	like operator is case insensitive

create table student(
id int auto_increment primary key,
name varchar(30),
email varchar(30),
age int,
marks int
); 


insert into student (name,email,age,marks) values
("Rahul", "rahul@gmail.com", 20, 99),
("Pardeep", "pardeep@gmail.com", 25, 69),
("Bharath", "bharath@gmail.com", 23, 79),
("Maninder", "maninder@gmail.com", 20, 73);

select name,marks
from student
where marks>80;


select * from student
where name like '%r%';

select * from student where marks between 60 and 90;

select * from student where marks in(69,99);

select * from student where marks not in(69,99);


--	String Functions

select concat("Hello", "World");

select concat_ws("$","Hello", "World");

select length("Hello"); -- Returns the number of bytes required to store

select char_length("Hello"); -- Returns the length of the string

select substring("Hello",1,3); -- Parameters (string,start,length) or (string,start)

select left("Hello",3); -- Parameters (string,length from the left)

select right("Hello",3); -- Parameters (string,length from the right)

select upper("Hello"); -- converts to the uppercase

select lower("Hello"); -- converts to the lowercase

select trim("    Namaste "); -- removes the trailing and leading white spaces

select ltrim("   Namaste    "); -- removes the leading white spaces

select rtrim("  Namaste   "); -- removes the trailing white spaces

select replace("Hello","H","7"); -- Parameters (old, find, new)

select instr("Hello World Hyderabad", "H"); -- Returns the first occurence of the string

select locate("H","Hello World H", 7); -- Returns the index position of the string from that start index

select ascii("A");

select cast(char(65) as char);

select reverse("OG");


--	Altering

create table altering(
	id int primary key auto_increment,
    name varchar(30) unique,
    age int 
);

insert into altering(name, age) values
("Starc",30),
("Carey",35),
("Shami",32);


-- To add a column
alter table altering
add column score int;

-- To delete a column
alter table altering
drop score;

-- To change the datatype of the column
alter table altering
modify column score varchar(30);

-- To rename the column
alter table altering
change scores scores int; 

-- To rename the table
alter table altering
rename to alters;

-- To add the constraint to the column
alter table alters
modify scores int unique;

alter table alters
modify name varchar(30) not null;

-- To drop the unique constraint
alter table alters
drop index scores;

-- To drop the primary key constraint
alter table alters
drop primary key;

-- To drop the foreign key
alter table alters
drop foreign key fk_name;

select * from alters;

update alters
set age = "28"
where name="Starc";

delete from alters
where name="Starc";


--	Aggregate Functions

select count(*) as students_count from student;

select max(marks) max from student;

select min(marks) min from student;

select avg(marks) avg from student;

select sum(marks) sum from student;


create table department(
	empId int auto_increment,
    eName varchar(30),
    deptName varchar(30),
    marks int,
    primary key(empId)
);

drop table department;

insert into department(eName, deptName,marks) values
("E1", "IT",80),
("E2", "CS",80),
("E3", "EC",77),
("E4", "IT",89),
("E5", "CS",90),
("E6", "EC",99);

select * from department;

select deptName,avg(marks) as total from department group by deptName;

alter table department
add column logged_in date;

select logged_in from department;

update department
set logged_in = "2025-10-23";

-- year(), month(), day(), curdate(), now()
select year(logged_in) from department;

-- time(), datetime(),
select date_add(curdate(),interval 7 day);
select current_user();
select datediff("2025-11-20", curdate());

-- views

create view avg_marks as select deptName,avg(marks) as total from department group by deptName;

create or replace view avg_marks as select * from department;

select * from avg_marks;

show full tables;

drop view avg_marks;


select * from department;
select distinct(deptName), sum(marks) over(partition by deptName)as marks_sum from department;

select eName,deptName from department group by deptName order by eName,deptName;

select  deptName,dense_rank() over(order by deptName) as ranking from department group by deptName;

--	row_number() doesnot give the same values for the tied columns
--	The problem with the rank() is it skips the tied values
--	dense_rank() solves this issue


select distinct eName, lead(marks) over() from department;  -- Returns the next value

select distinct eName, lag(marks) over() from department;  -- Returns the previous value

select distinct eName,deptName, first_value(marks) over(partition by deptName) from department;  -- Returns the first value

select distinct eName, last_value(marks) over(partition by deptName) from department;  -- Returns the last value


with avg_marks as(
	select avg(marks) as avg__marks from department
)
select eName, deptName from department where marks > (select avg__marks from avg_marks);

select * from avg_marks;

















