# Employee Attrition Analysis

A data analytics project that examines employee attrition patterns using Python, Pandas, and PostgreSQL. The workflow separates data validation and preprocessing from SQL-based analysis so each stage can be reviewed and reproduced.

## Project Overview

The project explores how employee attrition differs across departments, job roles, compensation, overtime, job satisfaction, marital status, and tenure. Pandas is used for initial data inspection and cleaning, while PostgreSQL is used to organize the data into related tables and answer descriptive business questions.

The analysis describes patterns in the available dataset. It does not establish causation or provide a validated prediction of future employee departures.

## Dataset

| Item | Details |
|---|---|
| Raw file | `data/raw/employee_attrition_raw.csv` |
| Original size | 1,470 rows × 35 columns |
| One row represents | One employee |
| Target column | `Attrition` (`Yes` / `No`) |
| Processed file | `data/processed/employee_attrition_cleaned.csv` |

The source CSV is used as provided for this project. The dataset does not contain employee departure dates, so it cannot by itself show when departures occurred or support time-based attrition trends.

## Repository Structure

```text
employees-attrition/
├── README.md
├── data/
│   ├── raw/
│   │   └── employee_attrition_raw.csv
│   └── processed/
│       └── employee_attrition_cleaned.csv
├── notebooks/
│   └── 01_data_preprocessing.ipynb
└── sql/
    ├── schema.sql
    ├── data.sql
    └── queries.sql
```

## Data Preprocessing

Notebook: [`notebooks/01_data_preprocessing.ipynb`](notebooks/01_data_preprocessing.ipynb)

The notebook documents the initial data checks and cleaning steps:

1. Load the raw CSV file into a Pandas DataFrame.
2. Inspect the data using `head()`, `info()`, and `describe()`.
3. Check for missing values and duplicated rows.
4. Check the constant columns and verify the uniqueness of `EmployeeNumber` before deleting any columns.
5. Remove `EmployeeCount`, `Over18`, and `StandardHours` because they have constant values and do not provide useful variation for analysis.
6. Save the cleaned dataset to `data/processed/employee_attrition_cleaned.csv`.

The current cleaning step retains all 1,470 rows and reduces the dataset from 35 to 32 columns. `EmployeeNumber` is retained as an identifier for record tracking; it should be excluded from model features if a machine-learning stage is added later. Potential outliers should be reviewed in context rather than removed automatically.

## Database Design

The SQL schema organizes the data into six related tables.

| Table | Purpose |
|---|---|
| `departments` | Department identifiers and names |
| `job_roles` | Job-role names and their departments |
| `employees` | Employee demographics, employment attributes, department, role, and attrition status |
| `salary_compensation` | Income, pay rates, salary-hike percentage, and stock-option level |
| `performance` | Satisfaction, performance rating, and work-life balance measures |
| `attendance_workload` | Overtime, business travel, commuting distance, previous companies, and training information |

## SQL Business Questions

The queries are maintained in [`sql/queries.sql`](sql/queries.sql). They investigate:

1. What is the overall employee attrition rate?
2. Which departments have the highest attrition rates?
3. How does attrition vary by job role?
4. How does attrition compare by overtime status?
5. How does average monthly income differ between employees who left and those who stayed?
6. How do job satisfaction and work-life balance compare by attrition status?
7. How does attrition vary by marital status?
8. How does attrition vary across monthly-income brackets?
9. Which current employees match the exploratory rule of working overtime and having a stock-option level of `0`?
10. How do department headcount and average tenure compare?

### Attrition Rate

For a group, the attrition rate is calculated as:

```text
Attrition Rate (%) = (Employees with Attrition = Yes / Total Employees in the group) × 100
```

Counts and rates should be considered together because group sizes differ.

## Run Locally

### Requirements

- Python
- Pandas and Jupyter Notebook
- PostgreSQL
- The raw CSV file saved at `data/raw/employee_attrition_raw.csv`

### 1. Clone the repository

```bash
git clone https://github.com/MSalama8/employees-attrition.git
cd employees-attrition
```

### 2. Install the Python packages

```bash
python -m pip install pandas notebook
```

### 3. Run the preprocessing notebook

```bash
jupyter notebook
```

Open `notebooks/01_data_preprocessing.ipynb` and run the cells in order. Check that the input and output paths in the notebook match the repository structure shown above.

### 4. Create a PostgreSQL database

```bash
createdb employee_attrition
```

### 5. Create the tables

```bash
psql -d employee_attrition -f sql/schema.sql
```

### 6. Load the data

Before running `sql/data.sql`, update the CSV path in the `COPY` statement to the absolute path of `data/raw/employee_attrition_raw.csv` on your machine. PostgreSQL's server-side `COPY` requires the database server to be able to access that path.

```bash
psql -d employee_attrition -f sql/data.sql
```

The loading script is intended for a fresh database. Running it again without resetting the tables can cause duplicate-key errors or repeated staging data.

### 7. Run the analysis queries

```bash
psql -d employee_attrition -f sql/queries.sql
```

Execution order:

```text
schema.sql → data.sql → queries.sql
```

## Interpretation Notes

- **Association is not causation.** Group differences identify patterns to investigate; they do not prove that a characteristic causes employee attrition.
- **Question 9 is a rule-based filter, not a prediction.** It does not calculate a validated future risk score.
- **Compare counts and rates together.** A higher departure count does not necessarily mean a higher attrition rate.
- **Currency is unspecified.** Do not add a currency symbol unless the unit is confirmed from a reliable source.

## Team

- [Mohamed Sakr](https://github.com/SakrrDev) — Project Owner
- [Mohamed Salama](https://github.com/MSalama8) — Contributor
- [Mostafa Nabil](https://github.com/MostafaNabill1) — Contributor
- [Goda](https://github.com/Godas2) — Contributor
- [Ali Jabr](https://github.com/agabr7726-sketch) — Contributor
- [Abdelrahman](https://github.com/Bodika-dev) — Contributor
