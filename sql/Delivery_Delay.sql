LOAD DATA LOCAL INFILE 'C:/Users/Pushpa/Downloads/delivery_data_clean.csv'
INTO TABLE delivery_data_clean
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#h How many total records/ordres are there?
SELECT COUNT(*) AS total_orders
FROM delivery_data_clean;

# howmanyorder are there fro each Delivery status?
select `Delivery Status` , count(*)total_order
from delivery_data_clean
group by `Delivery Status`;

# howmany order are there fro each shipping mode?
select `Shipping Mode` , count(*)total_order
from delivery_data_clean
group by `Shipping Mode`; 

# how many order are there for each customer segment?
select `Customer Segment` , count(*)total_order
from delivery_data_clean
group by `Customer Segment`;

# how mnay ordera re there for each order region?
select `Order Region` , count(*)total_order
from delivery_data_clean
group by `Order Region`;

# howmayn order are there for each category?

select `Category Name` , count(*)total_order
from delivery_data_clean
group by `Category Name`;

# what is teh toal sales ?

select sum(`Sales`)
from delivery_data_clean;

# hwhatis the average sales?
select avg(`Sales`)
from delivery_data_clean;

# whatis the minimum and maximum slaes?

select max(`Sales`) as Maximum_sales, min(`sales`) as Minimum_sales
from delivery_data_clean;

# waht is the average  actual shipping time?
select avg(`Days for shipping (real)`)
from delivery_data_clean;

# waht is the average  scheduled shipping time?
select avg(`Days for shipment (scheduled)`)
from delivery_data_clean;

# how many late deliveries are there ?
select count(*) as Late_deliveries
from delivery_data_clean
where `Delivery Status`='Late delivery';

# how many shipped on times deliveries are there ?
select count(*) as Ship_on_time
from delivery_data_clean
where `Delivery Status`='Shipping on time';

# how many shipped afvance deliveries are there ?
select count(*) as advance_ship
from delivery_data_clean
where `Delivery Status`='Advance shipping';

# how many shipped cancall deliveries are there ?
select count(*) as canceled_ship
from delivery_data_clean
where `Delivery Status`='Shipping canceled';

# add new column in table 

ALTER TABLE delivery_data_clean
ADD COLUMN `Delivery Delay` INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE delivery_data_clean
SET `Delivery Delay` =
    `Days for shipping (real)`
    - `Days for shipment (scheduled)`;

SELECT COUNT(*) AS delayed_orders
FROM delivery_data_clean
WHERE `Delivery Delay` > 0;

SELECT COUNT(*) AS on_time
FROM delivery_data_clean
WHERE `Delivery Delay`= 0;

SELECT COUNT(*) AS advance_orders
FROM delivery_data_clean
WHERE `Delivery Delay`< 0;

select distinct `shipping Mode`
from delivery_data_clean;

select distinct `Delivery Status`
from delivery_data_clean;

#Which regions have the most late deliveries?
select `Order region`, count(*) no_of_order
from delivery_data_clean
where `Delivery Status`= 'Late delivery'
group by `Order Region`
order by no_of_order ; 

#what is the  late deliveries rate for each region?

select `Order region`,round(
			sum(Case
            when `Delivery Status`= 'Late delivery' then 1
            else 0
            end
            ) / count(*) * 100 
,2) as late_delivery_rate
from delivery_data_clean
group by `Order Region`
order by Late_delivery_rate desc;


#Which shipping mode has the highest late-delivery rate?

select `Shipping Mode`,
round(sum(case 
when `Delivery Status`="Late delivery" then 1
else 0
end
)/count(*)*100,2) as late_delivery_rate
from delivery_data_clean
group by `Shipping Mode`
order by Late_delivery_rate DESC;

#Which product categories have the most late deliveries?

select `Category Name`,count(*) as total_late_orders
from delivery_data_clean
where `Delivery Status`='Late delivery'
group by `Category Name`
order by total_late_orders DESC;

#What is the late-delivery rate for each category?
select `Category Name`,
round(sum(case 
when `Delivery Status`="Late delivery" then 1
else 0
end
)/count(*)*100,2) as late_delivery_rate_forCategory
from delivery_data_clean
group by `Category Name`
order by late_delivery_rate_forCategory DESC;

#Which customer segment has the highest late-delivery rate?
select `Customer Segment`,
round(sum(case 
when `Delivery Status`="Late delivery" then 1
else 0
end
)/count(*)*100,2) as late_delivery_rate_forCust
from delivery_data_clean
group by `Customer Segment`
order by late_delivery_rate_forCust DESC;


#What is the average actual shipping time for each shipping mode?
select `Shipping Mode`,avg(`Days for shipping (real)`) as average_actual_shipping_time 
from delivery_data_clean
group by `Shipping Mode`
order by average_actual_shipping_time;


#What is the average delivery delay for each shipping mode?
select `Shipping Mode`,avg(`Delivery Delay`) as average_delay
from delivery_data_clean
group by `Shipping Mode`
order by average_delaysahil;

#Which regions have an average delivery delay greater than 0?
select `Order Region`, avg(`Delivery Delay`) as average_delay
from delivery_data_clean
group by `Order Region`
having avg(`Delivery Delay`) > 0
order by average_delay desc;

#Which categories have more than 5,000 orders?
select `Category Name` , count(*) as orders
from delivery_data_clean
group by `Category Name`
having count(*) >5000
order by orders desc;

#What is total sales by region?
select `Order Region` ,sum(`Sales`) as Total_sales
from delivery_data_clean
group by `Order Region`;


#What is average sales by customer segment?

select `Customer Segment` , avg(Sales) avg_sales
from delivery_data_clean
group by `Customer Segment`
order by avg_sales desc;

