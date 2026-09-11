# [Project 1: Customer Churn analysis](https://anaconda.com/app/share/notebooks/1e4c485d-2743-441b-b129-23aa5cbe4651/overview)
### Customer Churn Analysis

A data analytics project focused on understanding **why customers churn and which customer segments are most at risk**. Using Python, Pandas, Matplotlib, and Seaborn, the project cleans and transforms 7,043 customer records, performs exploratory analysis, engineers analytical features, and evaluates key churn drivers.

**Goal:** Turn customer data into actionable insights that can support targeted retention strategies.
### SQL Analysis

The SQL analysis covers:
- Customer churn rate
- Churn by contract type
- Churn by payment method
- Churn by internet service
- High-churn customer segments
- Revenue exposure of high-risk segments

📄 [View SQL Queries](sql/customer_churn_analysis.sql)


[🔗 View Interactive Customer Churn analysis Dashboard](https://public.tableau.com/views/project_17871198432810/Dashboard2?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

# [Project 2: Supply Chain Analysis](https://anaconda.com/app/share/notebooks/6ce30631-606e-48c7-bdc8-b21c7f44c2cd/overview)
### Supply Chain Analysis

EDA on 180,519 order records to identify drivers of delivery delays and shipping inefficiency across a multi-region retail supply chain.

Highlights: 57.28% late-delivery rate · First Class shipping at 100% late · Europe above-average delays · Fishing top category by profit

Stack: Python, pandas, NumPy, Matplotlib, Seaborn, SciPy

**Goal:** Analyze supply chain and order data to quantify delivery delays, evaluate shipping-mode performance, and identify high-impact areas for operational improvement across markets and product categories.
### SQL Analysis

The SQL analysis covers:
- **Database setup** — creates the `supply_chain` DB and previews the DataCo dataset structure
- **Revenue & products** — total revenue, top 10 products, and cancellation rates
- **Delivery performance** — avg. delivery time, on-time/late rates by shipping mode, and most-delayed products
- **Trends** — order volume by region, plus monthly order and category sales trends

📄 [View SQL Queries](./Supply_chain_inventory.sql)

[🔗View Interactive Dashboard on Tableau Public](https://public.tableau.com/views/SupplyChainManagementCommandcenter/SupplyChainManagementCommandcenter?:language=en-US&:display_count=n&:origin=viz_share_link)

# [Project 3: Health Care Analysis](https://anaconda.com/app/share/notebooks/6d2705c4-d2d8-46cc-b324-c42e6e6c7e1c/overview)
### Health Care analysis
## Healthcare Patient Flow Analysis

Exploratory analysis of 9,216 patient encounters to identify bottlenecks in wait times, department capacity, and patient satisfaction, with actionable recommendations for hospital operations.

**Files:**
- `Health_care_analysis.ipynb` — Full EDA in Python (pandas, matplotlib): patient volume trends, wait-time distribution, department performance, satisfaction analysis, admission patterns by age group, and a final business insights & recommendations section.
- `healthcare_analytics_patient_flow_data.sql` — SQL queries validating key metrics (admission rate, average wait time, department volume/satisfaction, temporal patient volume by hour/day/month) as a cross-check against the Python analysis.
  📄 [View SQL Queries](./healthcare_analytics_patient_flow_data.sql)

**Key findings:**
- Wait times are driven by staffing/scheduling mismatches, not patient volume — Physiotherapy and Gastroenterology have long waits despite comparatively low patient counts.
- Satisfaction generally drops as wait time rises, though a few departments buck this trend, suggesting factors beyond speed (e.g. communication) affect the patient experience.
- Two data quality gaps — missing Department Referral (58.6%) and missing Satisfaction Score (72.7%) — are explicitly flagged throughout, since they limit how confidently department-level findings can be generalized.

[🔗View Interactive Dashboard on Tableau Public](https://public.tableau.com/views/Healthcareanalytics_17888576528670/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

