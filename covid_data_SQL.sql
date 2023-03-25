--selecting and viewing the tables
--ordering the data according to location and date 
select*
from dbo.covid_deaths
order by 3,4

select*
from dbo.covid_vaccinations
order by 3,4 

--selecting some of the data to provide some context
select location, date, population, total_cases, total_deaths
from ..covid_deaths
order by 1,2

--finding a relation between cases and deaths 
select location,  date,population, total_deaths , total_cases,round((cast(total_deaths as float)/cast(total_cases as float))*100,1)   as DeathPercentage 
from ..covid_deaths
order by 1,2
--Egypt's death percentage 
select location,  date,population, total_cases , total_deaths,round((cast(total_deaths as float)/cast(total_cases as float))*100,1)   as DeathPercentage 
from ..covid_deaths
where location = 'egypt'
order by 1,2


--finding a relation between total cases and population 
select location, date, population, total_cases, round((cast(total_cases as float)/cast(population as float))*100,1)   as Infection_Percentage
from ..covid_deaths
where continent is not null 
order by 1,2
--finding the infection percentage for egypt
select location, date, population, total_cases, round((cast(total_cases as float)/cast(population as float))*100,1)   as Infection_Percentage
from ..covid_deaths
where continent is not null and location = 'egypt'
order by 1,2

--finding the highest cases count and percentage of population 
select location,population, max(cast(total_cases as int)) as Highest_cases_count, max(round((cast(total_cases as float)/cast(population as float))*100,1))   as Highest_infection_percentage
from ..covid_deaths
group by location, population
order by 4 desc 

--finding the highest deaths count and percentage of population 
select location,population, max(cast(total_deaths as int)) as Highest_deaths_count, max(round((cast(total_deaths as float)/cast(population as float))*100,1))   as Highest_deaths_percentage
from ..covid_deaths
where continent is not null 
group by location, population
order by 4 desc

--finding the continent with the highest deaths count
select continent, max(cast(total_deaths as int)) as Highest_deaths_count
from ..covid_deaths
where continent is not null 
group by continent

--diving into vaccination data 
--finding a relation between population and vaccination counts 
--first, joining the data from the two tables 
select*
from ..covid_deaths d
join ..covid_vaccinations v
	on d.location = v.location 
	and d.date = v.date 
order by 3,4 

--relation between popuation and vaccination
select d.continent, d.location, d.date, d.population, v.new_vaccinations
from ..covid_deaths d
join ..covid_vaccinations v
	on d.location = v.location 
	and d.date = v.date 
order by 2,3 

select d.location, d.date, d.population, v.new_vaccinations, sum(cast(v.new_vaccinations as int))
from ..covid_deaths d
join ..covid_vaccinations v
	on d.location = v.location 
	and d.date = v.date 
order by 2,3 


Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ..covid_deaths d
Join ..covid_vaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
order by 2,3

--using CTE to find relation between population and vaccination counts 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated

From ..covid_deaths d
Join ..Covid_Vaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 

)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--preparing a 'view' for visualization
Create View PercentPopulationVaccinated_view as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From ..covid_deaths d
Join ..Covid_Vaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 





