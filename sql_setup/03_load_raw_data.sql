COPY skills_dim_raw (skill_id, skills, type)
FROM 'D:\DataNerd\data_job_market_analysis\raw_data\skills_dim.csv'
DELIMITER ','
CSV HEADER; --262 rows


COPY company_dim_raw (company_id, name, link, link_google, thumbnail)
FROM 'D:\DataNerd\data_job_market_analysis\raw_data\company_dim.csv'
DELIMITER ','
CSV HEADER; -- 215940 rows


COPY job_postings_fact_raw (
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
FROM 'D:\DataNerd\data_job_market_analysis\raw_data\job_postings_fact.csv'
DELIMITER ','
CSV HEADER; --1615930 rows


COPY skills_job_dim_raw (job_id, skill_id)
FROM 'D:\DataNerd\data_job_market_analysis\raw_data\skills_job_dim.csv'
DELIMITER ','
CSV HEADER; --7193426 rows

