use student;

select round(avg(salaries.salary))
from employees
join dept_manager on dept_manager.emp_no = employees.emp_no
join salaries on salaries.emp_no = employees.emp_no
where dept_manager.dept_no = 'd009';