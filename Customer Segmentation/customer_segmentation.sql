CREATE TABLE customers (
  ID serial PRIMARY KEY,
  Gender VARCHAR(10),
  Ever_Married BOOLEAN,
  Age smallint,
  Graduated BOOLEAN,
  Profession VARCHAR(20),
  Work_Experience FLOAT(4),
  Spending_Score VARCHAR(10),
  Family_Size FLOAT(4),
  Var_1 VARCHAR(10)
);


COPY customers(ID, Gender, Ever_Married, Age, Graduated, Profession, Work_Experience, Spending_Score, Family_Size, Var_1)
FROM '/Users/michaelweber/Documents/SQL/Customer Segmentation/Test.csv'
DELIMITER ','
CSV HEADER;



SELECT customers.id 
FROM customers 
JOIN data_science_salaries ON customers.id=data_science_salaries.id 
limit 12;

SELECT customers.*, data_science_salaries.*
FROM customers
JOIN data_science_salaries ON customers.id = data_science_salaries.id
LIMIT 12;


# average age of males and females

SELECT gender, ROUND(avg(age),2)
FROM customers
GROUP BY gender;

 gender | round 
--------+-------
 Female | 43.46
 Male   | 43.81
(2 rows)


# "most popular" profession?

SELECT profession, count(*)
FROM customers
GROUP BY profession
ORDER BY count desc;

# what are the most common family sizes?

SELECT family_size, count(*)
FROM customers
GROUP BY family_size
ORDER BY count desc;


# most common spending score?

SELECT spending_score, count(*)
FROM customers
GROUP BY spending_score
ORDER BY count desc;

# graduates?

SELECT graduated, count(*)
FROM customers
GROUP BY graduated
ORDER BY count desc;


# id range?

SELECT MAX(id), MIN(id)
FROM customers
;

8979

# how many records in the data set?

2627

# which profession has the highest average age? 

SELECT profession, ROUND(avg(age),2) as average_age
FROM customers
GROUP BY profession
ORDER BY average_age desc
LIMIT 1;

# the lowest?

  profession   | average_age 
---------------+-------------
 Lawyer        |       75.67
 Executive     |       51.19
 Artist        |       46.16
               |       44.84
 Entertainment |       42.75
 Engineer      |       40.96
 Doctor        |       38.36
 Marketing     |       38.14
 Homemaker     |       37.91
 Healthcare    |       26.43
(10 rows)



# do men or women have a higher spending score? (most highs)

SELECT gender, spending_score, count(*)
FROM customers
WHERE spending_score is not null 
GROUP BY gender, spending_score
ORDER BY count desc;


# what is the average work experience?

SELECT avg(work_experience)
FROM customers;

# by gender

SELECT gender, avg(work_experience)
FROM customers
GROUP BY gender;




