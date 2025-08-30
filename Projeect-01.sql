create database lingesh;
use lingesh;
-- 1.List all employees with a salary greater than 80,000.
select* from employee
where salary > 80000;

-- 2.	Find employees whose first name starts with the letter 'A'.
select*from employee
where first_name like 'A%';

-- 3.	Retrieve all employees hired after 2020.
select*from employee
where hire_date > '2020-12-31';

-- 4.	Show all employees along with their department name.
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employee e
JOIN departments d ON e.department_id = d.department_id;

-- 5.	List all projects with start and end dates in 2023.
SELECT *
FROM projects
WHERE start_date >= '2023-01-01'
  AND end_date <= '2023-12-31';
  
-- 6.List each employee’s full name, department name, and salary.
select 
concat(e.first_name,' ',e.last_name) as full_name, 
d.department_name,
e.salary
from employee e
join departments d on e.department_id=d.department_id;

-- 7.Show all assignments with project names and employee full names.
select 
p.project_name,
concat(e.first_name,' ',e.last_name) as full_name
from assignments a
join employee e on a.employee_id = e.employee_id
join projects p on a.project_id = p.project_id;

-- 8.Find the total hours worked by each employee across all projects.
select
concat(e.first_name,' ',e.last_name) as full_name,
sum(a.hours_worked) as total_hours
from assignments a
join employee e on a.employee_id = e.employee_id
group by e.employee_id,e.first_name, e.last_name;

-- 9.	List all departments along with the count of employees in each.
select
d.department_name,
count(e.employee_id) as employee_count
from departments d
left join employee e on d.department_id = e.department_id
group by d.department_name; 

-- 10.	Show all projects along with the total number of employees assigned to them.
select
p.project_name,
count(e.employee_id) as total_number
from assignments a
JOIN employee e on a.employee_id = e.employee_id
join projects p on a.project_id + p.project_id
group by p.project_name;


-- 11.	What is the average salary per department?
select 
d.department_name,
avg(e.salary) as average_salary
from employee e
join departments d on e.department_id = d.department_id
group by d.department_name;

-- 12.	Find the highest salary in each department.
select
d.department_name,
max(e.salary) as highest_salary
from employee e
join departments d on e.department_id = d.department_id
group by d.department_name;

-- 13.	Count how many employees were hired each year.
select
year(hire_date) as hire_year,
count(*) as employee_count
from employee
group by (hire_date)
order by hire_year;

-- 14.	What is the total number of hours worked by department?
SELECT 
  d.department_name,
  SUM(a.hours_worked) AS total_hours
FROM employee e
JOIN departments d ON e.department_id = d.department_id
JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY d.department_name;

-- 15.	Which employee has worked the most total hours?
SELECT 
  e.employee_id,
  CONCAT(e.first_name, ' ', e.last_name) AS full_name,
  SUM(a.hours_worked) AS total_hours
FROM employee e
JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_hours DESC
LIMIT 1;

-- 16.	Show employee full names in UPPERCASE.
select
upper (concat(first_name,' ',last_name)) as full_name_upper
from employee;
    
-- 17.	Display the length of each project name.
select
project_name,
length (project_name) as name_length
from projects;

-- 18.	Round the salary of all employees to the nearest thousand.
select 
employee_id,
first_name,
last_name,
salary,
round(salary, -3) as round_salary
from employee;

-- 19.	Find employees with salaries between 50,000 and 60,000.
select
employee_id,
first_name,
last_name,
salary
from employee
where salary between 50000 and 60000;

-- 20.	Extract the year from the hire_date column.
select
employee_id,
hire_date,
year(hire_date) as hire_year
from employee;

-- 21.	Calculate how long each employee has been with the company (in years).
select
employee_id,
first_name,
last_name,
TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_with_company
from employee;

-- 22.	Find projects that ended before they started (data errors).
SELECT 
  project_id,
  project_name,
  start_date,
  end_date
FROM projects
WHERE end_date < start_date;

