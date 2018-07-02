# insert table
DROP TABLE teams;
CREATE TABLE teams (
    team_id int,
    team_name varchar(255)
);

INSERT INTO teams (team_id, team_name) VALUES (10, 'Give');
INSERT INTO teams (team_id, team_name) VALUES (20, 'Never');
INSERT INTO teams (team_id, team_name) VALUES (30, 'You');
INSERT INTO teams (team_id, team_name) VALUES (40, 'Up');
INSERT INTO teams (team_id, team_name) VALUES (50, 'Gonna');

SELECT * FROM teams

Drop table employee
  create table employee (
      emp_id integer not null,
      emp_name varchar(50) not null,
      dept_id integer not null,
      salary integer not null,
      unique(emp_id)
  );
insert into employee values(1, 'Jojo', 20, 5000);
insert into employee values(2, 'Popat Lal', 30, 15000);
insert into employee values(3, 'Santa Singh', 40, 25000);
insert into employee values(4, 'Banta Singh', 20, 7500);
insert into employee values(5, 'Sohan Lal', 20, 15000);
insert into employee values(6, 'Kk', 10, 12000);
insert into employee values(7, 'Bob', 20, 35000);
insert into employee values(8, 'John', 30, 25000);
insert into employee values(9, 'Smith', 40, 5000);

# grab
SELECT a.event_type, (a.value - b.value) AS value FROM
events a
JOIN
events b
ON
a.event_type = b.event_type
WHERE
a.time IN (SELECT time FROM events t1 WHERE
           t1.event_type=a.event_type ORDER BY time DESC LIMIT 1 OFFSET 0)
AND
b.time IN (SELECT time FROM events t2 WHERE
           t2.event_type=b.event_type ORDER BY time DESC LIMIT 1 OFFSET 1)


#
select 
t.Request_at Day, 
round(sum(case when t.Status like 'cancelled_%' then 1 else 0 end)/count(*),2) Rate
from Trips t 
inner join Users u 
on t.Client_Id = u.Users_Id and u.Banned='No'
where t.Request_at between '2013-10-01' and '2013-10-03'
group by t.Request_at

# 177
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT;
SET M = N-1;
  RETURN (
SELECT distinct salary as getNthHighestSalary
from Employee
order by salary desc
limit M, 1
  );
END

#178
select score, dense_rank() over (order by Score desc) as Rank
from Scores

SELECT
  Score,
  (SELECT count(distinct Score) FROM Scores WHERE Score >= s.Score) Rank
FROM Scores s
ORDER BY Score desc

# 179
Select DISTINCT l1.Num ConsecutiveNums
from Logs l1, Logs l2, Logs l3 
where l1.Id=l2.Id-1 and l2.Id=l3.Id-1 
and l1.Num=l2.Num and l2.Num=l3.Num

#184
SELECT t.Department, e2.Name as Employee, t.Salary
from Employee e2
join
(SELECT d.Id, d.Name Department, MAX(salary) Salary
from Department d
join Employee e
on d.Id = e.DepartmentId
group by d.Name) t
on e2.Salary = t.Salary
and e2.DepartmentId = t.Id

#570
SELECT e.Name
from Employee e, (
SELECT ManagerID, count(*)
FROM Employee
WHERE ManagerId != 'null'
GROUP BY ManagerId
Having count(*) >= 5) t
WHERE t.ManagerId = e.Id

#574
select c.Name
from Candidate c
join
(SELECT CandidateId, count(*)
FROM Vote
group by CandidateId
order by count(*) desc
limit 1) t
on c.Id = t.CandidateId

#578
select question_id as survey_log
from survey_log
group by question_id
order by sum(case action when 'answer' then 1 else 0 end)/count(*) desc 
limit 1

#579
select E1.id, E1.month, (ifnull(E1.salary,0) +ifnull(E2.salary,0) + ifnull(E3.salary,0)) as Salary  from 
(Select id,max(month) as month from Employee group by id having count(*) > 1) as maxmonth
left Join Employee E1 on (maxmonth.id = E1.id and maxmonth.month > E1.month)
left Join Employee E2 on (E1.id = E2.id and E1.month = E2.month + 1)
left Join Employee E3 on (E1.id = E3.id and E1.month = E3.month + 2)
Order by id ASC, month DESC

#580
SELECT a.dept_name, ifnull(count(student_id),0) as student_number
from
(SELECT d.dept_id, d.dept_name, s.student_id
from department d
left join student s
on d.dept_id = s.dept_id) as a
group by a.dept_name
order by student_number desc, a.dept_name

#602
select r.requester_id, r.re+a.ac as num
from
(select requester_id , count(*) as re
from request_accepted 
group by requester_id ) as r
join
(select accepter_id , count(*) as ac
from request_accepted 
group by accepter_id ) as a
on r.requester_id = a.accepter_id
order by num desc
limit 1

select id, count(*) num from 
(
      (select requester_id id from request_accepted) 
      union all 
      (select accepter_id id from request_accepted)
) tb 
group by id order by num desc limit 1

# 196. Delete Duplicate Emails
delete p1
from Person p1, Person p2
where p1.Email = p2.Email
and p1.Id > p2.Id

# 197. Rising Temperature
SELECT t1.Id
FROM Weather t1
INNER JOIN Weather t2
ON TO_DAYS(t1.RecordDate) = TO_DAYS(t2.RecordDate) + 1
WHERE t1.Temperature > t2.Temperature

# 577. Employee Bonus
select e.name, b.bonus
from Employee e
left join Bonus b
on e.empId = b.empID
where b.bonus < 2000 or b.bonus is null

# 584. Find Customer Referee
select name 
from customer
where referee_id != '2' or referee_id is null

# 586. Customer Placing the Largest Number of Orders
select customer_number from orders
group by customer_number
order by count(*) desc limit 1;

# 596. Classes More Than 5 Students
select class
from courses
group by class
having count(distinct student) >= 5

# 597. Friend Requests I: Overall Acceptance Rate
select ifnull(round((select count(distinct requester_id, accepter_id)
from request_accepted)/(select count(distinct sender_id, send_to_id)
from friend_request), 2),0) as accept_rate

# 619. Biggest Single Number
select(
  select num
  from number
  group by num
  having count(*) = 1
  order by num desc limit 1
) as num;

# How to return NULL when result is empty?
select (Your entire current Select statement goes here) as Alias from dual
or
select (Your entire current Select statement goes here) as Alias

# 603. Consecutive Available Seats
select c.seat_id
from cinema c
where c.free = 1
and (
    c.seat_id+1 IN (select seat_id from cinema where free=1)
    or
    c.seat_id-1 IN (select seat_id from cinema where free=1)
)
order by c.seat_id

# 610. Triangle Judgement
select x, y, z,
IF(x+y>z and x+z>y and y+z>x, 'Yes', 'No') as triangle
from triangle

# 614. Second Degree Follower
select distinct f1.follower, f2.num
from follow f1
join (select followee, count(distinct follower) as num
     from follow
     group by followee) f2
on f1.follower = f2.followee
order by f1.follower
