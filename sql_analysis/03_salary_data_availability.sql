/*
-- Check whether any postings contain both hourly and yearly salary values.
-- Expected result: no rows returned.
*/
SELECT
    job_id,
    salary_rate,
    salary_hour_avg,
    salary_year_avg
FROM job_postings_fact
WHERE  
    job_country LIKE '%Belgium%'
    AND job_title_short IN ('Business Analyst', 'Data Analyst')
    AND salary_hour_avg IS NOT NULL 
    AND salary_year_avg IS NOT NULL;

/*
-- Count postings by salary_rate to evaluate salary data availability.
-- Salary data is mostly missing in Belgium DA/BA postings.
*/
SELECT 
    salary_rate,
    COUNT(*)
FROM job_postings_fact
WHERE 
    job_country LIKE '%Belgium%'
    AND job_title_short IN ('Business Analyst', 'Data Analyst')
GROUP BY salary_rate;

/*
-- Check whether postings with NULL salary_rate still contain salary values.
-- Expected result: no rows returned.
-- This confirms that NULL salary_rate means salary information is unavailable in this dataset.
*/
SELECT
    job_id,
    salary_rate,
    salary_hour_avg,
    salary_year_avg
FROM job_postings_fact
WHERE
    salary_rate IS NULL 
    AND (salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL)
    AND job_country LIKE '%Belgium%'
    AND job_title_short IN ('Business Analyst', 'Data Analyst');