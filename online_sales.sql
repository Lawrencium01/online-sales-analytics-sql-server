--Question: Retrieve all orders placed from the United Kingdom.
SELECT *
FROM   OnlineSales
WHERE  Country = 'United Kingdom';


--Question: Find all Electronics orders where UnitPrice exceeds $50 and the item was not returned.
SELECT InvoiceNo,
       StockCode,
       Description,
       UnitPrice,
       Country,
       ReturnStatus
FROM   OnlineSales
WHERE  Category     = 'Electronics'
  AND  UnitPrice    > 50
  AND  ReturnStatus = 'Not Returned';


-Question: List all orders placed during Q1 2020 (January 1 – March 31).
sqlSELECT InvoiceNo,
       InvoiceDate,
       Description,
       Quantity,
       UnitPrice,
       Country
FROM   OnlineSales
WHERE  InvoiceDate BETWEEN '2020-01-01' AND '2020-03-31 23:59:59'
ORDER BY InvoiceDate;



--Question: Retrieve all orders where the customer paid by Credit Card or Bank Transfer.
sqlSELECT InvoiceNo,
       CustomerID,
       PaymentMethod,
       Quantity,
       UnitPrice,
       Country
FROM   OnlineSales
WHERE  PaymentMethod IN ('Credit Card', 'Bank Transfer');



--Question: Find all records where the product description contains the word "USB".
SELECT InvoiceNo,
       StockCode,
       Description,
       Category,
       UnitPrice
FROM   OnlineSales
WHERE  Description LIKE '%USB%';


--── SECTION 2: Sorting & Aggregation ────────────────────────────


--Question: List the top 10 orders with the highest unit price (valid prices only).
SELECT TOP 10
       InvoiceNo,
       Description,
       Category,
       UnitPrice,
       Country
FROM   OnlineSales
WHERE  UnitPrice > 0
ORDER BY UnitPrice DESC;



--Question: For each country, show the total number of orders and the total quantity sold.
SELECT Country,
       COUNT(InvoiceNo)  AS TotalOrders,
       SUM(Quantity)     AS TotalQuantitySold
FROM   OnlineSales
GROUP BY Country
ORDER BY TotalOrders DESC;



--Question: Calculate total gross revenue per product category (excluding returns and credit notes).
sqlSELECT Category,
       ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue,
       COUNT(InvoiceNo)                    AS TotalOrders
FROM   OnlineSales
WHERE  Quantity > 0
  AND  UnitPrice > 0
GROUP BY Category
ORDER BY TotalRevenue DESC;



--Question: What is the average discount rate offered for each payment method?
SELECT PaymentMethod,
       ROUND(AVG(Discount), 4) AS AvgDiscountRate,
       COUNT(InvoiceNo)        AS TotalOrders
FROM   OnlineSales
GROUP BY PaymentMethod
ORDER BY AvgDiscountRate DESC;



--── SECTION 3: HAVING Clause ─────────────────────────────────────


--Question: Which countries have received more than 4,000 orders?
SELECT Country,
       COUNT(InvoiceNo) AS TotalOrders
FROM   OnlineSales
GROUP BY Country
HAVING COUNT(InvoiceNo) > 4000
ORDER BY TotalOrders DESC;



--Question: Which sales channels have an average shipping cost greater than $15?
SELECT SalesChannel,
       ROUND(AVG(ShippingCost), 2) AS AvgShippingCost,
       COUNT(InvoiceNo)            AS TotalOrders
FROM   OnlineSales
WHERE  ShippingCost IS NOT NULL
GROUP BY SalesChannel
HAVING AVG(ShippingCost) > 15;



--── SECTION 4: CASE Statements ──────────────────────────────────

--Question: Classify each valid order as 'High Value' (≥ $1,000), 'Medium Value' ($500–$999), or 'Low Value' (< $500) based on the total order amount.
SELECT InvoiceNo,
       Description,
       Quantity,
       UnitPrice,
       ROUND(Quantity * UnitPrice, 2) AS TotalAmount,
       CASE
           WHEN (Quantity * UnitPrice) >= 1000 THEN 'High Value'
           WHEN (Quantity * UnitPrice) >= 500  THEN 'Medium Value'
           ELSE                                     'Low Value'
       END AS ValueCategory
