-- ============================================================
-- EMPLOYEE ATTRITION DATABASE
-- BUSINESS QUESTIONS (SQL LAYER)
-- ============================================================


-- ============================================================
-- Q1: What is the overall attrition rate?
-- ============================================================

SELECT
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS attrition_rate_percent
FROM employees;


-- ============================================================
-- Q2: Which departments lose the most employees?
-- ============================================================

SELECT
    d.department_name,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        100.0 * SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS attrition_rate_percent
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY attrition_rate_percent DESC;


-- ============================================================
-- Q3: Which job roles lose the most employees?
-- ============================================================

SELECT
    jr.job_role_name,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        100.0 * SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS attrition_rate_percent
FROM employees e
JOIN job_roles jr ON jr.job_role_id = e.job_role_id
GROUP BY jr.job_role_name
ORDER BY attrition_rate_percent DESC;


-- ============================================================
-- Q4: Does working overtime increase attrition?
-- ============================================================

SELECT
    aw.overtime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        100.0 * SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS attrition_rate_percent
FROM employees e
JOIN attendance_workload aw ON aw.employee_id = e.employee_id
GROUP BY aw.overtime;


-- ============================================================
-- Q5: Do employees who leave earn less than those who stay?
-- ============================================================

SELECT
    e.attrition,
    ROUND(AVG(sc.monthly_income), 0) AS avg_monthly_income,
    COUNT(*) AS employee_count
FROM employees e
JOIN salary_compensation sc ON sc.employee_id = e.employee_id
GROUP BY e.attrition;


-- ============================================================
-- Q6: Are employees who leave less satisfied at work?
-- ============================================================

SELECT
    e.attrition,
    ROUND(AVG(p.job_satisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(p.work_life_balance), 2) AS avg_work_life_balance
FROM employees e
JOIN performance p ON p.employee_id = e.employee_id
GROUP BY e.attrition;


-- ============================================================
-- Q7: Does marital status relate to attrition?
-- ============================================================

SELECT
    e.marital_status,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        100.0 * SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS attrition_rate_percent
FROM employees e
GROUP BY e.marital_status
ORDER BY attrition_rate_percent DESC;


-- ============================================================
-- Q8: Does income level relate to attrition?
-- (split income into 4 simple brackets instead of a window
--  function, since we're still SQL level 1)
-- ============================================================

SELECT
    CASE
        WHEN sc.monthly_income < 3000  THEN '1 - under 3000'
        WHEN sc.monthly_income < 6000  THEN '2 - 3000 to 5999'
        WHEN sc.monthly_income < 10000 THEN '3 - 6000 to 9999'
        ELSE '4 - 10000 and above'
    END AS income_bracket,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        100.0 * SUM(CASE WHEN e.attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS attrition_rate_percent
FROM employees e
JOIN salary_compensation sc ON sc.employee_id = e.employee_id
GROUP BY income_bracket
ORDER BY income_bracket;


-- ============================================================
-- Q9: Who is at risk right now? (no model needed -- a simple
-- rule-based filter: no stock options + works overtime)
-- ============================================================

SELECT
    e.employee_id,
    jr.job_role_name,
    d.department_name,
    sc.monthly_income,
    aw.overtime,
    sc.stock_option_level
FROM employees e
JOIN job_roles jr ON jr.job_role_id = e.job_role_id
JOIN departments d ON d.department_id = e.department_id
JOIN salary_compensation sc ON sc.employee_id = e.employee_id
JOIN attendance_workload aw ON aw.employee_id = e.employee_id
WHERE sc.stock_option_level = 0
  AND aw.overtime = 'Yes'
  AND e.attrition = 'No'
ORDER BY sc.monthly_income ASC;


-- ============================================================
-- Q10: How big and how senior (tenure-wise) is each department?
-- ============================================================

SELECT
    d.department_name,
    COUNT(*) AS headcount,
    ROUND(AVG(e.years_at_company), 1) AS avg_years_at_company
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY headcount DESC;


-- ============================================================
-- END OF BUSINESS QUESTIONS
-- ============================================================