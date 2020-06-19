/*
Find the average salary of the male and female employees in each department.
*/
USE employees_mod;

SELECT 
    d.dept_name AS Department_Name,
    CASE
        WHEN e.gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS Gender,
    ROUND(AVG(s.salary), 2) AS Average_Salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY Gender , d.dept_name
ORDER BY d.dept_name; 


/*
Find the lowest department number encountered in the 'dept_emp' table. Then, find the highest
department number.
*/

SELECT 
    COUNT(de.dept_no) AS Appearance,
    d.dept_name AS Department_Name
FROM
    t_dept_emp de
        JOIN
    t_departments d ON de.dept_no = d.dept_no
GROUP BY de.dept_no
ORDER BY Appearance DESC;

/*
Obtain a table containing the following three fields for all individuals whose employee number is not
greater than 10040:
- employee number
- the lowest department number among the departments where the employee has worked in (Hint: use
a subquery to retrieve this value from the 'dept_emp' table)
- assign '110022' as 'manager' to all individuals whose employee number is lower than or equal to 10020,
and '110039' to those whose number is between 10021 and 10040 inclusive.
Use a CASE statement to create the third field.
If you've worked correctly, you should obtain an output containing 40 rows
*/

SELECT 
    e.emp_no,
    (SELECT 
            MIN(dept_no)
        FROM
			t_dept_emp de,
			t_employees e
        WHERE
            e.emp_no = de.emp_no) AS Lowest,
    CASE
        WHEN emp_no <= 10021 THEN 110022
        ELSE 110039
    END AS Manager
FROM
    t_employees e
WHERE
    emp_no <= 10040
ORDER BY emp_no;
    
