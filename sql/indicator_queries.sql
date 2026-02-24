-- ============================================================
-- Africa Gender & Youth Indicators — M&E Analytical Queries
-- AU WGYD Data Pipeline | Author: Teresiah Njoroge | Feb 2026
-- ============================================================
-- These queries support evidence-based reporting for the AU
-- Women, Gender & Youth Directorate (WGYD) continental M&E
-- framework, aligned with Agenda 2063 targets.
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Latest available value per country per indicator
-- Use case: Populate current status in dashboard scorecards
-- ------------------------------------------------------------
SELECT
    country_code,
    au_region,
    indicator,
    year            AS latest_year,
    ROUND(value, 2) AS latest_value,
    quality_flag
FROM cleaned_indicators ci
WHERE quality_flag = 'VERIFIED'
AND year = (
    SELECT MAX(year)
    FROM cleaned_indicators
    WHERE country_code = ci.country_code
    AND   indicator    = ci.indicator
    AND   quality_flag = 'VERIFIED'
)
ORDER BY indicator, au_region, country_code;


-- ------------------------------------------------------------
-- QUERY 2: Continental average per indicator per year
-- Use case: Track continental-level progress over time
-- ------------------------------------------------------------
SELECT
    indicator,
    year,
    ROUND(AVG(value), 2)                        AS continental_avg,
    COUNT(value)                                AS countries_reporting,
    COUNT(*)                                    AS total_countries,
    ROUND(COUNT(value) * 100.0 / COUNT(*), 1)   AS completeness_pct
FROM cleaned_indicators
WHERE quality_flag = 'VERIFIED'
GROUP BY indicator, year
ORDER BY indicator, year;


-- ------------------------------------------------------------
-- QUERY 3: Regional averages — latest year only
-- Use case: Regional comparison charts and reports
-- ------------------------------------------------------------
SELECT
    indicator,
    au_region,
    ROUND(AVG(value), 2)    AS regional_avg,
    COUNT(value)            AS countries_reporting,
    MAX(year)               AS latest_year
FROM cleaned_indicators
WHERE quality_flag = 'VERIFIED'
GROUP BY indicator, au_region
ORDER BY indicator, regional_avg DESC;


-- ------------------------------------------------------------
-- QUERY 4: Top 5 and Bottom 5 — women in parliament
-- Use case: Identify leaders and laggards for policy briefings
-- ------------------------------------------------------------
SELECT * FROM (
    SELECT
        country_code,
        au_region,
        year,
        ROUND(value, 2)     AS women_in_parliament_pct,
        'Top Performer'     AS category
    FROM cleaned_indicators
    WHERE indicator    = 'women_in_parliament'
    AND   quality_flag = 'VERIFIED'
    AND   year = (
        SELECT MAX(year)
        FROM cleaned_indicators
        WHERE indicator    = 'women_in_parliament'
        AND   quality_flag = 'VERIFIED'
    )
    ORDER BY value DESC
    LIMIT 5
)

UNION ALL

SELECT * FROM (
    SELECT
        country_code,
        au_region,
        year,
        ROUND(value, 2)     AS women_in_parliament_pct,
        'Needs Support'     AS category
    FROM cleaned_indicators
    WHERE indicator    = 'women_in_parliament'
    AND   quality_flag = 'VERIFIED'
    AND   year = (
        SELECT MAX(year)
        FROM cleaned_indicators
        WHERE indicator    = 'women_in_parliament'
        AND   quality_flag = 'VERIFIED'
    )
    ORDER BY value ASC
    LIMIT 5
);


-- ------------------------------------------------------------
-- QUERY 5: Gender gap in youth unemployment
-- Use case: Measure disparity between female and male youth
-- ------------------------------------------------------------
SELECT
    f.country_code,
    f.au_region,
    f.year,
    ROUND(f.value, 2)           AS female_unemployment,
    ROUND(m.value, 2)           AS male_unemployment,
    ROUND(f.value - m.value, 2) AS gender_gap,
    CASE
        WHEN f.value > m.value THEN 'Female disadvantaged'
        WHEN f.value < m.value THEN 'Male disadvantaged'
        ELSE 'Parity'
    END                         AS gap_direction
FROM cleaned_indicators f
JOIN cleaned_indicators m
    ON  f.country_code = m.country_code
    AND f.year         = m.year
WHERE f.indicator    = 'youth_unemployment_f'
AND   m.indicator    = 'youth_unemployment_m'
AND   f.quality_flag = 'VERIFIED'
AND   m.quality_flag = 'VERIFIED'
AND   f.year = (
    SELECT MAX(year)
    FROM cleaned_indicators
    WHERE indicator    = 'youth_unemployment_f'
    AND   quality_flag = 'VERIFIED'
)
ORDER BY ABS(f.value - m.value) DESC;


-- ------------------------------------------------------------
-- QUERY 6: Data completeness report by indicator and region
-- Use case: Report data gaps to stakeholders and data owners
-- ------------------------------------------------------------
SELECT
    indicator,
    au_region,
    COUNT(*)                                                        AS total_records,
    SUM(CASE WHEN quality_flag = 'VERIFIED' THEN 1 ELSE 0 END)     AS verified,
    SUM(CASE WHEN quality_flag = 'MISSING'  THEN 1 ELSE 0 END)     AS missing,
    ROUND(
        SUM(CASE WHEN quality_flag = 'VERIFIED' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1
    )                                                               AS completeness_pct
FROM cleaned_indicators
GROUP BY indicator, au_region
ORDER BY indicator, completeness_pct ASC;
