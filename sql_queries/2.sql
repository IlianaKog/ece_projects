use student;

select min(salaries.salary)
from employees
join salaries on salaries.emp_no = employees.emp_no
where employees.emp_no > 110000;