-- 23.	Show the difference in days between start and end date of each project.
select
project_id,
project_name,
start_date,
end_date,
datediff(end_date,start_date) as  duration_days
from projects;

-- 24.	Find employees hired in the month of January.
select 
employee_id,
first_name,
last_name,
hire_date
from employee
where month(hire_date) =1;

-- 25.	List projects that lasted more than 180 days.
select
project_name,
project_id,
start_date,
end_date,
datediff(end_date,start_date) as duration_days
from projects
where datediff(end_date,start_date) >180;

-- 26.	Find employees who earn more than the average salary.
select
employee.
first_name,
last_name,
salary
from employee
where salary >(
select avg(salary) from employee
);

-- 27.	List departments that have more than 5 employees.
SELECT 
  d.department_id,
  d.department_name,
  COUNT(e.employee_id) AS employee_count
FROM departments d
JOIN employee e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) > 5;

-- 28.	Retrieve employees who have never been assigned to any project.
SELECT 
  e.employee_id,
  e.first_name,
  e.last_name
FROM employee e
LEFT JOIN assignments a ON e.employee_id = a.employee_id
WHERE a.project_id IS NULL;

-- 29.	Show the names of projects that have more than 5 unique employees.
SELECT 
  p.project_name,
  COUNT(DISTINCT a.employee_id) AS unique_employee_count
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_name
HAVING COUNT(DISTINCT a.employee_id) > 5;

-- 30.	Find employees working on the most number of projects.
WITH project_counts AS (
  SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    COUNT(DISTINCT a.project_id) AS project_count
  FROM employee e
  LEFT JOIN assignments a ON e.employee_id = a.employee_id
  GROUP BY e.employee_id, e.first_name, e.last_name
)
SELECT 
  employee_id,
  full_name,
  project_count
FROM project_counts
WHERE project_count = (
  SELECT MAX(project_count) FROM project_counts
);

-- 31.	Rank employees by salary within each department.
select
employee_id,
first_name,
last_name,
department_id,
salary,
rank() over(partition by department_id order by salary desc) as salary_rank
from employee;

-- 32.	Show running total of hours worked by each employee (ordered by project).
SELECT
  a.employee_id,
  e.first_name,
  e.last_name,
  a.project_id,
  p.project_name,
  a.hours_worked,
  SUM(a.hours_worked) OVER (
    PARTITION BY a.employee_id
    ORDER BY a.project_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total_hours
FROM assignments a
JOIN employee e ON a.employee_id = e.employee_id
JOIN projects p ON a.project_id = p.project_id
ORDER BY a.employee_id, a.project_id;

-- 33.	Show each project and the percentage of total hours contributed by each employee.
SELECT
  p.project_id,
  p.project_name,
  a.employee_id,
  e.first_name,
  e.last_name,
  a.hours_worked,
  ROUND(
    (a.hours_worked * 100.0) / SUM(a.hours_worked) OVER (PARTITION BY a.project_id),
    2
  ) AS percent_of_project_hours
FROM assignments a
JOIN projects p ON a.project_id = p.project_id
JOIN employee e ON a.employee_id = e.employee_id
ORDER BY p.project_id, percent_of_project_hours DESC;

-- 34.	Get the top 3 highest-paid employees in each department.
SELECT
  employee_id,
  first_name,
  last_name,
  department_id,
  salary,
  ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employee
WHERE 'salary_rank' <= 3;

-- 35.	Find the most recent hire per department.
WITH RankedHires AS (
  SELECT
    employee_id,
    first_name,
    last_name,
    department_id,
    hire_date,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date DESC) AS rn
  FROM employee
)
SELECT
  employee_id,
  first_name,
  last_name,
  department_id,
  hire_date
FROM RankedHires
WHERE rn = 1;

-- 36.	Show average, min, and max hours worked on each project.
SELECT
  p.project_id,
  p.project_name,
  AVG(a.hours_worked) AS average_hours,
  MIN(a.hours_worked) AS min_hours,
  MAX(a.hours_worked) AS max_hours
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name;

