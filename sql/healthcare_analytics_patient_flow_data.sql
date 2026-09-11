-- ============================================================
-- SUMMARY: See Health_care_analysis.ipynb for full business
-- insights and recommendations. Key caveats affecting queries
-- in this file:
--   - Department Referral is NULL for 58.6% of rows — 
--     department-level queries below reflect ~41% of visits.
--   - Patient Satisfaction Score is missing for 72.7% of rows —
--     always check response count (see fixed query below)
--     alongside any satisfaction average before drawing conclusions.
-- ============================================================

-- Exploratory preview
SELECT *
FROM healthcare_analytics_patient_flow_data
LIMIT 10;

DESCRIBE healthcare_analytics_patient_flow_data;

-- Total Patient Encounters
Select Count(*) as total_patient_encounter
From healthcare_analytics_patient_flow_data;

-- Admission rate
SELECT
    ROUND(
        SUM(CASE 
            WHEN `Patient Admission Flag` = 'Admission' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
        2
    ) AS admission_rate
FROM healthcare_analytics_patient_flow_data;

-- Average waiting time of patients
Select
    round(avg(`Patient Waittime`),2) as avg_wait_time
from healthcare_analytics_patient_flow_data;

-- Average Waiting time by department
select
    round(avg(`Patient Waittime`),2) as avg_department_wait_time
from healthcare_analytics_patient_flow_data
group by `Department Referral`
order by avg_department_wait_time DESC;

-- Department with highest patient volume
select
     `Department Referral`,
     count(*) as patient_volume
from healthcare_analytics_patient_flow_data
group by `Department Referral`
order by patient_volume DESC;

-- Patient Volume with hour
select
     Hour(`Patient Admission Time`) as admission_hour,
     count(*) as patient_volume
from healthcare_analytics_patient_flow_data
group by hour(`Patient Admission Time`)
order by admission_hour;

-- Patient Volume with Day
SELECT
    DAYNAME(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    ) AS admission_day,
    COUNT(*) AS patient_volume
FROM healthcare_analytics_patient_flow_data
GROUP BY
    DAYOFWEEK(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    ),
    DAYNAME(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    )
ORDER BY
    DAYOFWEEK(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    );

-- Patient Volume with Month
SELECT
    MONTHNAME(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    ) AS admission_month,
    COUNT(*) AS patient_volume
FROM healthcare_analytics_patient_flow_data
GROUP BY
    MONTH(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    ),
    MONTHNAME(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    )
ORDER BY
    MONTH(
        STR_TO_DATE(`Patient Admission Date`, '%c/%e/%Y')
    );
    
-- Relationship Between Waiting Time and Admission
select
    `Patient Admission Flag`,
    count(*) as patient_volume,
    round(avg(`Patient Waittime`),2) as avg_patient_waittime
from healthcare_analytics_patient_flow_data
group by `Patient Admission Flag`
order by avg_patient_waittime desc;

-- Patient Satisfaction by department
select
     `Department Referral`,
     round(avg(`Patient Satisfaction Score`),2) as patient_satisfaction
from healthcare_analytics_patient_flow_data
group by `Department Referral`
order by patient_satisfaction desc;

-- Departments with loswest satifaction
select
     `Department Referral`,
     round(avg(`Patient Satisfaction Score`),2) as patient_satisfaction
from healthcare_analytics_patient_flow_data
group by `Department Referral`
order by patient_satisfaction asc
limit 3;


    