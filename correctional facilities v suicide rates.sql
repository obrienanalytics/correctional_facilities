/*Hello everyone! Welcome to my SQL Project "Correctional Facilities in the United States and Suicide". Please note this is optimized for Microsoft SQL Server. -David O'Brien*/ 

--First, let's create the database testdb if it doesn't already exist. --
IF DB_ID('testdb') IS NULL
    CREATE DATABASE testdb;
GO

--Then, we'll switch to the newly created database.--
USE testdb;
GO

--Next, please import the files dbo.cor_facilities.csv, dbo.state_population.csv, and dbo.suicide.csv from this Github respository.--
--You will also want to double check your schemas are the same as this script.--

--Before we begin our analysis, let's get familiar with the three datasets we will be using for this project!--

--The first one has correctional facility data for the entire United States, including names of the facilities, addresses, population and capacity numbers, and much more!--
SELECT *
FROM testdb.dbo.cor_facilities

--The second dataset includes suicide data from 2014-2022, categorized by state and year.--
SELECT*
FROM testdb.dbo.suicide

--The final dataset outlines population numbers for each state.--
SELECT * 
FROM testdb.dbo.state_population

--Some correctional facilities have negative numbers listed as their population, either due to a data entry error or as a marker in their system for an unknown reason. For analyzation purposes, we need to transform these entries, so we will replace all negative numbers with zero.--
--We will not be updating the dataset for this in case other database users need to access the original data. Because of this, we will use a CASE statement as opposed to an UPDATE statement.--
SELECT 
	CASE
		WHEN population < 0 THEN 0
		ELSE population
		END AS pop_cleaned, name
FROM testdb.dbo.cor_facilities

--The same issue exists for the capacity field, so we will perform the same query there.--
SELECT 
	CASE
		WHEN capacity < 0 THEN 0
		ELSE capacity
		END AS cap_cleaned, name
FROM testdb.dbo.cor_facilities;

--Now we can accurately view which states have the most amount of correctional beds, using a common table expression with the cleaned capacity data--

WITH CleanedCapacity AS (
    SELECT 
        CASE
            WHEN capacity < 0 THEN 0
            ELSE capacity
        END AS cap_cleaned, 
        state_abbreviation
    FROM testdb.dbo.cor_facilities
)
SELECT state_abbreviation, SUM(cap_cleaned) AS sumcap
FROM CleanedCapacity
GROUP BY state_abbreviation
ORDER BY sumcap DESC;

--Let's take a look at the average capacity utilization, also called population to capacity ratio. In other words, how are states over or under utilizing their available space?--
--When we calculate this, the significance of the resulting numbers will be defined as below:--
--A value equal to 1.0 means the population is exactly equal to the state's capacity (fully utilized)-- 
--A value less than 1.0 indicates that the population is below capacity (under utilized) --
--A value greater than 1.0 indicates overutilization (over utilized) -- 

WITH CleanedCapacity AS (
	SELECT  
		FID, state_abbreviation,
		CASE
			WHEN capacity < 0 THEN NULL -- to prevent divide by zero error
			ELSE capacity
		END AS cap_cleaned
	FROM testdb.dbo.cor_facilities 
),

CleanedPopulation AS (
	SELECT
		FID, state_abbreviation,
		CASE
			WHEN population < 0 THEN NULL
			ELSE population
		END AS pop_cleaned
	FROM testdb.dbo.cor_facilities
)

SELECT 
	b.state_abbreviation, 
	AVG(CAST(b.pop_cleaned AS FLOAT) / CAST(a.cap_cleaned AS FLOAT)) AS capacity_population_ratio    --FLOAT is used to provide a decimal value for the calculation.--
FROM CleanedCapacity a
JOIN CleanedPopulation b ON a.FID=b.FID
WHERE a.cap_cleaned IS NOT NULL AND b.pop_cleaned > 0
GROUP BY b.state_abbreviation
ORDER BY capacity_population_ratio;

--We can see that Hawaii, Wisconsin, Kentucky, Virginia, Tennesse, Montana and South Carolina are all over utilizing their correctional facilities!--
--Washington DC, Utah, Nebraska, Georgia and North Dakota have the most amount of available space, comparative to their need.--


 --For this next section, we are going to explore how many facilities each state has--

SELECT COUNT (FID) AS facility_count, state_abbreviation       --We use the FID field because it is unique, unlike the name field. Sometimes a different correctional facility uses the same name as another one.--
FROM testDB.dbo.cor_facilities
GROUP BY state_abbreviation
ORDER BY facility_count DESC;

--And, voila! Texas, Florida, and California have the most amount of correctional facilities--

--But wait, at the bottom of the list, there are state abbreviations GU, VI, and MP, but none of these are states or districts (like D.C.).  Let's look into this more.--

SELECT * 
FROM testdb.dbo.cor_facilities
WHERE state_abbreviation IN ('MP', 'GU', 'VI');

--Ah, these refer to correctional facilities that the United States has in its territories of the Northern Mariana Islands, Guam, and the Virgin Islands!--

--For the last section, we are going to change tone a little bit, and join together a dataset that hosts information about suicides in the United States from 2014-2022.--
--Let's take a look.--

SELECT *
FROM testdb.dbo.suicide;


--Now we will join together both datasets to figure out the average number of suicides between 2014-2022 per state and include the correctional facility count next to it.--

SELECT a.State,  a.state_abbreviation, AVG(a.deaths) AS avg_suicides_per_year, COUNT(b.FID) AS cor_fac_count
FROM testdb.dbo.suicide a
FULL OUTER JOIN testdb.dbo.cor_facilities b
ON a.state_abbreviation=b.state_abbreviation
GROUP BY a.state, a.state_abbreviation
ORDER BY avg_suicides_per_year DESC;

--I'd like to know if there are any correlation between these numbers.--
--However, these numbers alone aren't statistically signficant enough to determine a proper correlation, because each state has a different population. Because of this, we will now calculate correctional facility rates and suicide rates based on another table that has population data.--


SELECT 
    a.State,  
    a.state_abbreviation, 
    AVG(a.deaths) AS avg_suicides_per_year, 
    COUNT(b.FID) AS cor_fac_count,
    AVG(a.deaths) * 100000.0 / sp.population AS suicides_per_100k,
    COUNT(b.FID) * 100000.0 / sp.population AS cor_fac_per_100k
FROM 
    testdb.dbo.suicide a
FULL OUTER JOIN 
    testdb.dbo.cor_facilities b
    ON a.state_abbreviation = b.state_abbreviation
LEFT JOIN 
    testdb.dbo.state_population sp
    ON a.state_abbreviation = sp.state_abbreviation
GROUP BY 
    a.state, a.state_abbreviation, sp.population
ORDER BY 
    avg_suicides_per_year DESC;

--The final query outlines suicides per 100,000 people and correctional facilities per 100,000 people.--
--These new columns can be run through a more statistics specific software like R or Python to determine the correlation coefficient between them. I did this and figured out that the correlation coefficient is .647125.--
--This indicates that there is a moderate to strong positive linear relationship between the number of correctional facilities each state has and the number of suicides people in that state commit!--
--This means that we see a correlation between higher numbers of correctional facilities and higher numbers of suicides.--

--Due to this insight, some other exploratory questions we could consider are:--
--1) How do mental health and incarceration rates correlate?--
--2) What would happen to crime rates if the United States focused more on mental health?--
--3) How do different states' policies on mental health and incarceration affect the observed correlation?--

--Overall, thank you so much for viewing my project. I hope you gained some knowledge about correctional facilities in the United States, and had fun exploring SQL with me!--

/* Have wonderful day! -David O'Brien */