#What is the monthly order volume?
SELECT
    YEAR(`order date (DateOrders)`) AS order_year,
    MONTH(`order date (DateOrders)`) AS order_month,
    COUNT(*) AS order_volume
FROM delivery_data_clean
GROUP BY
    YEAR(`order date (DateOrders)`),
    MONTH(`order date (DateOrders)`)
ORDER BY
    order_year,
    order_month;
    
#What is the monthly late-delivery count?

SELECT
    order_month_year,
    sum(case
    when `Delivery Status`='Late delivery'then 1
    else 0
    end 
    ) as total_late_del
FROM delivery_data_clean
GROUP BY order_month_year
order by total_late_del desc;

#Compare late deliveries across shipping modes and customer segments.

SELECT
    `Shipping Mode`,
    `Customer Segment`,
    COUNT(*) AS late_deliveries
FROM delivery_data_clean
WHERE `Delivery Status` = 'Late delivery'
GROUP BY
    `Shipping Mode`,
    `Customer Segment`
ORDER BY late_deliveries DESC;

#Advacne Sql

#Which regions have more late deliveries than the average number of late deliveries across all regions?
select `Order Region` ,count(*) as toal_lateOrder
from delivery_data_clean
where `Delivery Status`='Late delivery'
group by `Order Region`
having count(*) > (
select avg(regiontoal_lateOrder)
from(
select `Order Region` ,count(*) as regiontoal_lateOrder
from delivery_data_clean
where `Delivery Status`='Late delivery'
group by `Order Region`
)as regional_data
);

select `Category Name`,sum(Sales) as total_sales
from delivery_data_clean
group by `Category Name`
having sum(Sales) > (
select avg(total_sales)
from (
select `Category Name`, sum(Sales) as total_sales
from delivery_data_clean
group by `Category Name`
)as categorySUm
);

#Calculate the late-delivery rate for each region using a CTE.

with Late_deli_rate as(
select `Order Region`,
round(sum(case
when `Delivery Status`='Late Delivery' then 1
else 0
end)/count(*)*100,2) as  Late_Delivery_rate
from delivery_data_clean
group by `Order Region`)

select `Order Region`, Late_delivery_rate
from Late_deli_rate;

#Find the top 5 regions by total sales using a CTE.

with top_5_region as (
select `Order Region`, sum(Sales) as total_sales
from delivery_data_clean
group by `Order Region`
order by total_sales desc
Limit 5
)
select `Order Region` from top_5_region;


#Rank regions by total sales.

with region_sales as (
select `Order Region`,
sum(Sales) as total_region_sales
from delivery_data_clean
group by `Order Region`
)
select `Order Region`,total_region_sales,
rank() over( order by total_region_sales) as rankN
from region_sales;


#Rank categories by late-delivery rate.
with category_Late_deil_rate as(select 
`Category Name`,
round(sum(case 
when `Delivery Status`='Late delivery' then 1
else 0
end)/count(*)*100,2) as late_delivery_rate
from delivery_data_clean
group by `Category Name`
)
select `Category Name`,
late_delivery_rate,
dense_rank()over(order by late_delivery_rate) as rankforLateByCategory
from category_Late_deil_rate;

#Rank shipping modes by average delivery delay.
with shipModeAvg as(
select `Shipping Mode`,
avg(`Delivery Delay`) as avg_delay
from delivery_data_clean
group by `Shipping MOde`
)
select 
`Shipping Mode`,
avg_delay,
Row_Number()over(order by avg_delay)
from shipModeAvg;

#Find the top 3 categories in each region by total sales?

with categorySales as(
select 
`Order Region`,
`Category Name`,
sum(Sales) as total_sales
from delivery_data_clean
group by `Order Region`,
`Category Name`
),
top3 AS (
SELECT `Order Region`,
`Category Name`,
total_sales,
ROW_NUMBER ()over(partition by `Order Region` order by total_sales desc) category_rank
from categorySales
)

select *  from top3
where category_rank <=3
order by `Order Region`, category_rank;

#Compare each month's late deliveries with the previous month.

WITH each_Month AS (
    SELECT
        order_month_year,
        COUNT(*) AS total_late_deli
    FROM delivery_data_clean
    WHERE `Delivery Status` = 'Late delivery'
    GROUP BY order_month_year
)
SELECT
    order_month_year,
    total_late_deli,
    LAG(total_late_deli) OVER (
        ORDER BY order_month_year
    ) AS previous_month_late_deli
FROM each_Month;


#1. Identify regions with high sales + high late-delivery rates using a CTE and window function.?

WITH region_analysis AS (
    SELECT
        `Order Region`,
        SUM(Sales) AS total_sales,
        ROUND(
            SUM(
                CASE
                    WHEN `Delivery Status` = 'Late delivery' THEN 1
                    ELSE 0
                END
            ) / COUNT(*) * 100,
            2
        ) AS late_delivery_rate
    FROM delivery_data_clean
    GROUP BY `Order Region`
),

region_with_avg AS (
    SELECT
        `Order Region`,
        total_sales,
        late_delivery_rate,
        AVG(total_sales) OVER () AS avg_regional_sales,
        AVG(late_delivery_rate) OVER () AS avg_late_delivery_rate
    FROM region_analysis
)

SELECT
    `Order Region`,
    total_sales,
    late_delivery_rate,
    RANK() OVER (
        ORDER BY late_delivery_rate DESC
    ) AS late_delivery_rank
FROM region_with_avg
WHERE total_sales > avg_regional_sales
  AND late_delivery_rate > avg_late_delivery_rate
ORDER BY late_delivery_rank;