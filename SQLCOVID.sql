SELECT *
FROM [dbo].[CovidDeaths]
ORDER BY 3,4

--SELECT *
--FROM [dbo].[CovidVaccinations]
--ORDER BY 3,4

--SELECT THE DATA WE WILL NEED

SELECT  [location],
		[date],
		[total_deaths],
		(total_deaths/total_cases) * 100 AS Death_Percentage

FROM	[dbo].[CovidDeaths]

ORDER BY 1,2 

--Looking at Total Cases Vs Total Deaths


SELECT *
From PortfolioProject..CovidDeaths dea
WHERE continent is not null
Order by 3,4  

SELECT *
From PortfolioProject..CovidDeaths deav
Order by 3,4 


SELECT Location,total_cases,new_cases,total_deaths, population
FROM   PortfolioProject..CovidDeaths dea
ORDER BY 1,2

SELECT Location, Population, (total_cases/Population) * 100 as DeathPercentage
FROM	PortfolioProject..CovidDeaths dea	 
WHERE location like '%states%'
ORDER BY 1,2

--Looking at  with highest infection rate compared to population.


SELECT	Location,
		Population,
		MAX(total_cases)  as HighestInfectionCount, 
		MAX(total_cases/population) * 100 as PercentPopulationInfected
FROM	 PortfolioProject..CovidDeaths de
--WHERE location like '%states%'
GROUP BY Location,
		 Population
ORDER BY PercentPopulationInfected desc

--Showing Countries with Highest death count by population.

SELECT Location,	
MAX(CAST(total_deaths as INT)) as TotalDeathCount
FROM	 PortfolioProject..CovidDeaths dea
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--Breaking Things Down By Continent

SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeathCount
FROM	 PortfolioProject..CovidDeaths de
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Showing continets with highest Death Count per Population

SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeathCount
FROM	 PortfolioProject..CovidDeaths de
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS

SELECT  SUM(new_cases) as totalcases, 
		SUM(cast(new_deaths as int)) as TotalDeaths , 
		SUM(cast(new_deaths as INT))/SUM(new_Cases) * 100  as DeathPercentage
FROM	 PortfolioProject..CovidDeaths dea
WHERE continent IS NOT NULL 
--Group By date
ORDER BY 1,2

--Looking at Total Population vs Vaccinations

With PopvsVac (Continent, Location,Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
	)
SELECT *
FROM PopvsVac


	
	 --USE OF CTE


	With PopvsVac (Continent, Location,Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL 
	)
SELECT *, (RollingPeopleVaccinated/Population) *100
FROM PopvsVac

	
	
	--Temp Table
	
	
	
	Create Table #PercentPopulationVaccinated2
	(
	Continet nvarchar(255),
	Location nvarchar(225),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--order by 2,3


	SELECT *, (RollingPeopleVaccinated/Population) *100
	FROM #PercentPopulationVaccinated


	--Creating View to store data for later Data Vizs.

	CREATE VIEW PercentPopulationVaccinated1 AS 
	SELECT dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent is not null
	--ORDER BY 2,3

	SELECT *
	FROM [dbo].[PercentPopulationVaccinated]
