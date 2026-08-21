CREATE DATABASE IF NOT EXISTS customer_churn;

USE customer_churn;

SHOW TABLES;

-- Exploratory preview (safe to delete before final handoff)
SELECT *
FROM `customer_churn.csv`
LIMIT 10;

-- A CTE containing the main customer-level churn information
with customer_churn as (
  select 
     customerID,
     gender,
     SeniorCitizen,
     partner,
     dependents,
     tenure,
     contract,
     monthlycharges,
     totalcharges,
     churn
from `customer_churn.csv`
)
select *
from customer_churn;

-- Calculating churn rate of customers with less than 12 months by using CTE
with customer_churn as (
   select 
       customerID,
       tenure, 
       churn
   from `customer_churn.csv`
)
select 
     COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
    
from customer_churn
where tenure < 12;

-- Creating a contract-level summary showing customers, churned customers, churn rate, and average monthly charges
with customer_churn as (
    select
        customerID,
        Contract,
        churn,
        monthlyCharges
    from `customer_churn.csv`
)
select
     contract,
     count(*) as total_customers,
     sum(case when churn ='Yes' then 1 else 0 end) as churned_customers,
     round(
	     sum( case when churn='Yes' then 1 else 0 end) * 100
         / count(*),
         2
) as churn_rate,
     round(avg(MonthlyCharges), 2) as avg_monthly_charge
from customer_churn
group by contract
order by churn_rate desc;

-- Ranking customers by tenure within each contract type
with customer_churn as (
     select
         customerID,
         tenure,
         contract
     from `customer_churn.csv`
)
select
     customerID,
     Contract,
     tenure,
     rank() over (
          partition by contract
          order by tenure desc
) as tenure_rank
from customer_churn
order by contract, tenure_rank;


-- Using a window AVG() to calculate each customer's difference from their contract's average monthly charge
with customer_churn as (
     select
         customerID,
         contract,
         monthlycharges
	from `customer_churn.csv`
)
select
      customerId,
      contract,
      monthlycharges,
      round(
            avg(monthlycharges) over(
            partition by contract
            ),
            2
) as contract_avg_monthlycharges,
round(
      avg(Monthlycharges) over (
      partition by contract
      ),
      2
) as difference_from_contract_avg

from customer_churn
order by contract, difference_from_contract_avg;

-- calculating cumulative churn by tenure
with customer_churn as (
     select 
         customerid,
         tenure,
         churn
     from `customer_churn.csv`
)
SELECT
    customerID,
    tenure,
    Churn,
    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) OVER (
        ORDER BY tenure
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_churn
FROM customer_churn
ORDER BY tenure;

-- Calculating churn rates by tenure group, contract, payment method, internet service, and service count

WITH customer_churn AS (
    SELECT
        customerID,
        tenure,
        Contract,
        PaymentMethod,
        InternetService,
        Churn,
        PhoneService,
        MultipleLines,
        OnlineSecurity,
        OnlineBackup,
        DeviceProtection,
        TechSupport,
        StreamingTV,
        StreamingMovies
    FROM `customer_churn.csv`
)
SELECT
    CASE
        WHEN tenure < 12 THEN '0-11 months'
        WHEN tenure < 24 THEN '12-23 months'
        WHEN tenure < 48 THEN '24-47 months'
        ELSE '48+ months'
    END AS tenure_group,
    Contract,
    PaymentMethod,
    InternetService,
    (
        (PhoneService = 'Yes') +
        (MultipleLines = 'Yes') +
        (OnlineSecurity = 'Yes') +
        (OnlineBackup = 'Yes') +
        (DeviceProtection = 'Yes') +
        (TechSupport = 'Yes') +
        (StreamingTV = 'Yes') +
        (StreamingMovies = 'Yes')
    ) AS service_count,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customer_churn
GROUP BY
    tenure_group,
    Contract,
    PaymentMethod,
    InternetService,
    service_count
ORDER BY churn_rate DESC;

-- Finding the top 5 high-churn customer segments, using a minimum customer-count requirement
WITH customer_churn AS (
    SELECT
        customerID,
        tenure,
        Contract,
        PaymentMethod,
        InternetService,
        Churn,
        (PhoneService = 'Yes') +
        (MultipleLines = 'Yes') +
        (OnlineSecurity = 'Yes') +
        (OnlineBackup = 'Yes') +
        (DeviceProtection = 'Yes') +
        (TechSupport = 'Yes') +
        (StreamingTV = 'Yes') +
        (StreamingMovies = 'Yes') AS service_count
    FROM `customer_churn.csv`
),
segments AS (
    SELECT
        CASE
            WHEN tenure < 12 THEN '0-11 months'
            WHEN tenure < 24 THEN '12-23 months'
            WHEN tenure < 48 THEN '24-47 months'
            ELSE '48+ months'
        END AS tenure_group,
        Contract,
        PaymentMethod,
        InternetService,
        service_count,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
    FROM customer_churn
    GROUP BY
        tenure_group,
        Contract,
        PaymentMethod,
        InternetService,
        service_count
)
SELECT
    tenure_group,
    Contract,
    PaymentMethod,
    InternetService,
    service_count,
    customers,
    churned_customers,
    ROUND(
        churned_customers * 100.0 / customers,
        2
    ) AS churn_rate
FROM segments
WHERE customers >= 100
ORDER BY churn_rate DESC
LIMIT 5;

-- Calculating the Revenue exposer of high churn
WITH customer_churn AS (
    SELECT
        customerID,
        tenure,
        Contract,
        PaymentMethod,
        InternetService,
        MonthlyCharges,
        Churn,
        (PhoneService = 'Yes') +
        (MultipleLines = 'Yes') +
        (OnlineSecurity = 'Yes') +
        (OnlineBackup = 'Yes') +
        (DeviceProtection = 'Yes') +
        (TechSupport = 'Yes') +
        (StreamingTV = 'Yes') +
        (StreamingMovies = 'Yes') AS service_count
    FROM `customer_churn.csv`
),
segments AS (
    SELECT
        CASE
            WHEN tenure < 12 THEN '0-11 months'
            WHEN tenure < 24 THEN '12-23 months'
            WHEN tenure < 48 THEN '24-47 months'
            ELSE '48+ months'
        END AS tenure_group,
        Contract,
        PaymentMethod,
        InternetService,
        service_count,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        SUM(MonthlyCharges) AS monthly_revenue,
        SUM(
            CASE
                WHEN Churn = 'Yes' THEN MonthlyCharges
                ELSE 0
            END
        ) AS churned_monthly_revenue
    FROM customer_churn
    GROUP BY
        tenure_group,
        Contract,
        PaymentMethod,
        InternetService,
        service_count
),
high_churn_segments AS (
    SELECT
        *,
        ROUND(
            churned_customers * 100.0 / customers,
            2
        ) AS churn_rate
    FROM segments
    WHERE customers >= 100
    ORDER BY churn_rate DESC
    LIMIT 5
)
SELECT
    tenure_group,
    Contract,
    PaymentMethod,
    InternetService,
    service_count,
    customers,
    churned_customers,
    churn_rate,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(churned_monthly_revenue, 2) AS churned_monthly_revenue,
    ROUND(churned_monthly_revenue * 12, 2) AS annual_revenue_exposure
FROM high_churn_segments
ORDER BY churn_rate DESC;