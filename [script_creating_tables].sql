-- Create state_lookup table

CREATE TABLE state_lookup (
    State TEXT,
    State_ANSI INTEGER
);

-- Create cheese_production table
CREATE TABLE cheese_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);


-- Create honey_production table
CREATE TABLE honey_production (
    Year INTEGER,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Value INTEGER
);


-- Create milk_production table
CREATE TABLE milk_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);

-- Create coffee_production table
CREATE TABLE coffee_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Value INTEGER
);

-- Create egg_production table
CREATE TABLE egg_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Value INTEGER
);

-- Create yogurt_production table
CREATE TABLE yogurt_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);
