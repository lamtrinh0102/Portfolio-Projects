-- Create the table schema with dummy data in db-fiddle
CREATE TABLE Sales (
  "product_id" INTEGER,
  "store_id" INTEGER,
  "customer_id" INTEGER,
  "promotion_id" INTEGER,
  "store_sales" DECIMAL,
  "store_cost" DECIMAL,
  "units_sold" DECIMAL,
  "transaction_date" DATE
);

INSERT INTO Sales
  ("product_id", "store_id", "customer_id", "promotion_id", "store_sales","store_cost","units_sold","transaction_date")
VALUES
  ('3', '46', '1', '1', '5642','4000','1','2021-01-02 12:28:20'),
  ('5', '63', '2', '2', '4434','3000','1','2021-01-02 14:48:40'),
  ('7', '63', '3', '5', '5434','2000','1','2021-01-03 14:48:40'),
  ('3', '23', '4', '8', '9452','7000','1','2021-01-14 12:28:50'),
  ('8', '24', '5', '4', '2352','1000','1','2021-01-14 12:24:60'),
  ('5', '53', '4', '7', '3552','3000','1','2021-01-04 12:28:21'),
  ('5', '53', '6', '9', '4652','2000','1','2021-03-14 12:28:21'),
  ('10','53','7','3', '5632','5000','1','2021-03-10 12:28:21'),
  ('9', '53', '5', '8', '4532','4000','1','2021-03-10 12:28:21'),
  ('5', '53', '3', '1', '3552','3000','1','2021-03-10 12:28:21'),
  ('6', '53', '2', '10', '1532','1000','1','2021-03-10 12:28:21'),
  ('4', '46', '1', '4', '5342','4500','1','2021-04-22 12:28:20'),
  ('10','63', '8', '6', '4334','3500','1','2021-04-22 14:48:40'),
  ('5', '63', '9', '2', '4454','3400','1','2021-04-23 14:48:40'),
  ('3', '23', '10', '1','4452','4000','1','2021-05-24 12:28:50'),
  ('9', '24', '6', '2', '4552','3000','1','2021-05-15 12:24:60'),
  ('5', '53', '3', '5', '4552','2000','1','2021-05-02 12:28:21'),
  ('4', '53', '2', '4', '4432','3000','1','2021-05-03 12:28:21'),
  ('5', '53', '1', '3', '5732','4000','1','2021-05-10 12:28:21'),
  ('7', '53', '1', '4', '4732','3000','1','2021-05-10 12:28:21'),
  ('8', '53', '3', '6', '3732','3000','1','2021-05-10 12:28:21'),
  ('5', '53', '10','2', '1732','1000','1', '2021-05-10 12:28:21');
  
  CREATE TABLE products (
  "product_id" INTEGER,
  "product_class_id" INTEGER,
  "brand_name" VARCHAR,
  "product_name" VARCHAR,
  "is_low_fat_flg" INT,
  "is_recyclable_flg" INT,
  "gross_weight" DECIMAL,
  "net_weight" decimal,
  CONSTRAINT "PK_products_product_id" PRIMARY KEY ("product_id")
);

INSERT INTO Products
  ("product_id", "product_class_id","brand_name", "product_name", "is_low_fat_flg","is_recyclable_flg","gross_weight","net_weight")
VALUES
  ('1', '1', 'A1', 'AB', '10','10','22','20'),
  ('2', '1', 'B1', 'BB', '20','30','50','40'),
  ('3', '2', 'C1', 'CB', '34','20','67','40'),
  ('4', '2', 'D1', 'DB', '52','70','90','50'),
  ('5', '3', 'E1', 'EB', '52','10','54','60'),
  ('6', '3', 'A2', 'AB1', '10','10','22','20'),
  ('7', '4', 'B2', 'BB1', '20','30','50','40'),
  ('8', '4', 'C2', 'CB1', '34','20','67','40'),
  ('9', '5', 'D2', 'DB1', '52','70','90','50'),
  ('10', '5','E2', 'EB1', '52','10','54','60');

 CREATE TABLE promotions (
  "promotion_id" INTEGER,
  "promotion_name" VARCHAR,
  "media_type" VARCHAR,
  "cost" DECIMAL,
  "start_date" DATE,
  "end_date" DATE,
   CONSTRAINT "PK_promotions_promotion_id" PRIMARY KEY ("promotion_id")
);

INSERT INTO Promotions
  ("promotion_id","promotion_name", "media_type", "cost","start_date","end_date")
