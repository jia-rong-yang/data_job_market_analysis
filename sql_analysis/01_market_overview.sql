/*
Job postings overview in the Belgian labor market

This file analyzes how DA and BA job posting volumes changed over time
and how they are distributed across locations.
*/

-- Total number job postings of DA and BA roles in Belgium
SELECT 
    job_title_short,
    COUNT(*) AS job_count,
    ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER() *100, 2) AS market_share 
FROM job_postings_fact
WHERE 
    job_country LIKE '%Belgium%'
    AND job_title_short IN ('Business Analyst', 'Data Analyst')
GROUP BY job_title_short

UNION ALL

SELECT 'Total', COUNT(*), 100.00
FROM job_postings_fact
WHERE 
    job_country LIKE '%Belgium%'
    AND job_title_short IN ('Business Analyst', 'Data Analyst'); 

-- Quarterly trend of DA and BA job postings in Belgium
SELECT
    EXTRACT(YEAR FROM job_posted_date)::INT AS posted_year, --1
    EXTRACT(QUARTER FROM job_posted_date)::INT AS posted_quarter, --2
    COUNT(*) AS job_count
FROM job_postings_fact
WHERE 
    job_country LIKE '%Belgium%'
    AND job_title_short IN ('Business Analyst', 'Data Analyst')
GROUP BY 1, 2;    

-- Monthly trend of DA and BA job postings in Belgium
WITH all_month AS( --CTE 1: create a complete calander table
    SELECT 
        EXTRACT(YEAR FROM generate_series)::INT AS posted_year,
        EXTRACT(MONTH FROM generate_series)::INT AS posted_month
    FROM generate_series(
        '2023-01-01'::date,
        '2025-06-30'::date,
        INTERVAL '1 month'
    )
),
exist_month AS( --CTE 2: count job postings by actual posting months
    SELECT
        EXTRACT(YEAR FROM job_posted_date)::INT AS posted_year, --1
        EXTRACT(MONTH FROM job_posted_date)::INT AS posted_month, --2
        COUNT(*) AS job_count
    FROM job_postings_fact
    WHERE 
        job_country LIKE '%Belgium%'
        AND job_title_short IN ('Business Analyst', 'Data Analyst')
    GROUP BY 1, 2
)
SELECT
    am.posted_year,
    am.posted_month,
    COALESCE(em.job_count, 0) AS job_count
FROM all_month AS am
LEFT JOIN exist_month AS em
    ON  am.posted_year = em.posted_year
    AND am.posted_month = em.posted_month
ORDER BY am.posted_year, am.posted_month;


/*
Job posting volume across locations

The following two queries use the same CTEs for location cleaning and classification.
The CTEs are repeated so that each query can be run independently.

- CTE 1: Clean location names by removing the "(+n others)" suffix
- CTE 2: Classify cleaned locations into location type labels

- Query 1: Location type distribution
- Query 2: City-level distribution, based only on the 7,874 postings with city-level location data
*/

-- Query 1
WITH cleaned_jobs AS ( --CTE 1 
    SELECT 
        job_location,
        REGEXP_REPLACE(TRIM(job_location),'\s*\(\+\d+\s+others?\)$','') AS cleaned_location
    FROM job_postings_fact
    WHERE 
        job_country LIKE '%Belgium%'
        AND job_title_short IN ('Business Analyst', 'Data Analyst')
),
jobs_in_belgium AS( --CTE2 
    SELECT 
        job_location,
        cleaned_location,
        CASE 
            WHEN job_location IS NULL THEN 'missing_location'
            WHEN cleaned_location = 'Anywhere' THEN 'remote_job'
            
            WHEN cleaned_location = 'Belgium' THEN 'city_unspecified'
            
            WHEN cleaned_location IN(
                    'Flanders, Belgium',
                    'Wallonia, Belgium',
                    'East Flanders, Belgium',
                    'West Flanders, Belgium',
                    'Flemish Brabant, Belgium',
                    'Walloon Brabant, Belgium',
                    'Hainaut, Belgium',
                    'Limburg, Belgium',
                    'Limbourg, Belgium'
                )
                THEN 'region_or_province_level_location'
            WHEN cleaned_location LIKE '%, Belgium' THEN 'city_level_location'
            ELSE 'other_location_format'
        END AS location_type
    FROM cleaned_jobs
    )
SELECT 
    location_type,
    COUNT(*) AS job_count,
    ROUND(
        COUNT(*)::numeric *100 / SUM(COUNT(*)) OVER(), 2
    ) AS pct_per_location_type    
FROM jobs_in_belgium
GROUP BY location_type;

-- Query 2
WITH cleaned_jobs AS ( --CTE 1
    SELECT 
        job_location,
        REGEXP_REPLACE(TRIM(job_location),'\s*\(\+\d+\s+others?\)$','') AS cleaned_location
    FROM job_postings_fact
    WHERE 
        job_country LIKE '%Belgium%'
        AND job_title_short IN ('Business Analyst', 'Data Analyst')
),
jobs_in_belgium AS( --CTE 2 
    SELECT 
        job_location,
        cleaned_location,
        CASE 
            WHEN job_location IS NULL THEN 'missing_location'
            WHEN cleaned_location = 'Anywhere' THEN 'remote_job'
            
            WHEN cleaned_location = 'Belgium' THEN 'city_unspecified'
            
            WHEN cleaned_location IN(
                    'Flanders, Belgium',
                    'Wallonia, Belgium',
                    'East Flanders, Belgium',
                    'West Flanders, Belgium',
                    'Flemish Brabant, Belgium',
                    'Walloon Brabant, Belgium',
                    'Hainaut, Belgium',
                    'Limburg, Belgium',
                    'Limbourg, Belgium'
                )
                THEN 'region_or_province_level_location'
            WHEN cleaned_location LIKE '%, Belgium' THEN 'city_level_location'
            ELSE 'other_location_format'
        END AS location_type
    FROM cleaned_jobs
    )
SELECT 
    cleaned_location,
    COUNT(*) AS job_count,
    ROUND(
        COUNT(*)::numeric / SUM(COUNT(*)) OVER(), 2
    )*100 AS pct_per_city
    
FROM jobs_in_belgium
WHERE location_type = 'city_level_location'
GROUP BY cleaned_location
ORDER BY job_count DESC;