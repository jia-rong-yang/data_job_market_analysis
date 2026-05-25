CREATE TABLE company_dim (
    company_id INT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

CREATE TABLE skills_dim (
    skill_id INT PRIMARY KEY,
    skills VARCHAR(255),
    type VARCHAR(255)
);


CREATE TABLE job_postings_fact (
    job_id INT PRIMARY KEY,
    company_id INT REFERENCES company_dim(company_id),
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


CREATE TABLE skills_job_dim (
    job_id INT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings_fact(job_id),
    FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id)
);