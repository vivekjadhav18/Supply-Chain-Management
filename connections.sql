ALTER TABLE `=calendar` 
MODIFY Date DATE;

ALTER TABLE `f_sales`
MODIFY Date DATE;

SELECT Date, COUNT(*) FROM `=calendar`  GROUP BY Date HAVING COUNT(*) > 1;
SELECT `Cust Key`, COUNT(*) FROM `Customer` GROUP BY `Cust Key` HAVING COUNT(*) > 1;
SELECT `Store Key`, COUNT(*) FROM `d_store` GROUP BY `Store Key` HAVING COUNT(*) > 1;
SELECT `Product Key`, COUNT(*) FROM `d_product` GROUP BY `Product Key` HAVING COUNT(*) > 1;
SELECT `Order Number`, COUNT(*) FROM `f_sales` GROUP BY `Order Number` HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM `customer` WHERE `Cust Key` IS NULL;
SELECT COUNT(*) FROM `d_store` WHERE `Store Key` IS NULL;
SELECT COUNT(*) FROM `f_sales` WHERE `Order Number` IS NULL;


ALTER TABLE `=calendar` ADD CONSTRAINT pk_calendar PRIMARY KEY (Date);
ALTER TABLE `customer` ADD CONSTRAINT pk_customer PRIMARY KEY (`Cust Key`);
ALTER TABLE `d_store` ADD CONSTRAINT pk_store PRIMARY KEY (`Store Key`);
ALTER TABLE`d_product` ADD CONSTRAINT pk_product PRIMARY KEY (`Product Key`);
ALTER TABLE `f_sales` ADD CONSTRAINT pk_sales PRIMARY KEY (`Order Number`);


SELECT DISTINCT `Store Key`
FROM `f_sales`
WHERE `Store Key` NOT IN (SELECT `Store Key` FROM `d_store`);

SELECT DISTINCT `Product Key`
FROM pos
WHERE `Product Key` NOT IN (SELECT `Product Key` FROM `d_product`);

SELECT DISTINCT `Order Number`
FROM pos
WHERE `Order Number` NOT IN (SELECT `Order Number` FROM `f_sales`);
desc pos;

ALTER TABLE pos 
rename column `ï»¿Order Number`  to `Order Number` ;

SELECT DISTINCT Date
FROM `f_sales`
WHERE Date NOT IN (SELECT Date FROM `=calendar`);


ALTER TABLE `f_sales` 
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (`Cust Key`)
REFERENCES `customer`(`Cust Key`);

ALTER TABLE `f_sales`
ADD CONSTRAINT fk_sales_store
FOREIGN KEY (`Store Key`)
REFERENCES `d_store`(`Store Key`);-----

ALTER TABLE `f_sales`
ADD CONSTRAINT fk_sales_calendar
FOREIGN KEY (Date)
REFERENCES `=calendar`(Date);
desc `f_sales`;
desc `=calendar`; 

INSERT INTO `=calendar`(Date)
SELECT DISTINCT Date
FROM `f_sales`
WHERE Date NOT IN (SELECT Date FROM `=calendar`);

UPDATE `f_sales`
SET Date = '2024-01-01'
WHERE Date NOT IN (SELECT Date FROM `=calendar`)
   OR Date IS NULL;
   ALTER TABLE `f_sales`
ADD CONSTRAINT fk_sales_calendar
FOREIGN KEY (Date)
REFERENCES `=calendar`(Date);

   
   


select distinct `Store Key` from `f_sales`
where `Store Key` not in (select `Store Key` from `d_store`);
insert into `d_store` (`Store Key`)  

select distinct `Store Key` from `f_sales` 
where `Store Key` not in ( select  `Store Key` from `d_store`);

delete from `f_sales` 
where `Store Key` not in ( select  `Store Key` from `d_store`);

update  `f_sales` set `Store Key`=null
where `Store key` not in (select `Store Key` from `d_store`);




ALTER TABLE pos
ADD CONSTRAINT fk_pos_sales
FOREIGN KEY (`Order Number`)
REFERENCES `f_sales`(`Order Number`);

SELECT DISTINCT `Order Number`
FROM pos
WHERE `Order Number` NOT IN (SELECT `Order Number` FROM f_sales)
   OR `Order Number` IS NULL;
DESC `pos`;
DESC `f_sales`;
SELECT DISTINCT `Order Number`
FROM pos
WHERE TRIM(`Order Number`) NOT IN (SELECT TRIM(`Order Number`) FROM f_sales);
DELETE FROM pos
WHERE `Order Number` NOT IN (SELECT `Order Number` FROM f_sales)
   OR `Order Number` IS NULL;
   ALTER TABLE pos
ADD CONSTRAINT fk_pos_sales
FOREIGN KEY (`Order Number`)
REFERENCES f_sales(`Order Number`);






ALTER TABLE pos
ADD CONSTRAINT fk_pos_product
FOREIGN KEY (`Product Key`)
REFERENCES`d_product`(`Product Key`);


use project ;
create table fact_sales as
with fact as ( select
	s.`Order Number`,
    s.Date as Date_key,
    s.`Cust Key` as Customer_key,
    s.`Store Key`,
    po.`Product Key`,
    po.`Sales Quantity`,
    po.`Sales Amount`,
    po.`Cost Amount` from `f_sales` s
left join pos po on s.`Order Number`=po.`Order Number`)
select f.`Order Number`,f.Date_key,
	   d.`Fiscal Year`,d.`Season`,d.`Fiscal Quarter`d,`Fiscal Period` ,
       c.`Cust Name`,c.`Cust region`,c.`Age Group`,c.`Loyalty Program`,
       st.`Store Size`,st.`Monthly Rent Cost`,st. `Online Ordering` ,st.`Selling Square Footage`,
       p.`Product Name`,p.`Product Type`,p.`Product Group`,p.`Price`,
       cnt.`State Name` ,cnt. `County Name`,
       f.`Sales Quantity`,f.`Sales Amount`,f.`Cost Amount` from fact f
left join  `=calendar` d on  f.Date_key=d.`Date`
left join   `Customer` c on f.Customer_key= c.`Cust Key`
left join   `d_store` st on f.`Store Key`=st.`Store Key`
left join d_product p on f.`Product Key`= p.`Product Key`
left join `d_geojson_us_counties`cnt on c.`Cust Region`=cnt.`State Name`;



