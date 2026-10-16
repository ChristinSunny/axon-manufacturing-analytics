# Axon Manufacturing Analytics

A manufacturing analytics project focused on analysing production performance, product quality, machine efficiency, and operational KPIs using SQL, Excel, Power BI, and Tableau.

## Project Overview

The objective of this project is to transform manufacturing data into meaningful insights that help evaluate production output, identify rejection patterns, and understand operational performance.

## Business Objectives

- Analyse planned, processed, produced, and rejected quantities.
- Calculate manufacturing KPIs using MySQL.
- Compare rejection quantities across employees, machines, operations, and departments.
- Analyse monthly production trends.
- Present key findings through dashboards and visual reports.

## Tools and Technologies

- **MySQL:** Data preparation, joins, aggregations, views, and KPI calculations.
- **Microsoft Excel:** Data review and spreadsheet analysis.
- **Power BI:** Interactive dashboarding and visualisation.
- **Tableau:** Manufacturing performance visualisation.

## Dataset and Data Preparation

The project uses manufacturing data organised into a production fact table and dimension tables for buyers, customers, dates, departments, employees, items, machines, and operations.

The production table contains 10,679 imported rows, including 679 placeholder rows. A SQL view named `fact_prod` filters out records with a NULL document number, leaving 10,000 records for analysis.

## Key Performance Indicators

The SQL analysis covers manufacturing measures such as:

- Total work orders
- Total work-order quantity
- Total processed quantity
- Total produced quantity
- Total rejected quantity
- Efficiency rate
- Machine utilization measure
- Rejection rate
- Wastage percentage
- On-time delivery percentage
- Repeat-order percentage
- Production value and cost per unit
- Machine-wise rejection quantity
- Employee-wise rejection quantity
- Operation-wise rejection quantity
- Department-wise production and rejection
- Monthly manufacturing quantity

## SQL Concepts Used

- `SELECT`, `WHERE`, and `ORDER BY`
- Aggregate functions: `SUM()`, `COUNT()`, and `AVG()`
- `CASE WHEN` conditional logic
- `LEFT JOIN`
- `GROUP BY`
- SQL views
- Data validation and filtering

## Business Analysis

The project examines production output and rejection quantities by machine, employee, operation, department, and month. These analyses can help identify areas for further quality investigation and operational improvement.

## Repository Structure

- `SQL/` — SQL scripts and analysis queries
- `Excel/` — Excel analysis and dashboard files
- `Power BI/` — Power BI dashboard files
- `Tabelau/` — Tableau workbook

## Project Outcome

This project demonstrates how SQL and business intelligence tools can be used to organise manufacturing data, calculate KPIs, analyse production performance, and communicate findings through dashboards.

## Author

**Christin Sunny**

Aspiring Data Analyst

[GitHub Profile](https://github.com/ChristinSunny)
