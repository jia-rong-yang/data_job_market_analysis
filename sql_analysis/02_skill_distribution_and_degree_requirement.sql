/*
Analyze job posting volume and degree requirement ratio by listed skill bin.
Question: Do postings with more listed skills also tend to have more degree requirements?
*/
WITH sc AS( --CTE 1：count listed skills per job
    SELECT 
        job_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY job_id
),
sb AS ( --CTE 2： create analytical body for target roles
    SELECT 
        j.job_id,
        sc.skill_count,
        j.job_title_short,
        j.job_no_degree_mention,
        CASE
            WHEN sc.skill_count IS NULL THEN '0' 
            --If a job posting does not list any required skills, its skill count is treated as 0

            WHEN sc.skill_count BETWEEN 1 AND 3 THEN '1-3'
            WHEN sc.skill_count BETWEEN 4 AND 6 THEN '4-6'
            WHEN sc.skill_count BETWEEN 7 AND 9 THEN '7-9'
            WHEN sc.skill_count >= 10 THEN '10+'
        END AS listed_skill_bin
FROM job_postings_fact AS j
LEFT JOIN sc
    ON j.job_id = sc.job_id
WHERE 
    j.job_country LIKE '%Belgium%'
    AND j.job_title_short IN ('Business Analyst', 'Data Analyst')
)
SELECT --calculate job count and degree requirement ratio for each skill bin
    job_title_short, 
    listed_skill_bin,
    COUNT(*) AS total_jobs_per_bin,
    COUNT(*) FILTER(WHERE job_no_degree_mention IS FALSE) AS total_jobs_with_degree,
    ROUND(
        COUNT(*) FILTER(WHERE job_no_degree_mention IS FALSE)::numeric
        / COUNT(*)*100, 2
        ) AS pct_with_degree_per_bin
FROM sb
GROUP BY job_title_short, listed_skill_bin
ORDER BY job_title_short, total_jobs_per_bin DESC;


/*
Identify the top 10 most frequently listed skills for DA and BA postings in Belgium
*/
WITH skill_count_by_title AS( --CTE 1: count how often each skill appears per role
    SELECT 
        job_title_short,
        sd.skills,
        COUNT(*) AS skill_count_per_skill
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sjd
        ON j.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE 
        j.job_country LIKE '%Belgium%'
        AND j.job_title_short IN ('Business Analyst', 'Data Analyst')
    
    /*
    group by skill names instead of skill_id to handle duplicate skill_ids mapping to the same skill name
    e.g. skill 'sas' has two skill_ids 8 and 194
    */
    GROUP BY j.job_title_short, sd.skills 
),
skill_rank AS( --CTE 2: rank skills by frequency in each role
    SELECT 
        job_title_short,
        skills,
        skill_count_per_skill,
        ROW_NUMBER() OVER(
            PARTITION BY job_title_short
            ORDER BY scbt.skill_count_per_skill DESC
        ) AS skill_rank_by_title
    FROM skill_count_by_titles
) 
SELECT -- filter top 10 skills per role
    job_title_short,
    skills,
    skill_count_per_skill
FROM skill_rank
WHERE skill_rank_by_title BETWEEN 1 AND 10
ORDER BY job_title_short;