FROM   OnlineSales
WHERE  Quantity > 0
  AND  UnitPrice > 0
ORDER BY TotalAmount DESC;



--Question: For each product category, how many orders fall into each value tier (High / Medium / Low)?
sqlSELECT Category,
       SUM(CASE WHEN (Quantity * UnitPrice) >= 1000 THEN 1 ELSE 0 END) AS HighValueOrders,
       SUM(CASE WHEN (Quantity * UnitPrice) >= 500
                 AND (Quantity * UnitPrice) <  1000 THEN 1 ELSE 0 END) AS MediumValueOrders,
       SUM(CASE WHEN (Quantity * UnitPrice) <  500  THEN 1 ELSE 0 END) AS LowValueOrders,
       COUNT(InvoiceNo)                                                  AS TotalOrders
FROM   OnlineSales
WHERE  Quantity > 0
  AND  UnitPrice > 0
GROUP BY Category
ORDER BY Category;


--── SECTION 5: Subqueries ────────────────────────────────────────


--Question: Retrieve all orders where the unit price is above the overall average unit price.
sqlSELECT InvoiceNo,
       Description,
       UnitPrice,
       Category,
       Country
FROM   OnlineSales
WHERE  UnitPrice > (
           SELECT AVG(UnitPrice)
           FROM   OnlineSales
           WHERE  UnitPrice > 0
       )
ORDER BY UnitPrice DESC;


--Question: Return only orders from countries that have placed more than 4,500 total orders.
SELECT InvoiceNo,
       Country,
       Category,
       Quantity,
       UnitPrice
FROM   OnlineSales
WHERE  Country IN (
           SELECT Country
           FROM   OnlineSales
           GROUP BY Country
           HAVING COUNT(InvoiceNo) > 4500
       );



--Question: Find all customers whose total spending is above the average spending per customer.
SELECT CustomerID,
       ROUND(TotalSpending, 2) AS TotalSpending
FROM (
    SELECT CustomerID,
           SUM(Quantity * UnitPrice) AS TotalSpending
    FROM   OnlineSales
    WHERE  Quantity     > 0
      AND  UnitPrice    > 0
      AND  CustomerID IS NOT NULL
    GROUP BY CustomerID
) AS CustomerSummary
WHERE TotalSpending > (
    SELECT AVG(TotalSpending)
    FROM (
        SELECT CustomerID,
               SUM(Quantity * UnitPrice) AS TotalSpending
        FROM   OnlineSales
        WHERE  Quantity     > 0
          AND  UnitPrice    > 0
          AND  CustomerID IS NOT NULL
        GROUP BY CustomerID
    ) AS AvgCalc
)
ORDER BY TotalSpending DESC;



--── SECTION 6: Common Table Expressions (CTEs) ──────────────────

--Question: Which warehouse locations generated more than $500,000 in total revenue?
WITH WarehouseRevenue AS (
    SELECT WarehouseLocation,
           ROUND(SUM(Quantity * UnitPrice), 2)  AS TotalRevenue,
           COUNT(InvoiceNo)                      AS TotalOrders
    FROM   OnlineSales
    WHERE  Quantity           > 0
      AND  UnitPrice          > 0
      AND  WarehouseLocation IS NOT NULL
    GROUP BY WarehouseLocation
)
SELECT WarehouseLocation,
       TotalRevenue,
       TotalOrders
FROM   WarehouseRevenue
WHERE  TotalRevenue > 500000
ORDER BY TotalRevenue DESC;



