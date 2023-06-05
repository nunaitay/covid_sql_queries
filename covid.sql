    /*Data Exploration using COVID-19 data*/

-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

--Data was taken from ourworldindata.com and split into two tables: covid deaths and covid vaccinations

 --Before starting I converted data written in varchar or nvarchar that should be numeric in both tables (e.g. total_cases, new_vaccinations, etc.)
 --Use alter table table_name alter column column_name new_data_type
 --Example alter table deaths alter column total_cases float

 --To look at tables after importing data
 select *
 from deaths --table on covid deaths

 select * 
 from vaccine --table on covid vaccines

 --Total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
--I examined each country in North America

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from deaths
where location like '%states%'
order by 1, 2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from deaths
where location like 'Canada'
order by 1, 2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from deaths
where location like '%Mexico%'
order by 1, 2

--View of each query above

Create view USdeath_per as 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from deaths
where location like '%states%'

Create view Canadadeath_per as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from deaths
where location like 'Canada'

Create view Mexicodeath_per as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from deaths
where location like '%Mexico%'



--Total cases vs population
--shows percentage of population infected with covid

select location, date, population, total_cases,  (total_cases/population)* 100 as cases_percentage
from deaths
where location like '%states%'
order  by 1, 2

select location, date, population, total_cases, (total_cases/population)*100 as cases_percentage
from deaths 
where location = 'Canada'
order by 1,2

select location, date, population, total_cases, (total_cases/population)*100 as cases_percentage
from deaths 
where location = 'Mexico'
order by 1, 2

--View 

Create view TotalCasesPercentagebyUS as

select location, date, population, total_cases,  (total_cases/population)* 100 as cases_percentage
from deaths
where location like '%states%'
--order 1,2


Create view TotalCasesPercentageCanada as
select location, date, population, total_cases, (total_cases/population)*100 as cases_percentage
from deaths 
where location = 'Canada'
--order 1, 2 

Create view TotalCasesPercentageMexico as
select location, date, population, total_cases, (total_cases/population)*100 as cases_percentage
from deaths 
where location = 'Mexico'
--order 1,2



-- Countries with highest infection rate compared to population

select location, population, max(total_cases) as highestinfectioncount,
max((total_cases/population))* 100 as maxpercentpopulationinfection
from deaths
group by location, population
order by maxpercentpopulationinfection desc

--Countries with highest death count per population

select location,max(total_deaths) as total_deaths_count
from deaths
where continent is not null
group by location
order by total_deaths_count desc


--VIEW of previous 2 queries

create view Highestinfectioncount as
select location, population, max(total_cases) as highestinfectioncount,
max((total_cases/population))* 100 as maxpercentpopulationinfection
from deaths
group by location, population
--order by maxpercentpopulationinfection desc
 
 create view highest_death_count as
select location,max(total_deaths) as total_deaths_count
from deaths
where continent is not null
group by location
--order by total_deaths_count desc



-- BREAK DOWN BY CONTINENT

select location, max(total_deaths) as totaldeathcount
from deaths 
where continent is null
group by location
order by totaldeathcount desc

select location, max(total_cases) as totalcasescount
from deaths
where continent is null
group by location 
order by totalcasescount desc

--View

Create view death_count_continent as 
select location, max(total_deaths) as totaldeathcount
from deaths 
where continent is null
group by location
--totaldeathcount

create view total_cases_by_continent as
select location, max(total_cases) as totalcasescount
from deaths
where continent is null
group by location 
--order by totalcasescount desc

--Global numbers

select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases) * 100 as deathPercentage
from deaths
where continent is not null
group by date
order  by 1,2

select  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases) * 100 as deathPercentage
from deaths
where continent is not null
order by 1, 2


--Total cases by income

select location, max(total_cases) as totalcasescount
from deaths 
where continent is null AND location in ('low income', 'lower middle income', 'upper middle income', 'high income')
group by location
order by totalcasescount desc


--Total deaths by income 

select location, max(total_deaths) as totaldeathcount
from deaths 
where continent is null AND location in ('low income', 'lower middle income', 'upper middle income', 'high income')
group by location
order by totaldeathcount desc

--Total vaccinations by income

select location, max(total_vaccinations) as totalvacc
from vaccine  
where continent is null AND location in ('low income', 'lower middle income', 'upper middle income', 'high income')
group by location
order by totalvacc desc



--Views of global numbers

create view global_deaths as
select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases) * 100 as deathPercentage
from deaths
where continent is not null
group by date

Create view global_deaths_percent as 
select  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases) * 100 as deathPercentage
from deaths
where continent is not null


Create view cases_by_income as
select location, max(total_cases) as totalcasescount
from deaths 
where continent is null AND location in ('low income', 'lower middle income', 'upper middle income', 'high income')
group by location
--order by totalcasescount desc

create view deaths_by_income as
select location, max(total_deaths) as totaldeathcount
from deaths 
where continent is null AND location in ('low income', 'lower middle income', 'upper middle income', 'high income')
group by location
--order by totaldeathcount desc

create view vacc_by_income as
select location, max(total_vaccinations) as totalvacc
from vaccine  
where continent is null AND location in ('low income', 'lower middle income', 'upper middle income', 'high income')
group by location
--order by totalvacc desc



--Total population vs vaccinations
--Shows percentage of population that has recieved at least one covid vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeoplevaccinated
from deaths dea join vaccine vac
on dea.location =vac.location
and dea.date =vac.date 
where dea.continent is not null
order by 2,3


--USE CTE to perform calculation on by partition from previous query

WITH POPvsVAC (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated) 
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeoplevaccinated
from deaths dea join vaccine vac
on dea.location =vac.location
and dea.date =vac.date 
where dea.continent is not null
)
select *, (rollingpeoplevaccinated/population) * 100 as percent_vaccinated
from POPvsVAC

--temp table to perform calculation on partition by in previous query (different method)

DROP table if exists #percentpopvaccinated
create table #percentpopvaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #percentpopvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeoplevaccinated
from deaths dea join vaccine vac
on dea.location =vac.location
and dea.date =vac.date 
where dea.continent is not null


select *, (rollingpeoplevaccinated/population) * 100 as percent_vaccinated
from #percentpopvaccinated



Create view per_pop_vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeoplevaccinated
from deaths dea join vaccine vac
on dea.location =vac.location
and dea.date =vac.date 
where dea.continent is not null
--order by  2, 3 

select * from per_pop_vaccinated