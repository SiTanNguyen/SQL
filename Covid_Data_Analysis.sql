SELECT *
FROM [Portfolio Project].dbo.CovidDeath
WHERE continent is not null

--SELECT *
--FROM [Portfolio Project].dbo.CovidVaccinate

SELECT location, date,	total_cases,new_cases,total_deaths,population_density
FROM [Portfolio Project].dbo.CovidDeath
ORDER BY 1,2

-- Total cases and total death
SELECT location, date,	total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercent
FROM [Portfolio Project].dbo.CovidDeath
WHERE location like '%states%'
ORDER BY 1,2



-- Show percentage of population got Covid
SELECT location, population_density, total_cases,(total_cases/population_density)*100 as Maxeffect
FROM [Portfolio Project].dbo.CovidDeath


-- Highest Death count
SELECT location ,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project].dbo.CovidDeath
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Global Number
SELECT date, SUM(total_cases)as totalcases,
SUM(cast (new_deaths as int)) as totaldeath,
SUM(cast (new_deaths as int))*100/SUM(new_cases) as deathpercentage
FROM [Portfolio Project].dbo.CovidDeath
WHERE continent is not null
GROUP BY date
ORDER By 1,2



--total vacination vs population
SELECT d.continent,d.location,d.date,d.population_density,v.new_people_vaccinated_smoothed, 
SUM(cast(v.new_people_vaccinated_smoothed as int)) OVER (Partition by d.location ORDER BY d.location ,d.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/d.population_density)*100
FROM [Portfolio Project].dbo.CovidDeath d
 JOIN [Portfolio Project].dbo.CovidVaccinate v
 ON d.date=v.date and d.location=v.location
WHERE d.continent is not null 
ORDER BY 1,2,3


--CTE
WITH PopvsVac (continent,location,date,population,new_people_vaccinated_smoothed,RollingPeopleVaccinated)
as(SELECT d.continent,d.location,d.date,d.population_density,v.new_people_vaccinated_smoothed, 
SUM(cast(v.new_people_vaccinated_smoothed as int)) OVER (Partition by d.location ORDER BY d.location ,d.date) as RollingPeopleVaccinated
--
FROM [Portfolio Project].dbo.CovidDeath d
 JOIN [Portfolio Project].dbo.CovidVaccinate v
	ON d.date=v.date and d.location=v.location
WHERE d.continent is not null 
)
SELECT *,(RollingPeopleVaccinated/population)*100
FROM PopvsVac