#selecting required info from the table
SELECT location, DATE, total_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2

#selecting InfectionRates
SELECT location, DATE, population, total_cases, (total_cases/population)*100 AS InfectionRates
FROM coviddeaths WHERE location LIKE '%india%'

#selecting DeathPercentage
SELECT location, DATE, population, total_cases, (Total_Deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths WHERE location LIKE '%india%'
ORDER BY deathpercentage DESC

#countries with highest Infection rates
SELECT location,population, MAX(total_cases) AS InfectionCount
FROM coviddeaths
GROUP BY location
ORDER BY InfectionCount DESC

#Counties with highest Death Count 
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE location not in ('world','international','European union')
GROUP BY location
ORDER BY TotalDeathCount DESC

#breakit by continents
#Death count by Continent
SELECT continent,population, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths WHERE continent != " "
GROUP BY continent
ORDER BY TotalDeathCount DESC


#global numbers  

SELECT continent, SUM(new_cases) AS TotalCases,SUM(new_deaths) AS TotalDeaths, (SUM(new_deaths)/SUM(new_cases))*100 AS percentage
FROM coviddeaths WHERE continent != " "
GROUP BY continent
ORDER BY percentage DESC

#death count by contenant per population
SELECT continent, Population, MAX(total_cases) AS totalcases
FROM coviddeaths WHERE continent != " "
GROUP BY continent
ORDER BY totalcases DESC

#total population vs. vaccination

#combining two tables
SELECT * FROM coviddeaths AS dea JOIN covidvaccination AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
    
#populations vs vaccines
SELECT dea.continent, dea.population,vac.new_vaccinations
FROM coviddeaths AS dea JOIN covidvaccination AS vac
ON dea.location = vac.location AND dea.date = vac.date
GROUP BY continent

SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY dea.location) AS PeaopleVaccinated
,
 FROM coviddeaths AS dea JOIN covidvaccination AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
    WHERE dea.continent != " "
    ORDER BY 2,3
 
#temp table

CREATE TABLE percentpopulationvaccinated
(continent VARCHAR(255),
location VARCHAR(255),
DATE DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
peoplevaccined NUMERIC
)

INSERT INTO percentpopulationvaccinated
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location) AS PeaopleVaccinated
,
 FROM coviddeaths AS dea JOIN covidvaccination AS vac
	ON dea.location = vac.location
    #AND dea.date = vac.date
    WHERE dea.continent != " "
    #ORDER BY 2,3
 SELECT *, (PeopleVaccinated/Population)*100
 FROM percentpopulationvaccinated

#Select PercentPopulationInfected

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
    
