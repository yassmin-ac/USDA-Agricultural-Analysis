# USDA Agricultural Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning and Preparation](#data-cleaning-andpreparation)

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

## Exploratory Data Analysis (EDA)

The major objectives of the exploratory analysis were to:

- Determine the significance of each of the 6 product categories to the country.
- Assess state-by-state production for each commodity.
- Identify trends or anomalies.
- Highlight areas that may require more attention.
