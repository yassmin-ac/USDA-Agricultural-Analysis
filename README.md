# USDA Agricultural Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Exploratory Data Analysis EDA](#exploratory-data-analysis-eda)
  - [General Analysis](#general-analysis)
  - [Trends Over Time](#trends-over-time)
  - [State by State Production](#state-by-state-production)
  - [Leading States and Their Best Performing Years](#leading-states-and-their-best-performing-years)
- [Insights and Interpretations](#insights-and-interpretations)
- [Data Visualization](#data-visualization)
- [Limitations](#limitations)

## Project Overview

This analysis examines the performance and trends of six agricultural categories produced in the United States, focusing on their historical progression and potential correlations. The impact of each state's production was also taken into account. The data spans the years 1990 to 2022.

The following sections outline the steps taken during the analysis, including SQL queries and Tableau visualizations. You can also explore the findings interactively through the dashboard linked [here](https://public.tableau.com/app/profile/yassmin.ac/viz/USDAAgriculturalAnalysis/Milkdashboard).

![0  GIF](https://github.com/user-attachments/assets/34fac7ba-6bb5-49b6-b43d-1450731d5c47)

## Data Sources

The datasets used in this analysis were provided by the [USDA - United States Agriculture Department](https://quickstats.nass.usda.gov/) and curated by the University of California for its [Learn SQL Basics for Data Science Specialization](https://www.coursera.org/specializations/learn-sql-basics-data-science?irclickid=ziD0EF0QPxyKR-hzfcQ%3AWQJsUkCzueTdMQf7Rc0&irgwc=1&utm_medium=partners&utm_source=impact&utm_campaign=3637364&utm_content=b2c).

The datasets include: 'milk_production.csv', 'cheese_production.csv', 'coffee_production.csv', 'honey_production.csv', 'yogurt_production.csv', and 'state_lookup.csv'. The data spans multiple years and states, with varying production levels for each commodity.

## Tools

- MS Excel - Data Cleaning
- SQLite / DBeaver - Data Analysis
- Tableau - Creating Data Visualization and Reports

## Data Cleaning and Preparation

### 1. Getting familiar with the datasets

The data loading and inspection provided me with the following information:

- The ‘state_lookup’ dataset brings each state’s name and its correspondent code (State_ANSI).
- The other 6 datasets bring each product category and its corresponding total production, divided by year and state. The column “State_ANSI” was used as a primary key to correlate all the datasets.

### 2. Creating Tables

After downloading and preprocessing the .csv files, I developed scripts to create and populate tables in SQL. I then ran queries to remove commas from the data, ensuring that all the INTEGER values functioned correctly. I've included below a table sample; for the complete set, please look at the scripts on the repository's files.

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
- Assess state by state production for each commodity.
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

### State by State Production

The next task was to analyze the contribution of each state to the national production.

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

![SbS Milk States](https://github.com/user-attachments/assets/1579d1ff-4704-410c-a58e-e10fab635005)


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

![SbS Cheeese States](https://github.com/user-attachments/assets/9ee42bf3-1d65-45f3-97b0-a7470017e58e)


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

![SbS Yogurt States](https://github.com/user-attachments/assets/eaacfc92-8cbb-410b-890e-a564fe077fa2)

#### Insight

*The three categories identify California, Wisconsin, and New York as the top states. Next, I took a closer look at each of these states.*

### Leading States and Their Best Performing Years

The last step was to analyze the top five performing years for milk in each state to assess whether the most recent years are the best and to identify any significant discrepancies among those years.

- California

Milk:

```sql
SELECT "Year"
,SUM("Value") AS Total_Milk_Production_California
FROM milk_production mp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 6
GROUP BY "Year"
ORDER BY "Total_Milk_Production_California" DESC
LIMIT 5;
```

Cheese:

```sql
SELECT "Year"
,SUM("Value") AS Total_Cheese_Production_California
FROM cheese_production cp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 6
GROUP BY "Year"
ORDER BY Total_Cheese_Production_California DESC
LIMIT 5;
```

Yogurt:

```sql
SELECT "Year"
,SUM("Value") AS Total_Yogurt_Production_California
FROM yogurt_production yp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 6
GROUP BY "Year"
ORDER BY Total_Yogurt_Production_California DESC
LIMIT 5;
```

![SbS Leading California](https://github.com/user-attachments/assets/76230c0d-df9c-466d-95c1-15ff37a2405c)

#### California's Insight

*Milk's strongest year was 2014, with production approximately one billion dollars higher than in 2022.*

*Cheese production peaked in 2018, and the decline in 2022 is not significant.*

*Yogurt peaked in 2009, and 2022 is not one of its top-performing years. The 13-year gap between its best year and the most recent performance warrants further attention.*

- Wisconsin

Milk:

```sql
SELECT "Year"
,SUM("Value") AS Total_Milk_Production_Wisconsin
FROM milk_production mp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 55
GROUP BY "Year"
ORDER BY Total_Milk_Production_Wisconsin DESC
LIMIT 5;
```

Cheese:

```sql
SELECT "Year"
,SUM("Value") AS Total_Cheese_Production_Wisconsin
FROM cheese_production cp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 55
GROUP BY "Year"
ORDER BY Total_Cheese_Production_Wisconsin DESC
LIMIT 5;
```

Yogurt:

```sql
SELECT "Year"
,SUM("Value") AS Total_Yogurt_Production_Wisconsin
FROM yogurt_production yp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 55
GROUP BY "Year"
ORDER BY Total_Yogurt_Production_Wisconsin DESC
LIMIT 5;
```

![SbS Leading Wisconsin](https://github.com/user-attachments/assets/45bbb243-a2f1-48af-976d-e5aa768bfd5d)

#### Wisconsin's Insight

*Milk experienced its best performance in 2022, following a trend of consistent growth in the preceding years.*

*The cheese production saw a slight decline after 2018, but rebounded in 2021 and reached its peak in 2022.*

*Yogurt, in contrast, peaked in 2009, and 2022 is not among its strongest years. The 13-year gap between its highest performance and the present performance requires further attention.*

- New York

Milk:

```sql
SELECT "Year"
,SUM("Value") AS Total_Milk_Production_NewYork
FROM milk_production mp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 36
GROUP BY "Year"
ORDER BY Total_Milk_Production_NewYork DESC
LIMIT 5;
```

Cheese:

```sql
SELECT "Year"
,SUM("Value") AS Total_Cheese_Production_NewYork
FROM cheese_production cp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 36
GROUP BY "Year"
ORDER BY Total_Cheese_Production_NewYork DESC
LIMIT 5;
```

Yogurt:

```sql
SELECT "Year"
,SUM("Value") AS Total_Yogurt_Production_NewYork
FROM yogurt_production yp 
WHERE "Year" >= 1990 AND "Year" <= 2022 AND "State_ANSI" = 36
GROUP BY "Year"
ORDER BY Total_Yogurt_Production_NewYork DESC
LIMIT 5;
```

![SbS Leading New York](https://github.com/user-attachments/assets/a0758b1f-07c5-4bd9-a90a-f50cbd6e8e4d)

#### New York' Insight

*Milk's best-performing year was 2022, following consistent growth in the preceding years, except for 2018, when it did not rank among the top five years.*

*Cheese reached its peak in 2020 but experienced a decline in both 2021 and 2022.*

*Yogurt saw its best performance in 2022, with steady growth in prior years, except for 2019, when it failed to make the top five.*

## Insights and Interpretations

The total production from 1990 to 2022 indicates that milk dominated the rankings, accounting for nearly three times the combined output of the other five categories. A national analysis of milk and its derivatives—cheese and yogurt—revealed that all three categories experienced a general growth. While milk and cheese showed consistent growth over the years, yogurt experienced fluctuations but has recently begun to recover from its decline since peaking in 2009.

The leading states for production in these categories are California, Wisconsin, and New York.

Areas of concern regarding the three leading states:

1. **California:** Milk's peak year was 2014, with production nearly one billion dollars higher than in 2022, indicating a need for support. Additionally, yogurt production in California has a significant 13-year gap between its best year in 2009 and its most recent performance, which warrants further investigation.
2. **Wisconsin:** Similarly, yogurt production in Wisconsin peaked in 2009, and 2022 was not among its top-performing years, also resulting in a 13-year gap. The challenges faced by both states may be interconnected.
3. **New York:** In contrast, New York’s yogurt production has shown the most progress since 2008, offering an interesting comparison with California and Wisconsin. However, cheese production in New York requires attention due to declines in both 2021 and 2022.

## Data Visualization

![0  Dashboard png](https://github.com/user-attachments/assets/f87b6ba4-5275-470f-adbb-eed1e58cacff)

To present the findings, I created an interactive Tableau dashboard where you can easily select and explore the specific information you need.
Click [here](https://public.tableau.com/app/profile/yassmin.ac/viz/USDAAgriculturalAnalysis/Milkdashboard) to interact with the dashboard, following the instructions below.

- Section 1
The first section displays data for each dairy category. You can switch between categories by clicking on the tabs, which will show a map highlighting the states where each product is produced. States with higher production are shaded in darker colors. Hovering over a state reveals a tooltip displaying its total production from 1990 to 2022.

![Demonstration 1](https://github.com/user-attachments/assets/55737122-0644-4882-83c1-cd8006bb8133)

- Section 2
The second section highlights the best-performing states and their top five production years for each of the three selected categories.

![Demonstration 2](https://github.com/user-attachments/assets/53648236-5bd4-4874-950e-14bf2ff95fc4)

- Section 3
In the third section, clicking on a state on the map will update the line charts for each category, showing the production trends in that state over time.

![Demonstration 3](https://github.com/user-attachments/assets/5037d282-3fb1-4baa-89df-c173473fd7f7)

## Limitations
Excluding the 2023 data from the analysis was necessary due to the unavailability of complete information for that year.
