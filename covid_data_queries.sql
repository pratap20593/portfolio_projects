select distinct(location) from [dbo].[covid_deaths] order by location

select continent from [dbo].[covid_deaths] order by continent

ALTER TABLE [dbo].[covid_deaths] ALTER COLUMN  population float

select * from [dbo].[covid_vaccinations] order by 3,4

-- Looking for total cases,new cases and population

select location,date,total_cases,new_cases,population from [dbo].[covid_deaths] order by 1,2

-- Looking for death percentage compared with total cases

select location,date,total_cases,total_deaths, (total_deaths/nullif(total_cases,0))*100 as death_percentage  from [dbo].[covid_deaths] 
order by 2

-- Looking for what percentage of population got covid country wise

select location,population,max(total_cases) as highest_infected_count,(max(total_cases)/nullif(population,0))*100 as percentpopuinfected
from [dbo].[covid_deaths] group by location , population order by 1,2

-- Looking things by continent

select continent ,max(total_deaths) as totaldeathcount from [dbo].[covid_deaths] where continent is not null group by continent
order by totaldeathcount desc

-- create view

create view percentpopulationvaccinated 
as select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from [dbo].[covid_deaths] dea 
join [dbo].[covid_vaccinations] vac on dea.location=vac.location and dea.date=vac.date where dea.continent is not null