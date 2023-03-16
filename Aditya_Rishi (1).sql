-- Queries on Reliant Retail Limited's orders database
-- A Great Learning project
-- Filed by Aditya Rishi
-- PGP-DSBA Feb-2021

use orders;

-- Q7
-- Write a query to 
-- Display carton id, (len*width*height) as carton_vol 
-- and identify the optimum carton 
-- (carton with the least volume whose volume is 
-- greater than the total volume of all items (len * width * height * product_quantity)) 
-- for a given order whose order id is 10006, 
-- Assume all items of an order are packed into one single carton.

select c.CARTON_ID, (c.LEN*c.WIDTH*c.HEIGHT) as CARTON_VOL from CARTON c
where (c.LEN*c.WIDTH*c.HEIGHT) >
(select sum(p.LEN*p.WIDTH*p.HEIGHT*oi.PRODUCT_QUANTITY) as TOTAL_VOLUME 
from ORDER_ITEMS oi 
	inner join PRODUCT p
		on oi.PRODUCT_ID=p.PRODUCT_ID
where oi.ORDER_ID=10006)
order by CARTON_VOL asc LIMIT 1;

-- Q8
-- Write a query to 
-- Display details (customer id,customer fullname,order id,product quantity) 
-- of customers who bought more than ten (i.e. total order qty) 
-- products per shipped order. 

select oc.CUSTOMER_ID, concat(oc.CUSTOMER_FNAME,' ',oc.CUSTOMER_LNAME) as FULLNAME,oh.ORDER_ID, sum(oi.PRODUCT_QUANTITY) as TOT_Orders
from online_customer oc 
	inner join order_header oh on
		oc.CUSTOMER_ID=oh.CUSTOMER_ID
	inner join order_items oi on
		oh.ORDER_ID = oi.ORDER_ID 
where oh.ORDER_STATUS='Shipped'
group by oi.ORDER_ID having sum(oi.PRODUCT_QUANTITY) > 10;

-- Q9
-- Write a query to 
-- Display the order_id, customer id and cutomer full name of customers 
-- along with (product_quantity) as total quantity of products 
-- shipped for order ids > 10060. 

select oc.CUSTOMER_ID, oh.ORDER_ID,concat(oc.CUSTOMER_FNAME,' ',oc.CUSTOMER_LNAME) as FULLNAME,sum(oi.PRODUCT_QUANTITY) as TOT_Orders
from ONLINE_CUSTOMER oc 
	inner join ORDER_HEADER oh on
		oc.CUSTOMER_ID=oh.CUSTOMER_ID
	inner join ORDER_ITEMS oi on
		oh.ORDER_ID = oi.ORDER_ID 
where oh.ORDER_STATUS='Shipped'
group by oi.ORDER_ID having oi.ORDER_ID> 10060;

-- Q10
-- Write a query to 
-- Display product class description, 
-- total quantity (sum(product_quantity), Total value 
-- (product_quantity * product price) 
-- and show which class of products have been shipped highest(Quantity) 
-- to countries outside India other than USA? 
-- Also show the total value of those items.

SELECT PRODUCT_CLASS_DESC, SUM(PRODUCT_QUANTITY) AS TOTAL_QUANTITY, 
   SUM(PRODUCT_QUANTITY*PRODUCT_PRICE) AS TOTAL_VALUE
   FROM PRODUCT P
   INNER JOIN PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
   INNER JOIN ORDER_ITEMS OI ON OI.PRODUCT_ID = P.PRODUCT_ID
   INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID = OI.ORDER_ID
   INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID = OH.CUSTOMER_ID
   INNER JOIN ADDRESS A ON A.ADDRESS_ID = OC.ADDRESS_ID
   WHERE ORDER_STATUS = 'Shipped' AND COUNTRY NOT IN ('India','USA')
   GROUP BY PRODUCT_CLASS_DESC
   ORDER BY TOTAL_QUANTITY DESC LIMIT 1;