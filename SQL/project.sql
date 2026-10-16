-- DATABASE CREATION
CREATE DATABASE Manufacturing_axon;
USE Manufacturing_axon;

-- DIM BUYER TABLE CREATION
CREATE TABLE dim_Buyer (
    Buyer_ID VARCHAR(10) PRIMARY KEY,
    Buyer_Name VARCHAR(100),
    Region VARCHAR(50),
    Founded_Year INT,
    Segment VARCHAR(50)
);
-- DIM CUSTOMER TABLE CREATION
CREATE TABLE dim_Customer (
    Customer_Code VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Customer_Type VARCHAR(100),
    City VARCHAR(100),
    Active VARCHAR(10)
);
-- Employee table
CREATE TABLE dim_Employee (
    Employee_Code VARCHAR(20) PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Department VARCHAR(50),
    Level VARCHAR(30)
);

-- DIM OPERATION TABLE CREATION
CREATE TABLE dim_Operation (
    Operation_Code VARCHAR(20) PRIMARY KEY,
    Operation_Name VARCHAR(100),
    Standard_Cost_Per_Hour int,
    Is_Automated VARCHAR(10)
);
-- DIM MACHINE TABLE CREATION
CREATE TABLE dim_Machine (
  Machine_Code   VARCHAR(10) PRIMARY KEY,
  Operation_Code VARCHAR(10),
  Operation_Name VARCHAR(40),
  Avg_Daily_Cost DECIMAL(10,2),
  Machine_Type   VARCHAR(20),
  Status         VARCHAR(10),
  FOREIGN KEY (Operation_Code) REFERENCES dim_Operation(Operation_Code)
);
-- DIM DEPARTMENT TABLE CREATION
CREATE TABLE dim_Department (
    Dept_ID VARCHAR(10) PRIMARY KEY,
    Dept_Name VARCHAR(100),
    Category VARCHAR(100),
    Head_Count_Range VARCHAR(20),
    Floor VARCHAR(50)
);

-- DIM ITEM TABLE CREATION
CREATE TABLE dim_Item (
    Item_Code VARCHAR(30) PRIMARY KEY,
    Item_Name VARCHAR(255),
    Department_Name VARCHAR(100),
    Item_Category VARCHAR(50)
);
-- DIM DATE TABLE CREATION
CREATE TABLE dim_Date (
    Date DATE,
    Day INT,
    Day_Name VARCHAR(20),
    Week_Num INT,
    Month_Num INT,
    Month_Name VARCHAR(20),
    Quarter VARCHAR(5),
    Year INT,
    Is_Weekend VARCHAR(10),
    Season VARCHAR(20)
);
-- FACT PRODUCTION TABLE CREATON
CREATE TABLE fact_Production (
  Doc_Num        VARCHAR(100) NULL,         
  Date_FK        DATE,
  Buyer_ID       VARCHAR(5),  Customer_Code VARCHAR(10), Employee_Code VARCHAR(10),
  Machine_Code   VARCHAR(10), Operation_Code VARCHAR(10), Dept_ID VARCHAR(5), Item_Code VARCHAR(30),
  Delivery_Status VARCHAR(10), Is_Repeat_Order VARCHAR(3),
  WO_Qty INT, Press_Qty INT, Processed_Qty INT, Produced_Qty INT, Rejected_Qty INT,
  Today_Manufactured_Qty INT, Total_Qty BIGINT, Total_Value DECIMAL(14,2),
  Per_Day_Machine_Cost DECIMAL(10,2), Rejection_Rate_Pct DECIMAL(6,2),
  Efficiency_Rate_Pct DECIMAL(6,2), Machine_Utilization_Pct DECIMAL(6,2), Cost_per_Unit DECIMAL(10,2)
);

select 'fact_production',count(*) from fact_production
union all select 'dim_buyer',count(*) from dim_buyer
union all select 'dim_customer',count(*) from dim_customer
union all select 'dim_item',count(*) from dim_item
union all select 'dim_employee',count(*) from dim_employee
union all select 'dim_operation',count(*) from dim_operation
union all select 'dim_machine',count(*) from dim_machine
union all select 'dim_department',count(*) from dim_department
union all select 'dim_date',count(*) from dim_date;