--Question: Calculate the total revenue and order count for each month across the entire dataset.
sqlWITH MonthlyRevenue AS (
    SELECT YEAR(InvoiceDate)                        AS SalesYear,
           MONTH(InvoiceDate)                       AS SalesMonth,
           DATENAME(MONTH, InvoiceDate)             AS MonthName,
           ROUND(SUM(Quantity * UnitPrice), 2)      AS TotalRevenue,
           COUNT(InvoiceNo)                         AS TotalOrders
    FROM   OnlineSales
    WHERE  Quantity  > 0
      AND  UnitPrice > 0
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate), DATENAME(MONTH, InvoiceDate)
)
SELECT SalesYear,
       SalesMonth,
       MonthName,
       TotalRevenue,
       TotalOrders
FROM   MonthlyRevenue
ORDER BY SalesYear, SalesMonth;



--Question: Rank countries by total revenue and return the top 5.
WITH CountryRevenue AS (
    SELECT Country,
           ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue,
           COUNT(InvoiceNo)                     AS TotalOrders
    FROM   OnlineSales
    WHERE  Quantity  > 0
      AND  UnitPrice > 0
    GROUP BY Country
),
RankedCountries AS (
    SELECT Country,
           TotalRevenue,
           TotalOrders,
           RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
    FROM   CountryRevenue
)
SELECT Country,
       TotalRevenue,
       TotalOrders,
       RevenueRank
FROM   RankedCountries
WHERE  RevenueRank <= 5;



--Question: Calculate total revenue for each sales channel and each channel's percentage share of overall revenue.
WITH ChannelRevenue AS (
    SELECT SalesChannel,
           ROUND(SUM(Quantity * UnitPrice), 2) AS ChannelRevenue
    FROM   OnlineSales
    WHERE  Quantity  > 0
      AND  UnitPrice > 0
    GROUP BY SalesChannel
),
TotalRevenueSummary AS (
    SELECT SUM(ChannelRevenue) AS GrandTotal
    FROM   ChannelRevenue
)
SELECT cr.SalesChannel,
       cr.ChannelRevenue,
       tr.GrandTotal,
       ROUND((cr.ChannelRevenue / tr.GrandTotal) * 100, 2) AS RevenueSharePct
FROM   ChannelRevenue         cr
CROSS JOIN TotalRevenueSummary tr
ORDER BY RevenueSharePct DESC;
Key concept: Multiple CTEs are separated by commas. CROSS JOIN with a single-row CTE is a clean way to divide each row by a grand total — no subquery needed in the SELECT.

--── SECTION 7: Temporary Tables ─────────────────────────────────


--Question: Store all high-priority returned orders in a temp table, then count them per category.
-- Step 1: Create and populate the temp table
DROP TABLE IF EXISTS #HighPriorityReturns;

SELECT InvoiceNo,
       Category,
       Quantity,
       UnitPrice,
       Country,
       ReturnStatus,
       OrderPriority
INTO   #HighPriorityReturns
FROM   OnlineSales
WHERE  OrderPriority = 'High'
  AND  ReturnStatus  = 'Returned';

-- Step 2: Query the temp table
SELECT Category,
       COUNT(*)                            AS ReturnedHighPriorityOrders,
       ROUND(SUM(ABS(Quantity * UnitPrice)), 2) AS EstimatedReturnValue
FROM   #HighPriorityReturns
GROUP BY Category
ORDER BY ReturnedHighPriorityOrders DESC;



--Question: Build a shipment provider performance summary using a temp table, then query the results.
-- Step 1: Create shipment summary
DROP TABLE IF EXISTS #ShipmentSummary;

SELECT ShipmentProvider,
       COUNT(InvoiceNo)                       AS TotalOrders,
       ROUND(SUM(Quantity * UnitPrice), 2)    AS TotalRevenue,
       ROUND(AVG(ShippingCost), 2)            AS AvgShippingCost,
       SUM(CASE WHEN ReturnStatus = 'Returned' THEN 1 ELSE 0 END) AS TotalReturns
INTO   #ShipmentSummary
FROM   OnlineSales
WHERE  Quantity  > 0
  AND  UnitPrice > 0
GROUP BY ShipmentProvider;

