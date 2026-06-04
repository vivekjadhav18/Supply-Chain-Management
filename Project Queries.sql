use project;             
             # Total sales
       
SELECT SUM(`Sales Amount`) AS Total_Sales
FROM fact_sales;
   
               # QTD -sales
             
 SELECT YEAR(s.Date_key) AS Year,QUARTER(s.Date_key) AS Quarter,
SUM(s.`Sales Amount`) AS Total_Sales
FROM fact_sales s
GROUP BY YEAR(s.Date_key),QUARTER(s.Date_key)
ORDER BY Year,Quarter; 

            # YTD -sales 
    
SELECT YEAR(s.Date_key) AS Year, SUM(p.`Sales Amount`) AS Total_Sales
FROM  fact_sales s
LEFT JOIN pos p ON s.`Order Number` = p.`Order Number`
LEFT JOIN `=calendar` c ON s.Date_key= c.`Date`
GROUP BY YEAR(s.Date_key);

              # Monthly wise sales

SELECT YEAR(f.Date_key) AS Year_No,
MONTHNAME(f.Date_key) AS Month_Name, SUM(p.`Sales Amount`) AS Monthly_Sales
FROM fact_sales f
JOIN pos p ON f.`Order Number` = p.`Order Number`
GROUP BY YEAR(f.Date_key), MONTHName(f.Date_key)
ORDER BY Year_No, Month_Name;

             # Product Wise Sales

SELECT p.`Product Name`,SUM(po.`Sales Amount`) AS Total_Sales FROM pos po
JOIN d_product p ON po.`Product Key` = p.`Product Key`
GROUP BY p.`Product Name`
ORDER BY Total_Sales DESC;

          #Sales Growth (Month over Month)

SELECT DATE_FORMAT(f.Date_key, '%Y-%m') AS Month,
SUM(po.`Sales Amount`) AS Sales,
LAG(SUM(po.`Sales Amount`)) OVER (ORDER BY DATE_FORMAT(f.Date_key, '%Y-%m')) AS Prev_Month_Sales,
((SUM(po.`Sales Amount`) - LAG(SUM(po.`Sales Amount`)) OVER (ORDER BY DATE_FORMAT(f.Date_key, '%Y-%m')))
/ LAG(SUM(po.`Sales Amount`)) OVER (ORDER BY DATE_FORMAT(f.Date_key, '%Y-%m'))) * 100 AS Growth_Percentage    
FROM fact_sales f
JOIN pos po ON f.`Order Number` = po.`Order Number`
GROUP BY DATE_FORMAT(f.Date_key, '%Y-%m');

                  #Daily Sales Trend 

SELECT f.Date_key, SUM(po.`Sales Amount`) AS Daily_Sales
FROM fact_sales f
JOIN pos po ON f.`Order Number` = po.`Order Number`
GROUP BY f.Date_key
ORDER BY f.Date_key;

                    # Total Inventory
SELECT SUM(`Quantity on Hand`) AS Total_Inventory
FROM f_inventory_adjusted;

					#  inventory value

SELECT  round(SUM(`Quantity on Hand` * `Cost Amount`),4) AS Inventory_Value
FROM f_inventory_adjusted;

					# Top 5 Store Wise Sales
                    
SELECT s.`Store Name`, SUM(po.`Sales Amount`) AS Store_Sales FROM `f_sales` f
JOIN pos po ON f.`Order Number` = po.`Order Number`
JOIN `d_store` s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Name`
ORDER BY Store_Sales DESC
LIMIT 5;

                  #Region Wise Sales 

SELECT s.`Store Region`, SUM(po.`Sales Amount`) AS Region_Sales
FROM `f_sales` f
JOIN pos po ON f.`Order Number` = po.`Order Number`
JOIN d_store s ON f.`Store Key` = s.`Store Key`
GROUP BY s.`Store Region`
ORDER BY Region_Sales DESC;

                 #   Purchase Method Wise Sales
       
SELECT d.`Purchase Method`,
SUM(po.`Sales Amount`) AS Total_Sales FROM `f_sales` d
JOIN pos po ON d.`Order Number` = po.`Order Number`
GROUP BY d.`Purchase Method`;

			# Average sales by Product Group 

SELECT `Product Group`,AVG(Daily_Sales) AS Avg_Daily_Sales
FROM (SELECT `Product Group`, SUM(`Quantity on Hand`) AS Daily_Sales
FROM  `f_inventory_adjusted`
GROUP BY `Product Group`) t
GROUP BY `Product Group`;




                 # State Wise Sales 
 --------
 SELECT s.`Store State`,SUM(po.`Sales Amount`) AS State_Sales
FROM fact_sales f
JOIN pos po ON f.`Order Number` = po.`Order Number`
JOIN `d_store` s ON f.`Store Size` = s.`Store Size`
GROUP BY s.`Store State`
ORDER BY State_Sales DESC;











