# USDA Agricultural Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Exploratory Data Analysis EDA](#exploratory-data-analysis-eda)

## Project Overview

This analysis examines the performance and trends of six agricultural categories produced in the United States, focusing on their historical progression and potential correlations. The impact of each state's production was also taken into account. The data spans the years 1990 to 2022.

The following sections outline the steps taken during the analysis, including SQL queries and visualizations. You can also explore the findings interactively through the dashboard linked [here](https://public.tableau.com/app/profile/yassmin.ac/viz/USDAAgriculturalAnalysis/Milkdashboard).

![0  GIF](https://github.com/user-attachments/assets/34fac7ba-6bb5-49b6-b43d-1450731d5c47)

## Data Sources

The datasets used in this analysis were provided by the [USDA - United States Agriculture Department](https://quickstats.nass.usda.gov/) and curated by the University of California for its [Learn SQL Basics for Data Science Specialization](https://www.coursera.org/specializations/learn-sql-basics-data-science?irclickid=ziD0EF0QPxyKR-hzfcQ%3AWQJsUkCzueTdMQf7Rc0&irgwc=1&utm_medium=partners&utm_source=impact&utm_campaign=3637364&utm_content=b2c).

The datasets include: 'milk_production', 'cheese_production', 'coffee_production', 'honey_production', 'yogurt_production', and a 'state_lookup' table. The data spans multiple years and states, with varying production levels for each commodity.

## Tools

- MS Excel - Data Cleaning
- SQLite / DBeaver - Data Analysis
- Tableau - Creating Reports

## Data Cleaning and Preparation

### 1. Getting familiar with the datasets

The data loading and inspection provided me with the following information:

- The ‘state_lookup’ dataset brings each state’s name and its correspondent code (State_ANSI)
- The other 5 datasets bring each product category and its corresponding total production, divided by year and state. The column “State_ANSI” was used as a primary key to correlate all the datasets.

### 2. Creating Tables

After downloading and preprocessing the .csv files, I developed scripts to create and populate tables in SQL. I then ran queries to remove commas from the data, ensuring that all INTEGER values functioned correctly. I've included below a sample of one of the tables; for the complete set, please look at the repository's files.

Creating the milk_production table:

```sql
CREATE TABLE milk_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);
```

Removing the commas from the milk_production table:

```sql
UPDATE milk_production SET value = REPLACE(value, ',', '');
```

## Exploratory Data Analysis EDA

The major objectives of the exploratory analysis were to:

- Determine the significance of each of the 6 product categories to the country.
- Assess state-by-state production for each commodity.
- Identify trends or anomalies.
- Highlight areas that may require more attention.

### General Analysis

The first step was to compare the total production of each category between 1990 and 2022.

```sql
SELECT 
  (SELECT SUM(mp."Value") FROM milk_production mp WHERE mp."Year" >= 1990 AND mp."Year" <= 2022) AS SUM_Milk_Production
  ,(SELECT SUM(ep."Value") FROM egg_production ep WHERE ep."Year" >= 1990 AND ep."Year" <= 2022) AS SUM_Egg_Production
  ,(SELECT SUM(cp."Value") FROM cheese_production cp WHERE cp."Year" >= 1990 AND cp."Year" <= 2022) AS SUM_Cheese_Production
  ,(SELECT SUM(yp."Value") FROM yogurt_production yp WHERE yp."Year" >= 1990 AND yp."Year" <= 2022) AS SUM_Yogurt_Production
  ,(SELECT SUM(hp."Value") FROM honey_production hp WHERE hp."Year" >= 1990 AND hp."Year" <= 2022) AS SUM_Honey_Production
  ,(SELECT SUM(co."Value") FROM coffee_production co WHERE co."Year" >= 1990 AND co."Year" <= 2022) AS SUM_Coffee_Production;
```

![1](https://github.com/user-attachments/assets/d26a263b-a312-4d96-93a5-e5f4ad1abb56)

#### Insight

*Milk leads the production ranking, accounting for nearly three times the combined output of the other six categories. Therefore, I decided to conduct a specific analysis of milk and its derivatives cheese and yogurt.*

### Trends Over Time

The next step was to analyze the growth trends of each dairy product over the years. Queries were executed to compare the total production in 1990 and 2022.

- Milk:

```sql
SELECT "Year"
,SUM("Value")
FROM milk_production mp 
WHERE "Year" IN (1990, 2022)
GROUP BY "Year";
```

![8  Growing Milk](https://github.com/user-attachments/assets/a1bfa1f0-4d41-4976-a79d-b456b3f40e5d)

- Cheese:
```sql
SELECT "Year"
,SUM("Value")
FROM cheese_production cp 
WHERE "Year" IN (1990, 2022)
GROUP BY "Year";
```

![10  Growing Cheese](https://github.com/user-attachments/assets/634f1ded-b43c-428a-bd13-10eb637a700c)

- Yogurt:
```sql
SELECT "Year"
,SUM("Value")
FROM yogurt_production yp 
WHERE "Year" IN (1990, 2022)
GROUP BY "Year";
```

![12  Growing Yogurt](https://github.com/user-attachments/assets/61126cd0-cf2f-4666-ba11-10ee3be13e2f)

#### Insight

*After identifying growth across the three categories from 1990 to 2022, I conducted a year-by-year analysis of this trend using line charts.*

![Side-by-side_Line Charts](https://github.com/user-attachments/assets/6275ebaa-1d16-4f9d-bfdc-8c8fdc5d3047)

#### Insight

*While milk and cheese exhibited consistent growth over the years, yogurt experienced fluctuations and has recently begun to recover from its decline in 2014, which followed its peak in 2009.*

### State-by-state production

The next task is to analyze the contribution of each state to national production.

- Milk:

```sql
SELECT 
mp."State_ANSI"
,sl."State"
,SUM(mp."Value") AS Total_Milk_Production
FROM 
milk_production mp
INNER JOIN 
state_lookup sl  ON mp."State_ANSI" = sl."State_ANSI"
WHERE mp."Year" >= 1990 AND mp."Year" <= 2022
GROUP BY mp."State_ANSI"
ORDER BY Total_Milk_Production DESC
LIMIT 5;
```

- Cheese:

```sql
SELECT 
cp."State_ANSI"
,sl."State"
,SUM(cp."Value") AS Total_Cheese_Production
FROM 
cheese_production cp 
INNER JOIN 
state_lookup sl  ON cp."State_ANSI" = sl."State_ANSI"
WHERE cp."Year" >= 1990 AND cp."Year" <= 2022
GROUP BY cp."State_ANSI"
ORDER BY Total_Cheese_Production DESC;
```

- Yogurt:

```sql
SELECT 
cp."State_ANSI"
,sl."State"
,SUM(cp."Value") AS Total_Cheese_Production
FROM 
cheese_production cp 
INNER JOIN 
state_lookup sl  ON cp."State_ANSI" = sl."State_ANSI"
WHERE cp."Year" >= 1990 AND cp."Year" <= 2022
GROUP BY cp."State_ANSI"
ORDER BY Total_Cheese_Production DESC;
```