-- Step 2: Add a return rate column and present final report
SELECT ShipmentProvider,
       TotalOrders,
       TotalRevenue,
       AvgShippingCost,
       TotalReturns,
       ROUND(CAST(TotalReturns AS FLOAT) / NULLIF(TotalOrders, 0) * 100, 2) AS ReturnRatePct
FROM   #ShipmentSummary
ORDER BY TotalRevenue DESC;



--Question: Load only valid (non-return) orders into a temp table, then calculate the return rate per category using the full table for comparison.
-- Step 1: Store clean (valid) orders
DROP TABLE IF EXISTS #CleanOrders;

SELECT *
INTO   #CleanOrders
FROM   OnlineSales
WHERE  Quantity  > 0
  AND  UnitPrice > 0;

-- Step 2: Return rate = returned rows in full table vs. valid rows in temp table
SELECT co.Category,
       COUNT(co.InvoiceNo)                                               AS ValidOrders,
       SUM(CASE WHEN os.ReturnStatus = 'Returned' THEN 1 ELSE 0 END)    AS TotalReturns,
       ROUND(
           CAST(SUM(CASE WHEN os.ReturnStatus = 'Returned' THEN 1 ELSE 0 END) AS FLOAT)
           / NULLIF(COUNT(co.InvoiceNo), 0) * 100, 2
       )                                                                  AS ReturnRatePct
FROM   #CleanOrders co
JOIN   OnlineSales  os ON co.InvoiceNo = os.InvoiceNo
GROUP BY co.Category
ORDER BY ReturnRatePct DESC;


--── SECTION 8: Window Functions ─────────────────────────────────


--Question: Find the top 3 highest-revenue orders within each product category.
WITH RankedOrders AS (
    SELECT InvoiceNo,
           Category,
           Description,
           Quantity,
           UnitPrice,
           ROUND(Quantity * UnitPrice, 2) AS TotalAmount,
           ROW_NUMBER() OVER (
               PARTITION BY Category
               ORDER BY     (Quantity * UnitPrice) DESC
           ) AS RowNum
    FROM   OnlineSales
    WHERE  Quantity  > 0
      AND  UnitPrice > 0
)
SELECT InvoiceNo,
       Category,
       Description,
       Quantity,
       UnitPrice,
       TotalAmount,
       RowNum
FROM   RankedOrders
WHERE  RowNum <= 3
ORDER BY Category, RowNum;



