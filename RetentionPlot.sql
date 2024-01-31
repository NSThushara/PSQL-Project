DROP TABLE IF EXISTS Retention;

CREATE TABLE Retention
( id INT NOT NULL,
user_id INT NOT NULL,
total INT NOT NULL,
created date NOT NULL 
);


COPY Retention FROM 'D:\Q1.csv' WITH CSV HEADER;

SELECT * FROM Retention;

-- *****************************************************

DROP TABLE IF EXISTS Purchased;
CREATE TABLE purchased AS 
SELECT user_id, created FROM retention
GROUP BY user_id, created
ORDER BY user_id ;  
 
 SELECT * FROM Purchased;
 
--  **************************************************

DROP TABLE IF EXISTS Week;
CREATE TABLE week AS
SELECT id, user_id, total, created, date(date_trunc( 'week', created)) AS week_start FROM Retention

SELECT * FROM week;

--*********************************************************************8 

DROP TABLE IF EXISTS CustomerStartweek;
 CREATE TABLE CustomerStartweek AS
 SELECT user_id, min(week_start) AS cust_startweek FROM week
 GROUP BY user_id 
 ORDER BY cust_startweek; 
 
SELECT * FROM CustomerStartweek
ORDER BY user_id;

--************************************************************************ 

DROP TABLE IF EXISTS Final;
CREATE TABLE Final AS
SELECT *,(created - cust_startweek)/7 AS weekdiff FROM purchased AS a JOIN CustomerStartweek AS b USING (user_id);

SELECT * FROM Final
ORDER BY weekdiff, cust_startweek;

SELECT cust_startweek,
count (DISTINCT CASE WHEN weekdiff =0 THEN user_id END) AS Week0,
count (DISTINCT CASE WHEN weekdiff =1 THEN user_id END) AS Week1,
count (DISTINCT CASE WHEN weekdiff =2 THEN user_id END) AS Week2,
count (DISTINCT CASE WHEN weekdiff =3 THEN user_id END) AS Week3,
count (DISTINCT CASE WHEN weekdiff =4 THEN user_id END) AS Week4,
count (DISTINCT CASE WHEN weekdiff =5 THEN user_id END) AS Week5,
count (DISTINCT CASE WHEN weekdiff =6 THEN user_id END) AS Week6,
count (DISTINCT CASE WHEN weekdiff =7 THEN user_id END) AS Week7,
count (DISTINCT CASE WHEN weekdiff =8 THEN user_id END) AS Week8,
count (DISTINCT CASE WHEN weekdiff =9 THEN user_id END) AS Week9,
count (DISTINCT CASE WHEN weekdiff =10 THEN user_id END) AS Week10 FROM Final
GROUP BY cust_startweek
ORDER BY cust_startweek;