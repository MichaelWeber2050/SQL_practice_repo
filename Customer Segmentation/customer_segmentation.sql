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