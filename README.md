# Online Sales Analytics Using SQL Server

## Project Overview

This project presents a comprehensive analysis of online sales transactions using Microsoft SQL Server. The objective was to transform raw transactional data into actionable business insights that support revenue growth, customer understanding, operational efficiency, and strategic decision-making.

Using SQL Server Management Studio (SSMS), the dataset was explored and analyzed through a combination of fundamental and advanced SQL techniques. The project covers sales performance analysis, customer analytics, product performance evaluation, return analysis, logistics assessment, and business reporting.

---

## Business Problem

E-commerce businesses generate large volumes of transactional data daily. Without proper analysis, valuable insights regarding customer behavior, product performance, sales trends, and operational efficiency may remain hidden.

This project aims to answer critical business questions such as:

- Which products generate the most revenue?
- Who are the highest-value customers?
- Which countries contribute the most sales?
- What are the return patterns across products and categories?
- How effective are shipping providers and sales channels?
- How can customer segmentation support business growth?

The analysis provides data-driven insights that support better decision-making across sales, marketing, operations, and customer management.

---

## Dataset Information

The dataset contains online sales transactions with the following attributes:

| Column Name | Description |
|------------|-------------|
| InvoiceNo | Unique invoice number |
| StockCode | Product code |
| Description | Product description |
| Quantity | Quantity purchased |
| InvoiceDate | Transaction date |
| UnitPrice | Price per unit |
| CustomerID | Unique customer identifier |
| Country | Customer country |
| Discount | Discount applied |
| PaymentMethod | Method of payment |
| ShippingCost | Shipping cost |
| Category | Product category |
| SalesChannel | Sales channel |
| ReturnStatus | Return indicator |
| ShipmentProvider | Shipping provider |
| WarehouseLocation | Warehouse location |
| OrderPriority | Priority level |

---

## Project Objectives

The primary objectives of this project are:

- Analyze overall sales performance
- Identify top-performing products and categories
- Evaluate customer purchasing behavior
- Segment customers based on spending patterns
- Measure country-level sales performance
- Assess return rates and return-related losses
- Evaluate logistics and shipping efficiency
- Demonstrate advanced SQL analytical capabilities

---

## SQL Concepts Demonstrated

### Fundamental SQL

- SELECT
- FROM
- WHERE
- ORDER BY
- GROUP BY
- HAVING

### Aggregate Functions

- SUM()
- AVG()
- COUNT()
- MIN()
- MAX()

### Intermediate SQL

- CASE Statements
- Date Functions
- String Functions
- NULL Handling
- COALESCE()
- Business Logic Development

### Advanced SQL

- Common Table Expressions (CTEs)
- Temporary Tables
- Window Functions
  - ROW_NUMBER()
  - RANK()
  - DENSE_RANK()
  - NTILE()
  - LAG()
  - Running Totals
- Subqueries
- Views
- Stored Procedures
- Parameterized Stored Procedures

---

## Key Business Questions Answered

### Sales Performance Analysis

- What is the total revenue generated?
- Which countries contribute the highest revenue?
- Which sales channels perform best?
- What are the monthly and quarterly sales trends?
- Which product categories generate the highest revenue?

### Customer Analytics

- Who are the highest-spending customers?
- Which customers spend above average?
- How can customers be segmented based on spending?
- Which customers generate the highest lifetime value?

### Product Analysis

- Which products generate the most revenue?
- Which products are sold most frequently?
- Which categories drive business performance?
- Which products outperform category averages?

### Returns Analysis

- Which products experience the highest return rates?
- What is the financial impact of returns?
- Which categories generate the most returns?

### Logistics Analysis

- Which shipment providers handle the most orders?
- What are the average shipping costs by sales channel?
- Which warehouses process the most revenue?
- How do order priorities affect operations?

---

## Advanced Analytics Performed

### Customer Segmentation

Customers were segmented into spending tiers using window functions and ranking techniques to identify high-value customers and support retention strategies.

### Revenue Trend Analysis

Monthly and quarterly revenue trends were analyzed to understand sales patterns and business growth over time.

### Revenue Ranking

Products, customers, countries, and sales channels were ranked using advanced SQL window functions.

### Logistics Performance Evaluation

Shipping providers and warehouse locations were evaluated based on revenue contribution, order volume, shipping costs, and return rates.

### Automated Business Reporting

Stored procedures and views were developed to automate recurring business reports and improve reporting efficiency.

---

## Project Structure

```text
Online-Sales-Analytics-SQL-Server/

│

├── Online_Sales_Dataset.csv

├── Online_Sales_Analytics.sql

├── README.md

│

└── Results/
    ├── Query Outputs
    ├── Screenshots
    └── Documentation
```

---

## Tools Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- GitHub

---

## Skills Demonstrated

### Technical Skills

- SQL Querying
- Data Exploration
- Data Cleaning
- Data Aggregation
- Business Intelligence
- Customer Analytics
- Sales Analytics
- Logistics Analytics
- Query Optimization
- Database Reporting

### Analytical Skills

- Revenue Analysis
- Customer Segmentation
- Product Performance Evaluation
- Business Performance Measurement
- Return Analysis
- Operational Analytics
- Data-Driven Decision Making

---

## Key Outcomes

The analysis enables stakeholders to:

- Identify high-value customers
- Monitor sales performance across countries and channels
- Optimize product strategies
- Evaluate logistics efficiency
- Reduce return-related losses
- Improve customer retention strategies
- Support strategic business decisions through data-driven insights

---

## Conclusion

This project demonstrates how SQL can be used to transform raw transactional sales data into actionable business intelligence. By applying both foundational and advanced SQL concepts, the project delivers insights into customer behavior, product performance, revenue generation, and operational efficiency.

The project serves as a practical example of how SQL can be leveraged in real-world e-commerce, sales analytics, customer analytics, and business intelligence environments.
