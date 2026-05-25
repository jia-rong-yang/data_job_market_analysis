/*
This setup stage focuses on foundational data quality checks, 
including load completeness, PK, FK validation, and missing value checks. 
More detailed will be handled in the analysis stage when those fields are directly used.

A. Load Completeness Checks
B. Primary key checks: PRIMARY KEY = UNIQUE + NOT NULL
C. Foreign key checks
D. Missing value checks 
*/

---------------------A. Load Completeness Checks---------------------
/*
Table                     Expected Rows from CSV     Loaded Rows in SQL
company_dim_raw           215,941                    215,940
skills_dim_raw            263                        262
job_postings_fact_raw     1,615,931                  1,615,930
skills_job_dim_raw        7,193,427                  7,193,426

Result:
All loaded table row counts match the expected CSV row counts.
*/
SELECT COUNT(*)
FROM company_dim_raw; 

SELECT COUNT(*)
FROM skills_dim_raw; 

SELECT COUNT(*)
FROM job_postings_fact_raw; 

SELECT COUNT(*)
FROM skills_job_dim_raw; 

---------------------B. Primary key checks---------------------
--skills_dim_raw.sklill_id is PK
SELECT 
    skill_id,
    COUNT(*)
FROM skills_dim_raw
GROUP BY skill_id
HAVING COUNT(*)>1; --no data found = skill_id is unique

SELECT *
FROM skills_dim_raw
WHERE skill_id IS NULL; --no data found = skill_id has no NULL

--company_dim_raw.company_id is PK
SELECT 
    company_id,
    COUNT(*)
FROM company_dim_raw
GROUP BY company_id
HAVING COUNT(*)>1; --no data found = company_id is unique

SELECT *
FROM company_dim_raw
WHERE company_id IS NULL; --no data found = company_id has no NULL

/*
skills_job_dim_raw is bridge tabel
(job_id, skill_id) is composite PK
*/
SELECT 
    job_id,
    skill_id,
    COUNT(*) 
FROM skills_job_dim_raw
GROUP BY job_id, skill_id
HAVING COUNT(*) > 1; --no data found, so (job_id, skill_id) is unique

SELECT *
FROM skills_job_dim_raw
WHERE job_id IS NULL 
    OR skill_id IS NULL; --no data found, eithor job_id or skill_id have no NULL value

--job_postings_fact.job_id is PK    
SELECT 
    job_id,
    COUNT(*)
FROM job_postings_fact_raw
GROUP BY job_id
HAVING COUNT(*)>1; --no data found, job_id is unique

SELECT *
FROM job_postings_fact_raw
WHERE job_id IS NULL; --no data found = job_id has no NULL

---------------------C. Foreign key checks---------------------
SELECT 
    j.job_id,
    j.company_id
FROM job_postings_fact_raw AS j --child table
LEFT JOIN company_dim_raw AS c --parent table
    ON j.company_id = c.company_id
WHERE j.company_id IS NOT NULL
  AND c.company_id IS NULL; --no data found, so j.company_id is FK 

SELECT 
    sj.job_id
FROM skills_job_dim_raw AS sj --child table
LEFT JOIN job_postings_fact_raw AS j --parent table
    ON sj.job_id = j.job_id
WHERE sj.job_id IS NOT NULL
    AND j.job_id IS NULL; --no data found, so sj.job_id is FK

SELECT 
    sj.skill_id
FROM skills_job_dim_raw AS sj --cild table
LEFT JOIN skills_dim_raw AS s --parent table
    ON sj.skill_id = s.skill_id
WHERE sj.skill_id IS NOT NULL
    AND s.skill_id IS NULL; --no data found, so sj.skill_id is FK

---------------------D. Missing value checks---------------------
/*
If missing count is below 100 rows, only the missing count is reported.
Missing rate is calculated only for fields with 100 or more missing rows.

Salary data quality notes:
- Salary fields have high missing rates.
- Missing rate: salary_rate 94.91%, salary_year_avg 96.84%, salary_hour_avg 98.39%
- Further salary analysis should check whether the selected salary fields are valid and have enough usable records.
- Salary-related conclusions should be interpreted with caution due to limited salary data availability.
*/
SELECT
    COUNT(*) AS total_rows, --1615930
    COUNT(*) FILTER (WHERE job_title_short IS NULL) AS missing_jts, --0

    COUNT(*) FILTER (WHERE job_title IS NULL) AS missing_jt, --2   

    COUNT(*) FILTER (WHERE job_location IS NULL) AS missing_jl, --3528
    ROUND(COUNT(*) FILTER (WHERE job_location IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS mr_jl, --0.22%

    COUNT(*) FILTER (WHERE job_via IS NULL) AS missing_jv, --14

    COUNT(*) FILTER (WHERE job_schedule_type IS NULL) AS missing_jst, --25051
    ROUND(COUNT(*) FILTER (WHERE job_schedule_type IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS mr_jst, --1.55%
    
    COUNT(*) FILTER (WHERE job_work_from_home IS NULL) AS missing_jwfh, --0
    COUNT(*) FILTER (WHERE search_location IS NULL) AS missing_sl, --0
    COUNT(*) FILTER (WHERE job_posted_date IS NULL) AS missing_jpd, --0
    COUNT(*) FILTER (WHERE job_no_degree_mention IS NULL) AS missing_jndm, --0
    COUNT(*) FILTER (WHERE job_health_insurance IS NULL) AS missing_jhi, --0
    
    COUNT(*) FILTER (WHERE job_country IS NULL) AS missing_jc, --1125
    ROUND(COUNT(*) FILTER (WHERE job_country IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS mr_jc, --0.07%

    COUNT(*) FILTER (WHERE salary_rate IS NULL) AS missing_sr, --1533700
    ROUND(COUNT(*) FILTER (WHERE salary_rate IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS mr_sr, --94.91%

    COUNT(*) FILTER (WHERE salary_year_avg IS NULL) AS missing_sya, --1564904
    ROUND(COUNT(*) FILTER (WHERE salary_year_avg IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS mr_sya, --96.84%

    COUNT(*) FILTER (WHERE salary_hour_avg IS NULL) AS missing_sha, --1589871
    ROUND(COUNT(*) FILTER (WHERE salary_hour_avg IS NULL)::NUMERIC / COUNT(*) * 100, 2) AS mr_sha --98.39%

FROM job_postings_fact_raw;