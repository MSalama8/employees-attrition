-- ============================================================
-- EMPLOYEE ATTRITION DATABASE
-- DATA LOADING
-- ============================================================
-- Purpose:
-- Load the raw CSV into a staging table, then populate the
-- normalized tables (departments, job_roles, employees,
-- salary_compensation, performance, attendance_workload)
-- from it. Run this AFTER schema.sql.
-- ============================================================


-- ============================================================
-- STEP 1: staging table -- same columns as the CSV, no changes
-- ============================================================

CREATE TABLE IF NOT EXISTS employees_raw (

    "Age"                        INT,
    "Attrition"                 VARCHAR(3),
    "BusinessTravel"             VARCHAR(20),
    "DailyRate"                  DECIMAL(10,2),
    "Department"                 VARCHAR(50),
    "DistanceFromHome"           INT,
    "Education"                  INT,
    "EducationField"             VARCHAR(50),
    "EmployeeCount"              INT,
    "EmployeeNumber"             INT,
    "EnvironmentSatisfaction"    INT,
    "Gender"                     VARCHAR(10),
    "HourlyRate"                 DECIMAL(10,2),
    "JobInvolvement"             INT,
    "JobLevel"                   INT,
    "JobRole"                    VARCHAR(50),
    "JobSatisfaction"            INT,
    "MaritalStatus"               VARCHAR(20),
    "MonthlyIncome"              DECIMAL(10,2),
    "MonthlyRate"                DECIMAL(10,2),
    "NumCompaniesWorked"         INT,
    "Over18"                     VARCHAR(3),
    "OverTime"                   VARCHAR(3),
    "PercentSalaryHike"          DECIMAL(5,2),
    "PerformanceRating"          INT,
    "RelationshipSatisfaction"   INT,
    "StandardHours"              INT,
    "StockOptionLevel"           INT,
    "TotalWorkingYears"          INT,
    "TrainingTimesLastYear"      INT,
    "WorkLifeBalance"            INT,
    "YearsAtCompany"             INT,
    "YearsInCurrentRole"         INT,
    "YearsSinceLastPromotion"    INT,
    "YearsWithCurrManager"       INT

);


-- ============================================================
-- STEP 2: load the CSV into the staging table
-- Edit the file path to where the CSV is on YOUR machine.
-- (psql only -- if you're loading from pgAdmin, use its
-- Import/Export tool on employees_raw instead of this line.)
-- ============================================================

COPY employees_raw
FROM '/home/mxp-sal-ma/DATA/PROJECTS/employees-attrition/data/processed/employee_attrition_cleaned.csv'
WITH (FORMAT csv, HEADER true);


-- ============================================================
-- STEP 3: departments (fixed list -- only 3 departments exist)
-- ============================================================

INSERT INTO departments (department_id, department_name) VALUES
    (1, 'Human Resources'),
    (2, 'Research & Development'),
    (3, 'Sales');


-- ============================================================
-- STEP 4: job_roles (fixed list -- 11 role/department pairs)
-- "Manager" exists in all three departments, so it appears
-- three times here, once per department.
-- ============================================================

INSERT INTO job_roles (job_role_id, job_role_name, job_level, department_id) VALUES
    (1,  'Human Resources',         1, 1),
    (2,  'Manager',                 1, 1),
    (3,  'Healthcare Representative', 1, 2),
    (4,  'Laboratory Technician',   1, 2),
    (5,  'Manager',                 1, 2),
    (6,  'Manufacturing Director',  1, 2),
    (7,  'Research Director',       1, 2),
    (8,  'Research Scientist',      1, 2),
    (9,  'Manager',                 1, 3),
    (10, 'Sales Executive',         1, 3),
    (11, 'Sales Representative',    1, 3);

-- job_level here is a placeholder (1). The real job_level per
-- employee is stored in employees.job_level, since it differs
-- from one employee to another even in the same role.


-- ============================================================
-- STEP 5: employees
-- ============================================================

INSERT INTO employees (
    employee_id, age, gender, marital_status, education_level,
    education_field, department_id, job_role_id, job_level,
    years_at_company, years_in_current_role,
    years_since_last_promotion, years_with_current_manager,
    total_working_years, attrition
)
SELECT
    r."EmployeeNumber",
    r."Age",
    r."Gender",
    r."MaritalStatus",
    r."Education",
    r."EducationField",
    d.department_id,
    jr.job_role_id,
    r."JobLevel",
    r."YearsAtCompany",
    r."YearsInCurrentRole",
    r."YearsSinceLastPromotion",
    r."YearsWithCurrManager",
    r."TotalWorkingYears",
    r."Attrition"
FROM employees_raw r
JOIN departments d ON d.department_name = r."Department"
JOIN job_roles jr ON jr.job_role_name = r."JobRole" AND jr.department_id = d.department_id;


-- ============================================================
-- STEP 6: salary_compensation
-- ============================================================

INSERT INTO salary_compensation (
    employee_id, monthly_income, hourly_rate, daily_rate,
    monthly_rate, percent_salary_hike, stock_option_level
)
SELECT
    "EmployeeNumber", "MonthlyIncome", "HourlyRate", "DailyRate",
    "MonthlyRate", "PercentSalaryHike", "StockOptionLevel"
FROM employees_raw;


-- ============================================================
-- STEP 7: performance
-- ============================================================

INSERT INTO performance (
    employee_id, job_satisfaction, performance_rating,
    environment_satisfaction, relationship_satisfaction,
    work_life_balance, job_involvement
)
SELECT
    "EmployeeNumber", "JobSatisfaction", "PerformanceRating",
    "EnvironmentSatisfaction", "RelationshipSatisfaction",
    "WorkLifeBalance", "JobInvolvement"
FROM employees_raw;


-- ============================================================
-- STEP 8: attendance_workload
-- ============================================================

INSERT INTO attendance_workload (
    employee_id, overtime, business_travel, distance_from_home,
    num_companies_worked, training_times_last_year
)
SELECT
    "EmployeeNumber", "OverTime", "BusinessTravel", "DistanceFromHome",
    "NumCompaniesWorked", "TrainingTimesLastYear"
FROM employees_raw;


-- ============================================================
-- STEP 9: quick check -- row counts should all be 1470
-- ============================================================

SELECT 'employees_raw' AS table_name, COUNT(*) FROM employees_raw
UNION ALL SELECT 'employees', COUNT(*) FROM employees
UNION ALL SELECT 'salary_compensation', COUNT(*) FROM salary_compensation
UNION ALL SELECT 'performance', COUNT(*) FROM performance
UNION ALL SELECT 'attendance_workload', COUNT(*) FROM attendance_workload;


-- ============================================================
-- END OF DATA LOADING
-- ============================================================