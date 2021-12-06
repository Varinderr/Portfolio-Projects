#creating coviddeaths table

CREATE TABLE IF NOT EXISTS `coviddeaths` (
`iso_code` VARCHAR(200) NULL,
`continent` VARCHAR(200) NULL,
`location` VARCHAR(200) NULL,
`date` VARCHAR(200) NULL,
`total_cases` VARCHAR(200) NULL,
`new_cases` VARCHAR(200) NULL,
`new_cases_smoothed` VARCHAR(200) NULL,
`total_deaths` VARCHAR(200) NULL,
`new_deaths` VARCHAR(200) NULL,
`new_deaths_smoothed` VARCHAR(200) NULL,
`total_cases_per_million` VARCHAR(200) NULL,
`new_cases_per_million` VARCHAR(200) NULL,
`new_cases_smoothed_per_million` VARCHAR(200) NULL,
`total_deaths_per_million` VARCHAR(200) NULL,
`new_deaths_per_million` VARCHAR(200) NULL,
`new_deaths_smoothed_per_million` VARCHAR(200) NULL,
`reproduction_rate` VARCHAR(200) NULL,
`icu_patients` VARCHAR(200) NULL,
`icu_patients_per_million` VARCHAR(200) NULL,
`hosp_patients` VARCHAR(200) NULL,
`hosp_patients_per_million` VARCHAR(200) NULL,
`weekly_icu_admissions` VARCHAR(200) NULL,
`weekly_icu_admissions_per_million` VARCHAR(200) NULL,
`weekly_hosp_admissions` VARCHAR(200) NULL,
`weekly_hosp_admissions_per_million` VARCHAR(200) NULL,
`new_tests` VARCHAR(200) NULL);

#create 'covidvaccination' table

CREATE TABLE IF NOT EXISTS `covid19` (
`iso_code` VARCHAR(200) NULL,
`continent` VARCHAR(200) NULL,
`location` VARCHAR(200) NULL,
`date` VARCHAR(200) NULL,
`new_tests` VARCHAR(200) NULL,
`total_tests` VARCHAR(200) NULL,
`total_tests_per_thousand` VARCHAR(200) NULL,
`new_tests_per_thousand` VARCHAR(200) NULL,
`new_tests_smoothed` VARCHAR(200) NULL,
`new_tests_smoothed_per_thousand` VARCHAR(200) NULL,
`positive_rate` VARCHAR(200) NULL,
`tests_per_case` VARCHAR(200) NULL,
`tests_units` VARCHAR(200) NULL,
`total_vaccinations` VARCHAR(200) NULL,
`people_vaccinated` VARCHAR(200) NULL,
`people_fully_vaccinated` VARCHAR(200) NULL,
`total_boosters` VARCHAR(200) NULL,
`new_vaccinations` VARCHAR(200) NULL,
`new_vaccinations_smoothed` VARCHAR(200) NULL,
`total_vaccinations_per_hundred` VARCHAR(200) NULL,
`people_vaccinated_per_hundred` VARCHAR(200) NULL,
`people_fully_vaccinated_per_hundred` VARCHAR(200) NULL,
`total_boosters_per_hundred` VARCHAR(200) NULL,
`new_vaccinations_smoothed_per_million` VARCHAR(200) NULL,
`stringency_index` VARCHAR(200) NULL,
`population` VARCHAR(200) NULL,
`population_density` VARCHAR(200) NULL,
`median_age` VARCHAR(200) NULL,
`aged_65_older` VARCHAR(200) NULL,
`aged_70_older` VARCHAR(200) NULL,
`gdp_per_capita` VARCHAR(200) NULL,
`extreme_poverty` VARCHAR(200) NULL,
`cardiovasc_death_rate` VARCHAR(200) NULL,
`diabetes_prevalence` VARCHAR(200) NULL,
`female_smokers` VARCHAR(200) NULL,
`male_smokers` VARCHAR(200) NULL,
`handwashing_facilities` VARCHAR(200) NULL,
`hospital_beds_per_thousand` VARCHAR(200) NULL,
`life_expectancy` VARCHAR(200) NULL,
`human_development_index` VARCHAR(200) NULL,
`excess_mortality_cumulative_absolute` VARCHAR(200) NULL,
`excess_mortality_cumulative` VARCHAR(200) NULL,
`excess_mortality` VARCHAR(200) NULL,
`excess_mortality_cumulative_per_million` VARCHAR(200) NULL
);

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
    