-- 37.	For each employee, list the number of departments they’ve worked under (via projects).
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(DISTINCT p.department_id) AS department_count
FROM employee e
JOIN assignments a ON e.employee_id = a.employee_id
JOIN projects p ON a.project_id = p.project_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY department_count DESC;

-- 38.	Identify any employee assigned to multiple departments via projects.
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(DISTINCT p.department_id) AS department_count
FROM employee e
JOIN assignments a ON e.employee_id = a.employee_id
JOIN projects p ON a.project_id = p.project_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(DISTINCT p.department_id) > 1;

-- 39.	List the top 5 employees by average hours per project.
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  AVG(a.hours_worked) AS avg_hours_per_project
FROM employee e
JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY avg_hours_per_project DESC
LIMIT 5;

-- 40.	Find projects with no assigned employees.
SELECT
p.project_id,
p.project_name
FROM projects p
LEFT JOIN assignments a ON p.project_id = a.project_id
WHERE a.employee_id IS NULL;

-- 41.	Use a CTE to get all employees who’ve worked more than 100 hours in total.
with totalhours as(
select
employee_id,
sum(hours_worked) as total_hours
from assignments
group by employee_id
)
select
e.employee_id,
e.first_name,
e.last_name,
th.total_hours
from employee e
join totalhours th on e.employee_id = th.employee_id
where th.total_hours >100;

-- 42.	Use a CASE statement to classify employees: 'High Salary' (>100k), 'Mid Salary' (60-100k), 'Low Salary' (<60k).
select
employee_id,
first_name,
last_name,
salary,
case
when salary > 100000 then 'high salary'
when salary between 60000 and 100000 then 'mid salary'
else 'low salary'
end as salary_category
from employee;

-- 43.	Create a report of employees showing their hire year and whether they are ‘Veteran’ (>5 yrs) or ‘New’ (<=5 yrs).
select
employee_id,
first_name,
last_name,
year(hire_date) as hire_year,
case
when datediff ('current_data', 'hire_date') > 5 * 365 then 'veteran'
else 'new'
end as experince_leve
from employee;

-- 44.	Use a CTE to list employees working on more than 2 projects.
WITH ProjectCounts AS (
SELECT
employee_id,
COUNT(DISTINCT project_id) AS project_count
FROM assignments
GROUP BY employee_id
)
SELECT
e.employee_id,
e.first_name,
e.last_name,
pc.project_count
FROM employee e
JOIN ProjectCounts pc ON e.employee_id = pc.employee_id
WHERE pc.project_count > 2;

-- 45.	Show a list of departments and a flag (Y/N) indicating if they manage any project.
SELECT
d.department_id,
d.department_name,
CASE
WHEN COUNT(p.project_id) > 0 THEN 'Y'
ELSE 'N'
END AS manages_project
FROM departments d
LEFT JOIN projects p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;

-- 46.	Count distinct employees working in each project.
SELECT
p.project_id,
p.project_name,
COUNT(DISTINCT a.employee_id) AS employee_count
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name;

-- 47.	Show employees working on projects outside their department.
SELECT
e.employee_id,
e.first_name,
e.last_name,
e.department_id AS employee_department,
p.project_id,
p.project_name,
p.department_id AS project_department
FROM employee e
JOIN assignments a ON e.employee_id = a.employee_id
JOIN projects p ON a.project_id = p.project_id
WHERE e.department_id <> p.department_id;

-- 48.	Find employees who have the same last name.
SELECT *
FROM employee
WHERE last_name IN (
SELECT last_name
FROM employee
GROUP BY last_name
HAVING COUNT(*) > 1
);

-- 49.	List all departments without a manager (if any).
select*from departments
where manager_id is null;

-- 50.	Show all employees sorted by how long they’ve been with the company (most to least).
select
employee_id,
first_name,
last_name,
hire_date,
datediff (current_date,hire_date) as days_with_company
from employee
order by days_with_company desc;
