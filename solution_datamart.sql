create table clean_weekly_sales as
select 
week_date,
week(week_date) as week_number,
month(week_date) as month_number,
year(week_date) as year_number,
region,
platform,
case 
	when segment = "null" then "unknown"
    else segment 
end 
as segment, 
case 
	when right(segment,1) = "1" then "Youngh Adult"
	when right(segment,1) = "2" then "Middle age"
	when right(segment,1) in ("3","4") then "Retairee"
    else "Unknown"
end 
as age_band,
case 
	when left(segment,1) = "C" then "Couples"
	when left(segment,1) = "F" then "Families"
    else "Unknown"
end 
as demographic,
customer_type,
transactions,
sales,
round(sales/transactions, 2) as weekly_transacctions
from weekly_sales; 


select * from clean_weekly_sales
limit 10;



-- 1. Which week numbers are missing from the dataset?
select distinct week_number 
from clean_weekly_sales
order by week_number

-- 2. How many total transactions were there for each year in the dataset?
select count(transactions) as total_transaction, year_number
from clean_weekly_sales
group by year_number

-- 3. What are the total sales for each region for each month? 
select region , month_number , sum(sales) as total_sales
from clean_weekly_sales
group by region, month_number

-- 4. What is the total count of transactions for each platform?
 select  platform, sum(transactions) as no_of_transaction
 from clean_weekly_sales
 group by platform
 
 
-- 5. What is the percentage of sales for Retail vs Shopify for each month?
select month_number 


-- 6. What is the percentage of sales by demographic for each year in the dataset?
select demographic, year_number , round( 100 * sum(sales)/ sum(sum(sales)) over (partition by demographic),2) as  percentage_of_sales
from clean_weekly_sales
group by demographic, year_number


-- 7. Which age_band and demographic values contribute the most to Retail sales?
select age_band, demographic, sum(sales) as total_sales
from clean_weekly_sales
where platform = "Retail"
group by age_band, demographic