--Question: Rank all customers by their total spending using DENSE_RANK so tied customers share the same rank.
WITH CustomerSpend AS (
    SELECT CustomerID,
           COUNT(InvoiceNo)                       AS TotalOrders,
           ROUND(SUM(Quantity * UnitPrice), 2)    AS TotalSpending,
           ROUND(AVG(Quantity * UnitPrice), 2)    AS AvgOrderValue
    FROM   OnlineSales
    WHERE  Quantity     > 0
      AND  UnitPrice    > 0
      AND  CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID,
       TotalOrders,
       TotalSpending,
       AvgOrderValue,
       DENSE_RANK() OVER (ORDER BY TotalSpending DESC) AS SpendingRank
FROM   CustomerSpend
ORDER BY SpendingRank;



--Question: Calculate a cumulative (running) total of revenue ordered by invoice date.
sqlSELECT InvoiceNo,
       InvoiceDate,
       Country,
       ROUND(Quantity * UnitPrice, 2)                          AS OrderRevenue,
       ROUND(
           SUM(Quantity * UnitPrice) OVER (
               ORDER BY InvoiceDate
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ), 2
       )                                                        AS CumulativeRevenue
FROM   OnlineSales
WHERE  Quantity  > 0
  AND  UnitPrice > 0
ORDER BY InvoiceDate;



--Question: For each customer, show the current order amount, the previous order amount, and the difference between them.
SELECT InvoiceNo,
       CustomerID,
       InvoiceDate,
       ROUND(Quantity * UnitPrice, 2)   AS CurrentAmount,
       ROUND(
           LAG(Quantity * UnitPrice) OVER (
               PARTITION BY CustomerID
               ORDER BY     InvoiceDate
           ), 2
       )                                AS PreviousAmount,
       ROUND(
           (Quantity * UnitPrice)
           - LAG(Quantity * UnitPrice) OVER (
               PARTITION BY CustomerID
               ORDER BY     InvoiceDate
             ), 2
       )                                AS AmountDifference
FROM   OnlineSales
WHERE  Quantity     > 0
  AND  UnitPrice    > 0
  AND  CustomerID IS NOT NULL
ORDER BY CustomerID, InvoiceDate;



--Question: Divide all customers into 4 equal groups (quartiles) based on their total spending and label each tier.
WITH CustomerTotals AS (
    SELECT CustomerID,
           ROUND(SUM(Quantity * UnitPrice), 2) AS TotalSpending
    FROM   OnlineSales
    WHERE  Quantity     > 0
      AND  UnitPrice    > 0
      AND  CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT CustomerID,
       TotalSpending,
       NTILE(4) OVER (ORDER BY TotalSpending DESC) AS Quartile,
       CASE NTILE(4) OVER (ORDER BY TotalSpending DESC)
           WHEN 1 THEN 'Top 25% — High Spenders'
           WHEN 2 THEN 'Upper-Mid Spenders'
           WHEN 3 THEN 'Lower-Mid Spenders'
           WHEN 4 THEN 'Bottom 25% — Low Spenders'
       END AS SpendingSegment
FROM   CustomerTotals
ORDER BY TotalSpending DESC;


--── SECTION 9: Stored Procedures ────────────────────────────────

--Question: Create a stored procedure that accepts a country name and returns its total orders, revenue, and return rate.
CREATE PROCEDURE sp_GetCountrySalesSummary
    @CountryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Country,
           COUNT(InvoiceNo)                                                        AS TotalOrders,
           ROUND(SUM(CASE WHEN Quantity > 0 AND UnitPrice > 0
                          THEN Quantity * UnitPrice ELSE 0 END), 2)               AS TotalRevenue,
           ROUND(AVG(CASE WHEN Quantity > 0 AND UnitPrice > 0
                          THEN ShippingCost ELSE NULL END), 2)                     AS AvgShippingCost,
           SUM(CASE WHEN ReturnStatus = 'Returned' THEN 1 ELSE 0 END)             AS TotalReturns,
           ROUND(
               CAST(SUM(CASE WHEN ReturnStatus = 'Returned' THEN 1 ELSE 0 END) AS FLOAT)
               / NULLIF(COUNT(InvoiceNo), 0) * 100, 2
           )                                                                        AS ReturnRatePct
    FROM   OnlineSales
    WHERE  Country = @CountryName
    GROUP BY Country;
END;
GO

-- ── Execute ──────────────────────────────
EXEC sp_GetCountrySalesSummary @CountryName = 'Germany';
EXEC sp_GetCountrySalesSummary @CountryName = 'United Kingdom';
Key concept: Stored procedures accept parameters (@ParameterName DataType) that act as runtime variables. SET NOCOUNT ON suppresses the "rows affected" message, which is best practice for production procedures.

Q30 — Stored Procedure for Date-Range Reporting
Question: Create a stored procedure that accepts a start and end date and returns a daily revenue summary within that range.
sqlCREATE PROCEDURE sp_GetDailyRevenuByDateRange
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @StartDate > @EndDate
    BEGIN
        RAISERROR('StartDate cannot be later than EndDate.', 16, 1);
        RETURN;
    END;

    SELECT CAST(InvoiceDate AS DATE)           AS SaleDate,
           COUNT(InvoiceNo)                    AS TotalOrders,
           ROUND(SUM(Quantity * UnitPrice), 2) AS DailyRevenue,
           ROUND(AVG(ShippingCost), 2)         AS AvgShippingCost,
           SUM(CASE WHEN ReturnStatus = 'Returned' THEN 1 ELSE 0 END) AS Returns
    FROM   OnlineSales
    WHERE  CAST(InvoiceDate AS DATE) BETWEEN @StartDate AND @EndDate
      AND  Quantity  > 0
      AND  UnitPrice > 0
    GROUP BY CAST(InvoiceDate AS DATE)
    ORDER BY SaleDate;
END;
GO

-- ── Execute ──────────────────────────────
EXEC sp_GetDailyRevenuByDateRange
     @StartDate = '2020-01-01',
     @EndDate   = '2020-03-31';




--Question: Create a stored procedure that returns the top N customers by total revenue, where N is supplied at runtime.
CREATE PROCEDURE sp_GetTopNCustomersByRevenue
    @TopN INT = 10    -- default value of 10 if not supplied
AS
BEGIN
    SET NOCOUNT ON;

    IF @TopN <= 0
    BEGIN
        RAISERROR('TopN must be a positive integer.', 16, 1);
        RETURN;
    END;

    SELECT TOP (@TopN)
           CustomerID,
           COUNT(InvoiceNo)                        AS TotalOrders,
           ROUND(SUM(Quantity * UnitPrice), 2)     AS TotalRevenue,
           ROUND(AVG(Quantity * UnitPrice), 2)     AS AvgOrderValue,
           MIN(CAST(InvoiceDate AS DATE))          AS FirstOrderDate,
           MAX(CAST(InvoiceDate AS DATE))          AS LastOrderDate
    FROM   OnlineSales
    WHERE  Quantity     > 0
      AND  UnitPrice    > 0
      AND  CustomerID IS NOT NULL
    GROUP BY CustomerID
    ORDER BY TotalRevenue DESC;
END;
GO

-- ── Execute ──────────────────────────────
EXEC sp_GetTopNCustomersByRevenue @TopN = 10;   -- Top 10
EXEC sp_GetTopNCustomersByRevenue;               -- Uses default (10)
EXEC sp_GetTopNCustomersByRevenue @TopN = 5;    -- Top 5
Key concept: Default parameter values (@TopN INT = 10) make the procedure callable without arguments. TOP (@TopN) with a variable (note the parentheses) is valid in SQL Server.


--── SECTION 10: Views ────────────────────────────────────────────


--Question: Build a reusable monthly sales dashboard view that any report or downstream query can call.
-- Create the view
CREATE VIEW vw_MonthlySalesDashboard AS
SELECT YEAR(InvoiceDate)                                                        AS SalesYear,
       MONTH(InvoiceDate)                                                       AS SalesMonth,
       DATENAME(MONTH, InvoiceDate)                                             AS MonthName,
       COUNT(InvoiceNo)                                                         AS TotalOrders,
       ROUND(SUM(CASE WHEN Quantity > 0 AND UnitPrice > 0
                      THEN Quantity * UnitPrice ELSE 0 END), 2)                AS TotalRevenue,
       ROUND(AVG(CASE WHEN Quantity > 0 AND UnitPrice > 0
                      THEN ShippingCost ELSE NULL END), 2)                     AS AvgShippingCost,
       SUM(CASE WHEN ReturnStatus = 'Returned' THEN 1 ELSE 0 END)             AS TotalReturns,
       ROUND(
           CAST(SUM(CASE WHEN ReturnStatus = 'Returned' THEN 1 ELSE 0 END) AS FLOAT)
           / NULLIF(COUNT(InvoiceNo), 0) * 100, 2
       )                                                                        AS ReturnRatePct
FROM   OnlineSales
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate), DATENAME(MONTH, InvoiceDate);
GO

-- ── Query the view ────────────────────────
SELECT *
FROM   vw_MonthlySalesDashboard
ORDER BY SalesYear, SalesMonth;

-- Filter the view like any table
SELECT *
FROM   vw_MonthlySalesDashboard
WHERE  SalesYear = 2020
ORDER BY SalesMonth;

--── SECTION 11: Date & String Functions ─────────────────────────

--Question: Extract year, month name, and quarter from InvoiceDate, and calculate revenue per quarter per year.
sqlSELECT YEAR(InvoiceDate)                                             AS SalesYear,
       DATEPART(QUARTER, InvoiceDate)                               AS SalesQuarter,
       CONCAT('Q', DATEPART(QUARTER, InvoiceDate),
              ' ', YEAR(InvoiceDate))                               AS QuarterLabel,
       COUNT(InvoiceNo)                                             AS TotalOrders,
       ROUND(SUM(Quantity * UnitPrice), 2)                         AS TotalRevenue,
       ROUND(AVG(Quantity * UnitPrice), 2)                         AS AvgOrderValue
FROM   OnlineSales
WHERE  Quantity  > 0
  AND  UnitPrice > 0
GROUP BY YEAR(InvoiceDate), DATEPART(QUARTER, InvoiceDate)
ORDER BY SalesYear, SalesQuarter;


--── SECTION 12: NULL Handling & COALESCE ────────────────────────

--Question: Identify all guest orders (NULL CustomerID) and display a clean label in place of NULL. Also surface NULL warehouse locations.
SELECT InvoiceNo,
       COALESCE(CAST(CustomerID AS VARCHAR(10)), 'Guest')   AS CustomerID,
       Description,
       Quantity,
       UnitPrice,
       ROUND(Quantity * UnitPrice, 2)                        AS TotalAmount,
       Country,
       COALESCE(WarehouseLocation, 'Unknown Warehouse')      AS WarehouseLocation,
       InvoiceDate
FROM   OnlineSales
WHERE  CustomerID        IS NULL
   OR  WarehouseLocation IS NULL
ORDER BY InvoiceDate;
Bonus — Count NULLs per column for a data quality audit:
sqlSELECT
    SUM(CASE WHEN CustomerID        IS NULL THEN 1 ELSE 0 END) AS NullCustomerIDs,
    SUM(CASE WHEN WarehouseLocation IS NULL THEN 1 ELSE 0 END) AS NullWarehouses,
    SUM(CASE WHEN ShippingCost      IS NULL THEN 1 ELSE 0 END) AS NullShippingCosts
FROM OnlineSales;

--── SECTION 13: Advanced / Complex Query ────────────────────────

--Question: Build a complete customer segmentation report that calculates each customer's total orders, revenue, and average order value; ranks them by revenue; and assigns a Platinum / Gold / Silver / Bronze tier.
sql-- Step 1: Aggregate customer-level metrics
WITH CustomerMetrics AS (
    SELECT CustomerID,
           COUNT(InvoiceNo)                        AS TotalOrders,
           ROUND(SUM(Quantity * UnitPrice), 2)     AS TotalRevenue,
           ROUND(AVG(Quantity * UnitPrice), 2)     AS AvgOrderValue,
           MIN(CAST(InvoiceDate AS DATE))          AS FirstOrderDate,
           MAX(CAST(InvoiceDate AS DATE))          AS LastOrderDate,
           COUNT(DISTINCT CAST(InvoiceDate AS DATE)) AS ActiveDays
    FROM   OnlineSales
    WHERE  Quantity     > 0
      AND  UnitPrice    > 0
      AND  CustomerID IS NOT NULL
    GROUP BY CustomerID
),

-- Step 2: Add rankings and tier buckets
CustomerRanked AS (
    SELECT CustomerID,
           TotalOrders,
           TotalRevenue,
           AvgOrderValue,
           FirstOrderDate,
           LastOrderDate,
           ActiveDays,
           DENSE_RANK() OVER (ORDER BY TotalRevenue DESC)   AS RevenueRank,
           NTILE(4)     OVER (ORDER BY TotalRevenue DESC)   AS RevenueTier
    FROM   CustomerMetrics
)

-- Step 3: Present final segmented report
SELECT CustomerID,
       TotalOrders,
       TotalRevenue,
       AvgOrderValue,
       FirstOrderDate,
       LastOrderDate,
       ActiveDays,
       RevenueRank,
       CASE RevenueTier
           WHEN 1 THEN 'Platinum'
           WHEN 2 THEN 'Gold'
           WHEN 3 THEN 'Silver'
           WHEN 4 THEN 'Bronze'
       END AS CustomerTier
FROM   CustomerRanked
ORDER BY RevenueRank;