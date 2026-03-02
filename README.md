# Africa Gender & Youth Data Project

> M&E data analysis and reporting project for Africa gender & youth indicators | SQL · Python · Power BI

[![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python)](https://www.python.org/)
[![SQLite](https://img.shields.io/badge/SQL-SQLite-003B57?logo=sqlite)](https://www.sqlite.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi)](https://powerbi.microsoft.com/)

---

## Overview

This project is an end-to-end **Monitoring, Evaluation & Learning (MEL)** data pipeline built to track gender and youth indicators across African countries.

It demonstrates how raw survey and administrative data can be cleaned, loaded into an in-memory SQL database, queried with SQL, and visualised in Power BI to generate actionable insights for development programmes.

---

## Why This Project Exists

Development organisations working on gender equity and youth empowerment in Africa face a recurring challenge: data exists in silos; different formats, different countries, different years. This makes it hard to track progress against indicators like:

- Female labour force participation rate
- Youth unemployment (ages 15-35)
- Girls secondary school enrolment
- Women in decision-making positions

This tracker solves that by building a reproducible, auditable pipeline from raw data to a dashboard.

---

## Tools and Technologies

| Tool | Purpose |
|------|---------|
| Python (pandas, numpy) | Data cleaning and analysis |
| SQLite (via sqlite3) | In-memory SQL queries and analysis |
| Jupyter Notebooks | Reproducible analysis documentation |
| Power BI | Interactive dashboard and reporting |
| GitHub | Version control|

---

## Project Structure

```
africa-gender-youth-data-project/
|
|-- data/
|   |-- raw/              # Original CSV files (retrieved from the World Bank Open Data API)
|   |-- cleaned/          # Processed, analysis-ready datasets
|
|-- notebooks/
|   |-- 01_data_cleaning.ipynb       # Data ingestion, cleaning, standardisation
|   |-- 02_indicator_analysis.ipynb  # SQL queries via Python (sqlite3)
|   |-- 03_reporting_export.ipynb    # Summary tables and export for Power BI
|
|-- sql/
|   |-- analysis_queries.sql         # Standalone SQL query reference
|
|-- dashboard/
|   |-- 04_gender_youth_dashboard.pbix  # Power BI file
|   |-- dashboard_screenshot.png        # Dashboard preview
|
|-- README.md
```

---

## Data Sources

The datasets used in this project were retrieved from the World Bank Open Data API for all 54 African Union member states:

- `female_lfp_clean.csv` — Female labour force participation rate by country and year
- `girls_secondary_enrol_clean.csv` — Girls secondary school enrolment by country and year
- `women_in_parliament_clean.csv` — Women in national parliaments (%) by country and year
- `youth_unemployment_f_clean.csv` — Female youth unemployment rate by country and year
- `youth_unemployment_m_clean.csv` — Male youth unemployment rate by country and year

---

## Notebooks

### Notebook 01. Data Cleaning

What it does:

- Loads raw CSV files into pandas DataFrames
- Standardises column names, country codes, and year formats
- Handles missing values using forward-fill and regional median imputation
- Exports cleaned files to `data/cleaned/`

Key skills demonstrated: pandas, data quality checks, MEL data standardisation

---

### Notebook 02. Indicator Analysis

What it does:

- Loads all 5 cleaned CSVs into a SQLite in-memory database
- Runs 6 analytical SQL queries covering:
  1. Latest value snapshot per country per indicator
  2. Continental average trend over time (2015-2023)
  3. Regional rankings per indicator
  4. Top and bottom 5 performers — women in parliament
  5. Gender gap in youth unemployment by country
  6. Data completeness by region and indicator

Key skills demonstrated: SQLite, window functions, UNION queries, aggregation, subqueries

---

### Notebook 03. Reporting and Export

What it does:

- Loads all 5 cleaned indicator datasets
- Builds regional summary tables (avg, min, max per region)
- Combines into a master indicator report
- Exports individual indicator CSVs and master summary to `data/cleaned/exports/`

Key skills demonstrated: Data export pipeline, reporting automation, M&E indicator formatting

---

## Power BI Dashboard

![Dashboard Preview](dashboard/dashboard_screenshot.png)

The dashboard contains 4 key visuals:

| Visual | Description |
|--------|-------------|
| Women in Parliament by AU Region | Bar chart - average % of women in parliament per region |
| Female Labour Force Participation Trend | Line chart - FLP rate over time (2015-2023) by region |
| Gender Gap - Youth Unemployment by Country | Clustered bar - male vs female youth unemployment per country |
| Data Completeness by Indicator and Region | Matrix table - record counts per indicator per region |

Slicer: Year (2015-2023) - filters all visuals by reporting year.

---

## Key Findings

- **East Africa** leads on women in parliament (~28.6%), while West Africa is lowest (~16.8%)
- **North Africa** is a clear outlier on female labour force participation (~21.7% vs continental average of ~55%)
- **LBY (Libya)** shows the largest male-female youth unemployment gap (26.8 percentage points)
- Data completeness is **486 records per indicator** (54 countries × 9 years) across all 5 indicators

---

## How to Run This Project

### Prerequisites

```bash
pip install pandas numpy jupyter wbgapi
```

> No database setup required. Notebook 02 uses Python's built-in `sqlite3` module with an in-memory database.

### Steps

1. Clone this repository:

```bash
git clone https://github.com/TeresiahNjoroge/africa-gender-youth-data-project.git
cd africa-gender-youth-data-project
```

2. Launch Jupyter and run notebooks in order:

```
notebooks/01_data_cleaning.ipynb
notebooks/02_indicator_analysis.ipynb
notebooks/03_reporting_export.ipynb
```

3. Open Power BI Desktop and load CSVs from `data/cleaned/exports/`

---

## Alignment to AU WGYD Framework

| AU Priority Area | Indicator Tracked |
|-----------------|-------------------|
| Economic Empowerment | Female labour force participation rate |
| Political Participation | Women in national parliaments (%) |
| Education and Skills | Girls secondary school enrolment |
| Youth Employment | Youth unemployment rate (ages 15-35) |
| Integrated Reporting | Gender and Youth combined data completeness |

---

## About the Author

**Teresiah Njoroge** — Data Analyst | Nairobi, Kenya

Experienced in SQL, Python, and Power BI with a background in operations, project management, and data-driven reporting. Passionate about using data to drive evidence-based decisions in development, climate, and gender equity programmes.

- LinkedIn: [linkedin.com/in/teresiah-njoroge](https://linkedin.com/in/teresiah-njoroge)
- GitHub: [github.com/TeresiahNjoroge](https://github.com/TeresiahNjoroge)

---
