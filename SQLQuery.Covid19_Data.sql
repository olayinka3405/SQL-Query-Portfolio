--COVID DATA 2020 TO DATE

USE PortfolioProjects;  --Query used to switch to a database

--Retrieve data (all columns) from database-CovidDeaths
SELECT * FROM PortfolioProjects.[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 3, 4

--Retrieve data (all columns) from database-CovidVaccinations
SELECT * FROM PortfolioProjects.[dbo].[CovidVaccinations]
WHERE continent IS NOT NULL
ORDER BY 3, 4

--Retrieve data (specific columns) from database-CovidDeaths
SELECT [location] AS Countries, [date], [total_cases], [new_cases], [total_deaths], [population]  
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

--Which country has the highest death rate compare to population
--Comparing the total number of COVID cases to the total number of COVID-related deaths
--Shows likelihood a person would died if infected with Covid-19
SELECT [Location] AS Country, SUM([new_cases]) AS 'Total Case', SUM([new_deaths]) AS 'Total Death',
	CASE
		WHEN  SUM([new_cases]) = 0 THEN NULL
		ELSE ROUND((((SUM([new_deaths])) / (SUM([new_cases]))) * 100), 4)
	END AS 'Death Rate'
FROM [dbo].[CovidDeaths]
WHERE [continent] IS NOT NULL
GROUP BY [location]
ORDER BY 'Death Rate' DESC

--Infection rate Vs Population
--Looking at Top 20 countries with highest infection rate (Total Cases compared to Unvaccinated Population) before Vaccination
SELECT TOP 20 Location AS Countries, Population, MAX(CAST(Total_cases AS NUMERIC)) AS 'Total Case', MAX((CAST(total_cases AS NUMERIC))/(population))*100 AS 'Infection Rate'
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY 'Infection Rate' DESC

--Looking at Top 20 countries with highest infection rate (Total Cases compared to Vaccinated Population) after Vaccination
SELECT TOP 5 CD.location AS Countries, MAX(CAST(CV.[people_fully_vaccinated] AS NUMERIC)) AS 'Population Vaccinated', SUM(CD.[new_cases]) AS 'Total Case', (SUM(CD.[new_cases]) / SUM(CAST(CV.[people_fully_vaccinated] AS NUMERIC)))*100 AS 'Infection Rate'
FROM PortfolioProjects..CovidDeaths AS CD
JOIN PortfolioProjects..CovidVaccinations AS CV
	ON CD.location = CV.location
	AND CD.date = CV.date
GROUP BY CD.location
ORDER BY 'Infection Rate' DESC

--Looking at infection rate of some First World Countries (Total Cases compared to Unvaccinated Population) before Vaccination
SELECT Location AS Countries, MAX(Population) AS 'Unvaccinated Population', MAX(CAST(Total_cases AS NUMERIC)) AS 'Total Case', MAX((CAST(total_cases AS NUMERIC))/(population))*100 AS 'Infection Rate'
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
AND location IN ('Switzerland', 'Australia', 'Canada', 'Luxembourg','Norway', 'Ireland','Iceland', 'Denmark', 'United States', 'Russia', 'China', 'France' )  
OR location LIKE '%kingdom%'
GROUP BY Location, Population
ORDER BY 'Infection Rate' DESC

--Looking at infection rate of some First World Countries (Total Cases compared to Vaccinated Population) after Vaccination
SELECT CD.location AS Countries, MAX(CAST(CV.[people_fully_vaccinated] AS NUMERIC)) AS 'Population Vaccinated', SUM(CD.[new_cases]) AS 'Total Case', (SUM(CD.[new_cases]) / SUM(CAST(CV.[people_fully_vaccinated] AS NUMERIC)))*100 AS 'Infection Rate'
FROM PortfolioProjects..CovidDeaths AS CD
JOIN PortfolioProjects..CovidVaccinations AS CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
AND CD.total_cases IS NOT NULL
AND CD.Total_cases IS NOT NULL
AND CD.location IN ('Switzerland', 'Australia', 'Canada', 'Luxembourg','Norway', 'Ireland','Iceland', 'Denmark', 'United States', 'Russia', 'China', 'France' ) 
OR CD.location LIKE '%kingdom%'
GROUP BY CD.location
ORDER BY 'Infection Rate' DESC 

--Which continent has the highest death rate compare to population
--Examining the continent with the most significant number of deaths @before Vaccination
SELECT Continent, SUM([new_cases]) AS 'Total Cases', SUM([new_deaths]) AS 'Total Deaths', ROUND(((SUM([new_deaths]) / SUM([new_cases])) * 100), 4) AS 'Death Rate'
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 3 DESC

--Which country has the highest death rate compare to population
--Examining the country with the most significant number of deaths @before Vaccination
SELECT Location AS Countries, SUM([new_cases]) AS 'Total Cases', MAX(CONVERT(FLOAT, total_deaths)) AS 'Total Deaths', ROUND((MAX(CONVERT(FLOAT, total_deaths)) / SUM([new_cases]) * 100), 4) AS 'Deaths Rate'
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
HAVING SUM([new_cases]) IS NOT NULL
AND MAX(CONVERT(FLOAT, total_deaths)) IS NOT NULL
ORDER BY 3 DESC

--Examining the Relationship Between Countries Total Population and Total Vaccination
SELECT CD.location AS Countries, CD.Population, SUM([new_cases]) AS 'Total Cases', MAX(CONVERT(FLOAT, total_deaths)) AS 'Total Deaths',
	SUM(CAST(CV.new_vaccinations AS NUMERIC)) AS 'Total Vaccinations'
FROM PortfolioProjects..CovidDeaths AS CD
	JOIN PortfolioProjects..CovidVaccinations AS CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
	AND CV.continent IS NOT NULL
GROUP BY CD.location, CD.population
HAVING SUM(CAST(CV.new_vaccinations AS NUMERIC)) IS NOT NULL
ORDER BY 5 DESC

--Examining the Relationship Between Countries, Total Population and Total Vaccination By Date
SELECT CD.Continent, CD.location AS Countries, CD.Date, CD.Population, CV.New_Vaccinations, 
		SUM(CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, cd.date) AS Rolling_People_Vaccinated
FROM PortfolioProjects..CovidDeaths AS CD
	JOIN PortfolioProjects..CovidVaccinations AS CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
	AND CV.new_vaccinations IS NOT NULL
ORDER BY 2, 3;

--Using Common Table Expression (CTE)
With Pop_Vs_Vacc (Continent, Countries, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS 
(
SELECT CD.continent, CD.location AS Countries, CD.date, CD.population, CV.new_vaccinations, 
	SUM(CAST(CV.new_vaccinations AS FLOAT)) OVER (PARTITION BY CD.location ORDER BY CD.location, cd.date) AS Rolling_People_Vaccinated
FROM PortfolioProjects..CovidDeaths AS CD
	JOIN PortfolioProjects..CovidVaccinations AS CV
	ON CD.location = CV.location
	AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
)
SELECT * , (Rolling_People_Vaccinated/population) * 100
FROM Pop_Vs_Vacc
