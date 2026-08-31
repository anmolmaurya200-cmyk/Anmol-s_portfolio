CREATE DATABASE IF NOT EXISTS supply_chain;

USE supply_chain;

SHOW TABLES;

-- Exploratory preview (safe to delete before final handoff)
SELECT *
FROM DataCoSupplyChainDataset
LIMIT 10;

DESCRIBE DataCoSupplyChainDataset;

-- Row count / total order lines
SELECT COUNT(*) AS Total_Rows
FROM DataCoSupplyChainDataset;

-- Total Revenue
SELECT
    ROUND(SUM(Sales), 2) AS Total_Revenue
FROM DataCoSupplyChainDataset;

-- Top 10 products by revenue
SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS Total_Revenue
FROM DataCoSupplyChainDataset
GROUP BY `Product Name`
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Cancellation rate by product
-- NOTE: this measures CANCELED status specifically, not returns.
-- If your dataset tracks returns as a separate status, adjust the filter accordingly.
SELECT
    `Product Name`,
    COUNT(*) AS Total_Orders,
    SUM(`Order Status` = 'CANCELED') AS Canceled_Orders,
    ROUND(
        SUM(`Order Status` = 'CANCELED') / COUNT(*) * 100,
        2
    ) AS Cancellation_Rate
FROM DataCoSupplyChainDataset
GROUP BY `Product Name`
ORDER BY Cancellation_Rate DESC;

-- Average delivery time by shipping mode
SELECT
    `Shipping Mode`,
    ROUND(AVG(`Days for shipping (real)`), 2) AS Avg_Delivery_Time
FROM DataCoSupplyChainDataset
GROUP BY `Shipping Mode`
ORDER BY Avg_Delivery_Time DESC;

-- Regions generating the most orders
SELECT
    `Order Region`,
    COUNT(*) AS Total_Orders
FROM DataCoSupplyChainDataset
GROUP BY `Order Region`
ORDER BY Total_Orders DESC;

-- Products with frequent delays
SELECT
    `Product Name`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Late_delivery_risk` = 1) AS Delayed_Orders,
    ROUND(
        SUM(`Late_delivery_risk` = 1) / COUNT(DISTINCT `Order Id`) * 100,
        2
    ) AS Delay_Rate
FROM DataCoSupplyChainDataset
GROUP BY `Product Name`
ORDER BY Delay_Rate DESC;

-- On-time performance by shipping mode
-- (No supplier column exists in this dataset; grouping by Shipping Mode instead)
SELECT
    `Shipping Mode`,
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Late_delivery_risk` = 0) AS On_Time_Orders,
    ROUND(
        SUM(`Late_delivery_risk` = 0) / COUNT(DISTINCT `Order Id`) * 100,
        2
    ) AS On_Time_Rate
FROM DataCoSupplyChainDataset
GROUP BY `Shipping Mode`
ORDER BY On_Time_Rate DESC;

-- Overall percentage of late orders
SELECT
    COUNT(DISTINCT `Order Id`) AS Total_Orders,
    SUM(`Late_delivery_risk` = 1) AS Late_Orders,
    ROUND(
        SUM(`Late_delivery_risk` = 1) / COUNT(DISTINCT `Order Id`) * 100,
        2
    ) AS Late_Order_Percentage
FROM DataCoSupplyChainDataset;

-- Monthly order trend
SELECT
    DATE_FORMAT(`order date (DateOrders)`, '%Y-%m') AS Order_Month,
    COUNT(DISTINCT `Order Id`) AS Total_Orders
FROM DataCoSupplyChainDataset
GROUP BY Order_Month
ORDER BY Order_Month;

-- Monthly sales by category (identify categories with declining sales)
SELECT
    `Category Name`,
    DATE_FORMAT(`order date (DateOrders)`, '%Y-%m') AS Order_Month,
    ROUND(SUM(Sales), 2) AS Monthly_Sales
FROM DataCoSupplyChainDataset
GROUP BY
    `Category Name`,
    Order_Month
ORDER BY
    `Category Name`,
    Order_Month;