-- View
select * from fact_prod;
select count(doc_num) from fact_prod;


-- KPI-1
-- Count no. of Work Orders

select count(*) as Total__no_of_WO from fact_prod;

-- KPI-2
-- Total WO Qty
select sum(WO_Qty) as Total_WO_Qty from fact_prod;

-- KPI-3
-- Total Processed Qty

select sum(Processed_Qty) as Total_Processed_Qty from fact_prod;

-- KPI - 4
-- Total Produced Qty

select sum(Produced_Qty) as Total_Produced_Qty from fact_prod;

-- KPI-5
-- Total Rejected Qty

select sum(Rejected_Qty) as Total_Rejected_Qty from fact_prod;

-- KPI-6
-- efficiency rate

select ROUND(sum(Produced_Qty)  / sum(Processed_Qty) * 100, 2) AS efficiency_per from fact_prod;


-- KPI-7
-- Machine Utilization %
select Round(Sum(Processed_Qty)/sum(Wo_Qty)*100,2) as Machine_Util_per from fact_prod;

-- KPI-8
-- Rejection Rate %

select Round(Sum(Rejected_Qty)/Sum(Produced_Qty)*100,2) as Rejection_Rate from fact_prod;

-- KPI-9
-- Wastage %
select Round(Sum(Rejected_Qty)/Sum(Processed_Qty)*100,2) as Wastage_per from fact_prod;

-- KPI-10
-- Total Wastage %

select round(sum(Rejected_Qty) /(sum(Produced_Qty) - sum(Rejected_Qty)) * 100,2) as Total_Wastage_Per from fact_prod;

-- KPI-11
-- On Time Delivery %

select round(count( 
case when delivery_status="On time" then 1 end)/count(*)*100,2) as OnTime_delivery_per from fact_prod;

-- KPI-12
-- Repeat Order ="yes"

select round(count(
case when is_repeat_order="Yes" then 1 end)/count(*)*100,2) as Repeated_Orders from fact_prod;

-- KPI 13
-- Total Production Cost
select sum(Total_Value) as Total_Manufacturing_Cost FROM fact_prod;

-- KPI 14
-- Cost per Unit
select round(sum(total_value)/sum(produced_qty),2) as Cost_Per_Unit from fact_prod; 

-- KPI  15
-- Machine Rejection Qty
select m.machine_code,m.Machine_Type,sum(f.rejected_qty) as Rejection_Quantity from fact_prod f left join dim_machine m on f.machine_code=m.Machine_Code 
where m.Machine_Type is not null  group by m.machine_code order by rejection_quantity desc;

-- KPI 16
--  employee wise rejected qty

select f.employee_code,e.employee_name,sum(f.rejected_qty) as rejected_quantity from fact_prod f left join dim_employee e on f.employee_code=e.Employee_Code
 group by f.employee_code order by rejected_quantity desc ;
 
 
 -- Operation wise rejected qty
 select f.operation_code,o.operation_name,sum(f.rejected_qty) as rejected_quantity from fact_prod f left join dim_operation o on f.operation_code=o.operation_Code
 group by f.operation_code order by rejected_quantity desc ;
 
 -- KPI 17
 -- department vs manufactured wise rjected quantity
 
 select d.dept_id,d.dept_name,sum(f.produced_qty) as produced_quantity,sum(f.rejected_qty) as rejected_quantity from fact_prod f left join dim_department d on f.dept_id=d.dept_id group by d.dept_id,d.dept_id;

-- KPI 18
-- monthly wise manufacturing qty

select d.Month_Num,d.Month_Name,sum(f.Produced_Qty) AS Total_Manufactured_Qty from fact_prod f left join dim_date d on f.Date_FK = d.Date
group by d.Month_Num, d.Month_Name
order by d.Month_Num asc;


-- KPI 19
-- Avergae per day machine cost
select round(avg(per_day_machine_cost),2) as Avergae_per_day_cost from fact_prod;
