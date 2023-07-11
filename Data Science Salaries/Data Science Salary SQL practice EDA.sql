CREATE TABLE data_science_salaries (
  id serial PRIMARY KEY,
  work_year smallint,
  experience_level VARCHAR(2),
  employment_type VARCHAR(2),
  job_title VARCHAR(50),
  salary integer,
  salary_currency VARCHAR(3),
  salary_in_usd integer,
  employee_residence VARCHAR(2),
  remote_ratio smallint,
  company_location VARCHAR(2),
  company_size VARCHAR(1)
);


RangeIndex: 3755 entries, 0 to 3754
Data columns (total 11 columns):
 #   Column              Non-Null Count  Dtype 
---  ------              --------------  ----- 
 0   work_year           3755 non-null   int64 
 1   experience_level    3755 non-null   object
 2   employment_type     3755 non-null   object
 3   job_title           3755 non-null   object
 4   salary              3755 non-null   int64 
 5   salary_currency     3755 non-null   object
 6   salary_in_usd       3755 non-null   int64 
 7   employee_residence  3755 non-null   object
 8   remote_ratio        3755 non-null   int64 
 9   company_location    3755 non-null   object
 10  company_size        3755 non-null   object
dtypes: int64(4), object(7)


work_year experience_level  employment_type job_title salary  salary_currency salary_in_usd employee_residence  remote_ratio  company_location  company_size
0 2023  SE  FT  Principal Data Scientist  80000 EUR 85847 ES  100 ES  L
1 2023  MI  CT  ML Engineer 30000 USD 30000 US  100 US  S
2 2023  MI  CT  ML Engineer 25500 USD 25500 US  100 US  S
3 2023  SE  FT  Data Scientist  175000  USD 175000  CA  100 CA  M
4 2023  SE  FT  Data Scientist  120000  USD 120000  CA  100 CA  M



COPY data_science_salaries(id,work_year, experience_level, employment_type, job_title,
       salary, salary_currency, salary_in_usd, employee_residence,
       remote_ratio, company_location, company_size)
FROM '/Users/michaelweber/Documents/SQL/ds_salaries_2.csv'
DELIMITER ','
CSV HEADER;



SELECT work_year, job_title, salary, company_size, experience_level, employee_residence
  FROM data_science_salaries
  WHERE salary > 10000000;



SELECT COUNT ( DISTINCT job_title ) AS "distinct job titles"
FROM data_science_salaries;


SELECT job_title, AVG(salary) AS average_salary
FROM data_science_salaries
GROUP BY job_title
ORDER BY average_salary DESC
LIMIT 20;


SELECT job_title, MAX(salary) as highest_salary
FROM data_science_salaries
GROUP BY job_title
ORDER BY highest_salary DESC
LIMIT 20;




# find if there are any product manager roles listed

SELECT * 
FROM data_science_salaries
WHERE job_title like '%Product Manager%';

SELECT *
FROM data_science_salaries
WHERE job_title LIKE '%Manager%';


# by avg salary with nore than 1 listing in the data
SELECT job_title, AVG(salary) AS average_salary, COUNT(job_title) AS job_count
FROM data_science_salaries
GROUP BY job_title
HAVING COUNT(job_title) > 1
ORDER BY average_salary DESC
LIMIT 20;




SELECT salary, COUNT(*) AS frequency
FROM data_science_salaries
GROUP BY salary
HAVING COUNT(*) = (
    SELECT MAX(count) 
    FROM (
        SELECT salary, COUNT(*) AS count
        FROM data_science_salaries
        GROUP BY salary
    ) AS counts
);




# whats the average difference between salary and salary_in_usd? 

SELECT ROUND(AVG(salary - salary_in_usd)) AS average_difference
FROM data_science_salaries;


50k!!!

# salary_in_usd

SELECT ROUND(AVG(salary_in_usd)) AS mean_salary
FROM data_science_salaries;



SELECT salary_in_usd, COUNT(*) AS frequency
FROM data_science_salaries
GROUP BY salary_in_usd
HAVING COUNT(*) = (
    SELECT MAX(count) 
    FROM (
        SELECT salary_in_usd, COUNT(*) AS count
        FROM data_science_salaries
        GROUP BY salary_in_usd
    ) AS counts
);



# what is the 80th and median percentiles of salary_in_usd by company_location

SELECT 
  company_location, 
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median
FROM data_science_salaries
GROUP BY company_location
ORDER BY percentile_80 desc
LIMIT 20;


# how about with job_titles?

SELECT 
  company_location, 
  job_title,
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median,
  COUNT(job_title) AS count 
FROM data_science_salaries
GROUP BY company_location, job_title
ORDER BY percentile_80 desc
LIMIT 20;


# with the counts for reference

SELECT 
  company_location, 
  job_title,
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median,
  COUNT(job_title) AS count 
FROM data_science_salaries
GROUP BY company_location, job_title
ORDER BY percentile_80 desc
LIMIT 20;

# and count > 1

SELECT 
  company_location, 
  job_title,
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median,
  COUNT(job_title) AS count 
FROM data_science_salaries
GROUP BY company_location, job_title
HAVING COUNT(job_title) > 1
ORDER BY percentile_80 DESC
LIMIT 20;


# top 5 countries with more than a dozen entries 

SELECT 
  company_location, 
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median,
  COUNT(company_location) as count
FROM data_science_salaries
GROUP BY company_location
HAVING COUNT(company_location) > 12
ORDER BY percentile_80 desc
LIMIT 20;


# median and 80th percentile of salary_in_usd by company_size


SELECT 
  company_size, 
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median,
  AVG(percentile_80 - median) as average_difference
FROM data_science_salaries
GROUP BY company_size;




SELECT 
  company_size, 
  ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) AS percentile_80,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd)) AS median,
  AVG(ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY salary_in_usd)) - ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd))) AS average_difference
FROM data_science_salaries
GROUP BY company_size;



SELECT job_title FROM data_science_salaries WHERE salary > 1000000
UNION
SELECT job_title FROM data_science_salaries WHERE salary_in_usd > 1000000;


SELECT distinct(job_title) FROM data_science_salaries WHERE job_title LIKE 'Data%';

SELECT distinct(job_title) FROM data_science_salaries WHERE job_title LIKE '%z%';

SELECT distinct(job_title) FROM data_science_salaries WHERE job_title LIKE '%Quality%';



SELECT id, job_title, salary_in_usd FROM data_science_salaries ORDER BY salary_in_usd desc LIMIT 12; 


SELECT id, job_title, salary_in_usd FROM data_science_salaries ORDER BY salary_in_usd desc LIMIT 12; 

