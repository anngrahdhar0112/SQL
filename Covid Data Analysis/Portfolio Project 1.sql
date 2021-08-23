-- Displaying all the data from Covid Deaths Table
SELECT * FROM ['Covid Deaths']
WHERE continent IS NOT NULL;

-- Displaying all the data from Covid Vaccinations Table
SELECT * FROM ['Covid Vaccinations']
WHERE continent IS NOT NULL;



-- Total cases vs Total Deaths
-- It Shows likelihood of dying if you contract covid in A PARTICULAR country
SELECT location,date,total_cases,total_deaths,((total_deaths/total_cases)*100) AS 'Death Percentage'
FROM ['Covid Deaths']
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 1,2


-- Total cases vs population
SELECT location,date,total_cases,population,((total_cases/population)*100) AS 'Covid positive Percentage'
FROM ['Covid Deaths']
WHERE continent IS NOT NULL
ORDER BY 1,2;


--Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS Highest_Infection_Rate_per_Country, 
MAX((total_cases/population))*100 AS Covid_Positive_Percentage
FROM ['Covid Deaths']
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Covid_Positive_Percentage DESC;


-- Showing countries with highest death count per popuation
SELECT location, MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM ['Covid Deaths']
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC;


-- Breaking of things down by continent
-- Showing continent with highest death count per popuation
SELECT continent, MAX(CAST(total_deaths AS int)) AS Total_Death_Count
FROM ['Covid Deaths']
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC;



-- Global Numbers
SELECT SUM(new_cases) AS Total_New_Cases,SUM(CAST(new_deaths AS int)) AS Total_New_Deaths,
(SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 AS New_Death_Percentage
FROM ['Covid Deaths']
WHERE CONTINENT IS NOT NULL
-- group by date



-- Joining two tables
SELECT * FROM ['Covid Deaths'] cd
JOIN ['Covid Vaccinations'] cv
ON
cd.location = cv.location
AND
cd.date = cv.date;


-- Total population vs vaccination 

--Use CTE
WITH PopvsVac (continent,location,date,population,new_vaccinations,Rolling_Vaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Rolling_Vaccinated
FROM ['Covid Deaths'] dea
JOIN ['Covid Vaccinations'] vac
ON
dea.location = vac.location
AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT * , (Rolling_Vaccinated/population)*100 AS Rolling_Vaccinated_Percentage
FROM PopvsVac


-- Temp Table
--DROP TABLE IF EXISTS #Percent_Population_Vaccinated           (For Alteration)
CREATE TABLE #Percent_Population_Vaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
New_Vaccinations numeric, 
Rolling_Vaccinated numeric
)

INSERT INTO #Percent_Population_Vaccinated               --(Inserting data into temp table)
SELECT dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Rolling_Vaccinated
FROM ['Covid Deaths'] dea
JOIN ['Covid Vaccinations'] vac
ON
dea.location = vac.location
AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * , (Rolling_Vaccinated/population)*100 AS Rolling_Vaccinated_Percentage
FROM #Percent_Population_Vaccinated



-- Creating a view and storing data
CREATE VIEW Percent_Population_Vaccinated AS
SELECT dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS Rolling_Vaccinated
FROM ['Covid Deaths'] dea
JOIN ['Covid Vaccinations'] vac
ON
dea.location = vac.location
AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * FROM Percent_Population_Vaccinated;


