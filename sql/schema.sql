-- ============================================================
-- EMPLOYEE ATTRITION DATABASE
-- DATABASE SCHEMA
-- ============================================================
-- Purpose:
-- This schema defines the relational database structure for
-- analyzing employee information, compensation, performance,
-- workload, departments, and job roles.
-- ============================================================


-- ============================================================
-- TABLE: departments
-- Purpose:
-- Stores organizational departments.
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (

    department_id       INT PRIMARY KEY,
    department_name     VARCHAR(100)

);


-- ============================================================
-- TABLE: job_roles
-- Purpose:
-- Stores job roles, their organizational level, and the
-- department to which each role belongs.
-- ============================================================

CREATE TABLE IF NOT EXISTS job_roles (

    job_role_id             INT PRIMARY KEY,
    job_role_name           VARCHAR(100),
    department_id           INT REFERENCES departments(department_id)

);


-- ============================================================
-- TABLE: employees
-- Purpose:
-- Stores the core demographic, employment, organizational,
-- and attrition information for each employee.
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (

    employee_id                 INT PRIMARY KEY,
    age                         INT,
    gender                      VARCHAR(10),
    marital_status              VARCHAR(20),
    education_level             INT,
    education_field             VARCHAR(50),
    department_id               INT REFERENCES departments(department_id),
    job_role_id                 INT REFERENCES job_roles(job_role_id),
    job_level                   INT,
    years_at_company            INT,
    years_in_current_role       INT,
    years_since_last_promotion  INT,
    years_with_current_manager  INT,
    total_working_years         INT,
    attrition                   VARCHAR(3)

);


-- ============================================================
-- TABLE: salary_compensation
-- Purpose:
-- Stores salary, compensation, and stock option information
-- for each employee.
-- ============================================================

CREATE TABLE IF NOT EXISTS salary_compensation (

    employee_id          INT PRIMARY KEY REFERENCES employees(employee_id),
    monthly_income       DECIMAL(10,2),
    hourly_rate          DECIMAL(10,2),
    daily_rate           DECIMAL(10,2),
    monthly_rate         DECIMAL(10,2),
    percent_salary_hike  DECIMAL(5,2),
    stock_option_level   INT

);


-- ============================================================
-- TABLE: performance
-- Purpose:
-- Stores employee satisfaction, performance, and work-related
-- evaluation metrics.
-- ============================================================

CREATE TABLE IF NOT EXISTS performance (

    employee_id                 INT PRIMARY KEY REFERENCES employees(employee_id),
    job_satisfaction            INT,
    performance_rating          INT,
    environment_satisfaction    INT,
    relationship_satisfaction   INT,
    work_life_balance           INT,
    job_involvement              INT

);


-- ============================================================
-- TABLE: attendance_workload
-- Purpose:
-- Stores employee workload, overtime, business travel,
-- commuting distance, and training-related information.
-- ============================================================

CREATE TABLE IF NOT EXISTS attendance_workload (

    employee_id                INT PRIMARY KEY REFERENCES employees(employee_id),
    overtime                   VARCHAR(3),
    business_travel            VARCHAR(20),
    distance_from_home         INT,
    num_companies_worked       INT,
    training_times_last_year   INT

);


-- ============================================================
-- END OF DATABASE SCHEMA
-- ============================================================
