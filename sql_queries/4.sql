use student;

select sum(salaries.salary)
from employees
join salaries on salaries.emp_no = employees.emp_no
join dept_manager on dept_manager.emp_no = employees.emp_no
join departments on departments.dept_no = dept_manager.dept_no
WHERE departments.dept_name = 'Research';