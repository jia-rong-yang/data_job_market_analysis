/*
Analyze top employers for DA and BA postings in Leuven and Brussels.

This file compares employer concentration between Leuven and Brussels
by ranking companies based on their DA/BA job posting counts.
*/
WITH cleaned_jobs AS( --CTE 1: clean location names
    SELECT 
        job_id,
        job_title_short,
        company_id,
        job_location,
        REGEXP_REPLACE(TRIM(job_location),'\s*\(\+\d+\s+others?\)$','') AS cleaned_location
    FROM job_postings_fact
    WHERE 
        job_country LIKE '%Belgium%'
        AND job_title_short IN ('Business Analyst', 'Data Analyst')
),
company_info AS( --CTE 2: get DA/BA postings and company names for Leuven and Brussels
    SELECT
        cj.job_id,
        cj.job_title_short,
        cj.cleaned_location,
        cd.name AS company_name
    FROM cleaned_jobs AS cj
    INNER JOIN company_dim AS cd
        ON cj.company_id = cd.company_id
    WHERE job_location LIKE '%Leuven%' OR job_location LIKE '%Brussels%'
),
company_rank AS( --CTE 3: rank companies by job posting count within each city
    SELECT
        cleaned_location,
        company_name,
        COUNT(*) AS job_count_per_company,
        ROW_NUMBER()OVER(
            PARTITION BY cleaned_location
            ORDER BY COUNT(*) DESC
        ) AS company_rank
    FROM company_info
    GROUP BY cleaned_location, company_name
)
SELECT
    cleaned_location,
    company_name,
    job_count_per_company,
    company_rank
FROM company_rank 
ORDER BY cleaned_location, company_rank;