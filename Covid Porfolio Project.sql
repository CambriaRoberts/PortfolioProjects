--Select *
--From Porfolio..CovidDeaths
--order by 3,4

--Select *
--From Porfolio..CovidDeaths
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Porfolio..CovidDeaths
order by 1,2


--Total Cases vs Total deaths
Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Porfolio..CovidDeaths
where location like '%states%'
order by 1,2

--Total Cases vs Population
Select Location, date, Population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
From Porfolio..CovidDeaths
where location like '%states%'
order by 1,2

--Countries with the highest infection rate compared to the population
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From Porfolio..CovidDeaths
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Visual of countries with the Highest Death Count per Population 
Select Location, MAX(cast(Total_Deaths as bigint)) as TotalDeathCount
From Porfolio..CovidDeaths
--where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--Global Numbers
Select date, SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as bigint)) as Total_Deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
From Porfolio..CovidDeaths
--where location like '%states%'
where continent is not null
Group by date
order by 1,2

--Total Population vs Total Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated 
From Porfolio..CovidDeaths dea
Join Porfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated 
From Porfolio..CovidDeaths dea
Join Porfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp Table
DROP Table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
--Total Population vs Total Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated 
From Porfolio..CovidDeaths dea
Join Porfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating a View to store later for visualizations

Use [Porfolio]

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated 
From Porfolio..CovidDeaths dea
Join Porfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


-- 1. 

Select SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as bigint)) as Total_Deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
From Porfolio..CovidDeaths
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2

--2. 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount 
From Porfolio..CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in ('World','European Union','International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

--3.

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From Porfolio..CovidDeaths
--Where location like '%states%'
Group by Location, population
order by PercentPopulationInfected desc


--4.


Select Location, Population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From Porfolio..CovidDeaths
--Where location like '%states%'
Group by Location, population, date
order by PercentPopulationInfected desc

