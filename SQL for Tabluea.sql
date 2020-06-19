USE employees_mod;
/*
Create a visualization that provides a breakdown between the male and female employees working in the company each year, starting from 1990. 
*/
SELECT 
    YEAR(de.from_date) AS Calender,
    CASE
        WHEN e.gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS Gender,
    COUNT(de.from_date) AS Number_of_Employee
FROM
    t_dept_emp de
        JOIN
    t_employees e ON de.emp_no = e.emp_no
GROUP BY Calender,Gender
HAVING Calender >= 1990 order by Calender;

/*
Task 2
Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.
*/


SELECT 
    dp.dept_name,
    CASE
        WHEN e.gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS Gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    ea.calender,
    CASE
        WHEN
            YEAR(dm.to_date) >= ea.calender
                AND YEAR(dm.from_date) <= ea.calender
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calender
    FROM
        t_employees
    GROUP BY calender) ea
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments dp ON dm.dept_no = dp.dept_no
        JOIN
    t_employees e ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no , calender;

/*
SELECT 
	dep.dept_name,
	CASE 
		WHEN e.gender = 'M' THEN 'Male'
		ELSE 'Female'
    END AS Gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    ea.calender,
	CASE 
		WHEN YEAR(dm.to_date) >= ea.calender AND YEAR(dm.from_date) <= ea.calender THEN 1 
        ELSE 0 
	END AS Active_Manager
FROM 
	(SELECT 
		YEAR(hire_date) As calender
        FROM
			t_employees
		GROUP BY calender) ea 
        CROSS JOIN
			t_dept_manager dm
        JOIN
			t_departments dep ON dm.dept_no = dep.dept_no 
		JOIN
			t_employees e ON dm.emp_no = e.emp_no
		ORDER BY dm.emp_no, calender;
        
*/



/*
Task 3
Compare the average salary of female versus male employees in the entire
company until year 2002, and add a filter allowing you to see that per each department

*/

SELECT 
    YEAR(s.from_date) AS calender,
    CASE
        WHEN e.gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS Gender,
    dp.dept_name,
    ROUND(AVG(s.salary),2) AS Average_Salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
        JOIN
    t_departments dp ON de.dept_no = dp.dept_no
GROUP BY dp.dept_no , Gender , calender
HAVING calender <= 2002
ORDER BY dp.dept_no, calender;

/*
Create an SQL stored procedure that will allow you to obtain the average male and
 female salary per department within a certain salary range. Let this range be defined
 by two values the user can insert when calling the procedure.

Finally, visualize the obtained result-set in Tableau as a double bar chart. 
*/
DELIMITER $$
CREATE PROCEDURE salary_per_dept(IN Salary_Range_1 FLOAT, IN Salary_Range_2 FLOAT) 

BEGIN
SELECT 
    e.gender,
    ROUND(AVG(s.salary), 2) AS Average_Salary,
	d.dept_name
FROM
    t_employees e
        JOIN
    t_salaries s ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = s.emp_no
        JOIN
    t_departments d ON de.dept_no = d.dept_no
WHERE s.salary BETWEEN Salary_Range_1 AND Salary_Range_2
group by  e.gender,d.dept_name 
 order by d.dept_name;
END$$

DELIMITER ;

CALL salary_per_dept(50000,90000);
