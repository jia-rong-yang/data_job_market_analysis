/*
Raw tables were used only for initial loading and data quality checks. 
After the analysis-ready tables were created and populated, 
raw tables were dropped to keep the database workspace clean.
*/
INSERT INTO company_dim (
    company_id,
    name,
    link,
    link_google,
    thumbnail
)
SELECT
    company_id,
    name,
    link,
    link_google,
    thumbnail
FROM company_dim_raw;


INSERT INTO skills_dim (
    skill_id,
    skills,
    type
)
SELECT
    skill_id,
    skills,
    type
FROM skills_dim_raw;


INSERT INTO job_postings_fact (
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_schedule_type,
    job_work_from_home,
    search_location,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
)
SELECT
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_schedule_type,
    job_work_from_home,
    search_location,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
FROM job_postings_fact_raw;

INSERT INTO skills_job_dim (
    job_id,
    skill_id
)
SELECT
    job_id,
    skill_id
FROM skills_job_dim_raw;


DROP TABLE IF EXISTS skills_job_dim_raw;
DROP TABLE IF EXISTS job_postings_fact_raw;
DROP TABLE IF EXISTS skills_dim_raw;
DROP TABLE IF EXISTS company_dim_raw;