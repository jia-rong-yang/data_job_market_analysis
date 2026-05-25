/*
In this stage, I create raw tables to store the original CSV data.
Primary key and foreign key candidates are documented here, but not enforced yet.
They will be validated in the data quality check stage before creating the final tables.

Table creation and data loading should follow the parent-child relationship:
1. company_dim_raw          -- parent table
2. skills_dim_raw           -- parent table
3. job_postings_fact_raw    -- child of company_dim_raw
4. skills_job_dim_raw       -- bridge table; child of job_postings_fact_raw and skills_dim_raw
*/

CREATE TABLE skills_dim_raw (
    skill_id INT, --candidate PK
    skills VARCHAR(255),
    type VARCHAR(255)
);

CREATE TABLE company_dim_raw (
    company_id INT, --candidate PK
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

CREATE TABLE job_postings_fact_raw (
    job_id INT, --candidate PK
    company_id INT, --candidate FK
    job_title_short VARCHAR(255),
    job_title TEXT,
    job_location VARCHAR(255),
    job_via TEXT,
    job_schedule_type VARCHAR(255),
    job_work_from_home BOOLEAN,
    search_location VARCHAR(255),
    job_posted_date TIMESTAMP,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR(255),
    salary_rate VARCHAR(255),
    salary_year_avg NUMERIC,
    salary_hour_avg NUMERIC
);

CREATE TABLE skills_job_dim_raw (
    job_id INT, --candidate FK
    skill_id INT --candidate FK
    --composite(job_id, skill_id) candidate PK
    );