VALUES
  ('1', 'FB', 'Facebook','1060','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('2', 'TW', 'Twister','2010','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('3', 'INS', 'Instagram','3420','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('4', 'TIK', 'Tiktok1','2230','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('5', 'TIK', 'Tiktok2','3220','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('6', 'TIK1', 'Tiktok3','2210','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('7', 'TIK2', 'Tiktok4','2202','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('8', 'TIK3', 'Tiktok5','2205','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('9', 'TIK4', 'Tiktok6','2450','2021-01-02 12:28:20','2021-05-10 12:28:21'),
  ('10', 'GOG5', 'Google', '3540','2021-01-02 12:28:20','2021-05-10 12:28:21');
  
 CREATE TABLE product_classes (
  "product_class_id" INTEGER,
  "product_subcategory" VARCHAR,
  "product_category" VARCHAR,
  "product_department" VARCHAR,
  "product_family" VARCHAR,
   CONSTRAINT "PK_product_classes_product_class_id" PRIMARY KEY ("product_class_id")
);

INSERT INTO Product_classes
  ("product_class_id","product_subcategory","product_category", "product_department","product_family")
VALUES
  ('1', 'U1', 'X1', 'P1', 'F1'),
  ('2', 'U2', 'X2', 'L1', 'G1'),
  ('3', 'U3', 'X3', 'M1', 'H1'),
  ('4', 'U4', 'X4', 'P2', 'F2'),
  ('5', 'U5', 'X5', 'L2', 'G2');
 
 
 ALTER TABLE "sales" ADD CONSTRAINT "FK_sales_product_id" FOREIGN KEY ("product_id")
REFERENCES "products" ("product_id");
 ALTER TABLE "sales" ADD CONSTRAINT "FK_sales_promotion_id" FOREIGN KEY ("promotion_id")
REFERENCES "promotions" ("promotion_id");
 ALTER TABLE "products" ADD CONSTRAINT "FK_products_product_class_id" FOREIGN KEY ("product_class_id")
REFERENCES "product_classes" ("product_class_id");

--Solve 5 questions

/*1.What percent of all products in the grocery chain's catalog are both low fat and recyclable?*/

SELECT (CAST(COUNT(product_id) AS float)
        /
        CAST((SELECT COUNT(product_id) 
           		FROM products) AS float)
       )*100 AS pct_lowfat_recyclable
FROM products
WHERE is_low_fat_flg < 20 AND is_recyclable_flg < 20;

/*2.What are the top five (ranked in decreasing order) single-channel media types that correspond to the most money the 
grocery chain had spent on its promotional campaigns?*/

SELECT media_type AS single_channel_media_type, sum(cost) AS total_cost
FROM promotions
GROUP BY media_type
ORDER BY total_cost DESC
LIMIT 5;

/*3. Of sales that had a valid promotion, the VP of marketing wants to know what % of transactions occur on either the very 
first day or the very last day of a promotion campaign.*/

SELECT
(
CAST(
  (SELECT COUNT(*)
FROM Sales
LEFT JOIN promotions ON
	sales.promotion_id = promotions.promotion_id
WHERE sales.promotion_id IS NOT NULL AND
(DATE(sales.transaction_date) = DATE(promotions.start_date)
OR DATE(sales.transaction_date) = DATE(promotions.end_date))
) AS float)
/
CAST(
  (SELECT COUNT(*)
FROM sales
LEFT JOIN promotions ON
	sales.promotion_id = promotions.promotion_id
WHERE sales.promotion_id IS NOT NULL AND
(DATE(sales.transaction_date) BETWEEN DATE(promotions.start_date) AND DATE(promotions.end_date))
) AS float)	
)*100 AS pct_of_transactions_on_first_or_last_day_of_valid_promotion;

/*4. The CMO is interested in understanding how the sales of different product families are affected by promotional campaigns.
To do so, for each of the available product families, show the total number of units sold, as well as the ratio of units sold 
that had a valid promotion to units sold without a promotion, ordered by increasing order of total units sold.*/

WITH group_product_family AS (
SELECT product_family, sum(units_sold) AS total_units_sold
FROM sales 
LEFT JOIN products
	ON products.product_id = sales.product_id
LEFT JOIN product_classes 
	ON products.product_class_id = product_classes.product_class_id	
GROUP BY product_classes.product_family), 
total_units_with_promo AS (
SELECT product_family, sum(units_sold) AS total_units_promo
FROM sales 
LEFT JOIN products
	ON products.product_id = sales.product_id
LEFT JOIN product_classes 
	ON products.product_class_id = product_classes.product_class_id
WHERE sales.promotion_id IS NOT NULL
GROUP BY product_classes.product_family)

SELECT group_product_family.product_family, total_units_sold,
CASE WHEN
	total_units_sold = total_units_promo THEN 100     
    ELSE (total_units_promo / (total_units_sold-total_units_promo))*100
END AS ratio_units_sold_with_promo_to_sold_without_promo
FROM group_product_family
LEFT JOIN total_units_with_promo ON
	group_product_family.product_family = total_units_with_promo.product_family
ORDER BY total_units_sold DESC;

/*5. The VP of Sales feels that some product categories don't sell and can be completely removed from the inventory. As a first
pass analysis, they want you to find what percentage of product categories have never been sold.*/

WITH category_sold AS (
SELECT 
product_category, sum(store_sales)
FROM sales 
LEFT JOIN products
	ON products.product_id = sales.product_id
LEFT JOIN product_classes 
	ON products.product_class_id = product_classes.product_class_id	
GROUP BY product_classes.product_category)

SELECT
100 - (CAST((SELECT COUNT(*)
FROM category_sold) AS float)
/
CAST((SELECT COUNT(product_category)
FROM product_classes) AS float))*100 AS pct_product_categories_never_sold 