-- Assignment Day 1

/* Task 1: Retrieve customer data */

--Retrieve customer name data 
SELECT  
Title,  
FirstName, 
ISNULL(MiddleName, '') AS MiddleName, 
LastName, 
ISNULL(Suffix, '') AS Suffix 
FROM SalesLT.Customer;
 
-- Retrieve customer names and phone numbers 
SELECT  
SalesPerson,  
ISNULL(Title,'') +''+ FirstName AS CustomerName, 
Phone 
FROM SalesLT.Customer 

/* Task 2: Retrieve customer order data */ 

--Retrieve a list of customer companies
SELECT 
CAST(CustomerID AS nvarchar)+' : '+CompanyName AS CustomerCompanyName 
FROM SalesLT.Customer

-- Retrieve a list of sales order revisions 
SELECT 
SalesOrderNumber+' ('+CAST(RevisionNumber AS nvarchar)+')'  
AS Orders, 
CONVERT(date,OrderDate,102) AS OrderDate 
FROM SalesLT.SalesOrderHeader 

/* Task 3: Retrieve customer contact details (hard) */ 

--Retrieve customer contact names with middle names if known 

SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS CustomerName 
FROM SalesLT.Customer; 

-- Retrieve primary contact details 

SELECT 
CustomerID, 
CASE  
    WHEN ISNULL(EmailAddress,'NONE') = 'NONE' THEN Phone 
    ELSE EmailAddress 
END 
AS PrimaryContact 
FROM SalesLT.Customer 

-- Retrieve shipping status 

SELECT  
SalesOrderID,  
CONVERT(nvarchar,OrderDate,102) AS OrderDate,  
CASE  
    WHEN ShipDate IS NULL THEN 'Awaiting Shipment' 
    ELSE 'Shipped' 
END  
AS ShippingStatus  
FROM SalesLT.SalesOrderHeader 

-- Assignment Day 2

/* Task 1: Retrieve data for transportation reports? */ 

-- Retrieve a list of cities 

SELECT DISTINCT 
City, StateProvince 
FROM SalesLT.Address 
ORDER BY  
    StateProvince ASC, City DESC;

-- Retrieve the heaviest products information 

SELECT top 10 percent Name, Weight, 
DATEDIFF( 
    DAY,SellStartDate, ISNULL(SellEndDate,GETDATE()) 
) 
AS NumberOfSellsDay 
FROM SalesLT.Product 
ORDER BY Weight DESC;

/* Task 2: Retrieve product data */ 

-- Filter products by color, size and product number 

SELECT ProductID, ProductNumber,Name, Size 
FROM SalesLT.Product 
WHERE ProductNumber LIKE 'BK-[^T]%-[0-9][0-9]'AND 
(Color IN('Black','Red','White')OR Size IN('S','M')) 

-- Filter orders which bought filtered Product 

SELECT ProductID, ProductNumber,  
CASE WHEN LEFT(Name,PATINDEX('%_-%',name)) = '' THEN Name 
ELSE LEFT(Name,PATINDEX('%_-%',name)) 
END AS ProductName, 
    CASE  
    WHEN TRY_CAST(size as Int) < 43 THEN 'Small' 
    WHEN TRY_CAST(size as Int) BETWEEN 43 AND 57 THEN 'Medium' 
    WHEN TRY_CAST(size as Int) > 57 THEN 'Big' 
    ELSE 
    CASE Size 
        WHEN 'S' THEN 'Small' 
        WHEN 'M' THEN 'Medium' 
        WHEN 'L' THEN 'Medium' 
        WHEN 'XL' THEN 'Big' 
        ELSE ISNULL(CONVERT(varchar(10),Size),'No size') 
    END  
    END 
    AS GroupSize 
FROM SalesLT.Product; 

-- Assignment Day 3

/* Task 1: Generate invoice reports. */ 

-- Retrieve customer orders 

SELECT Cus.CompanyName, 
Head.SalesOrderID, 
Head.TotalDue 
FROM SalesLT.SalesOrderHeader AS Head 
LEFT JOIN SalesLT.Customer AS Cus  
    ON Head.CustomerID = Cus.CustomerID 
 
-- Retrieve customer orders with addresses 

SELECT CustomerID, 
AddressType,  
AddressLine1, 
AddressLine2, 
City, 
StateProvince, 
PostalCode, 
CountryRegion 
FROM SalesLT.CustomerAddress AS Cus_add 
LEFT JOIN SalesLT.Address AS Addr 
    ON Cus_add.AddressID = Addr.AddressID 
WHERE Cus_add.AddressType = 'Main Office' 

-- Retrieve Sales Information with Product (in slide)  

SELECT Detail.SalesOrderID, 
Detail.SalesOrderDetailID, 
Detail.ProductID, 
Prod.Name, 
Header.OrderDate, 
Detail.LineTotal, 
Header.SubTotal 
FROM SalesLT.SalesOrderDetail AS Detail 
LEFT JOIN SalesLT.SalesOrderHeader AS Header 
    ON Detail.SalesOrderID = Header.SalesOrderID 
LEFT JOIN SalesLT.Product AS Prod  
    ON Detail.ProductID = Prod.ProductID  

/* Task 2: Retrieve customer data. */ 

-- Retrieve a list of customers with no address 

SELECT Cus_Add.CustomerID, 
Cus.CompanyName, 
CONCAT_WS(' ',Cus.FirstName,Cus.LastName) AS ContactName, 
Cus.Phone, 
Addr.AddressLine2 
FROM SalesLT.CustomerAddress AS Cus_Add 
LEFT JOIN SalesLT.Customer AS Cus 
    ON  Cus_Add.CustomerID = Cus.CustomerID 
LEFT JOIN SalesLT.Address AS Addr 
    ON Cus_Add.AddressID = Addr.AddressID
WHERE Addr.AddressLine2 IS NULL  

-- Retrieve a list of products 

SELECT LEFT(Pro.Name,PATINDEX('%_-%',Pro.Name)) AS ProductName, 
pro.SellStartDate, 
Model.Name AS ModelName, 
Cate.Name AS CategoryName, 
ListPrice 
FROM SalesLT.Product AS Pro 
LEFT JOIN SalesLT.ProductCategory AS Cate 
    ON Pro.ProductCategoryID = Cate.ProductCategoryID 
LEFT JOIN SalesLT.ProductModel AS Model 
    ON Pro.ProductModelID = Model.ProductModelID 
WHERE  
YEAR(Pro.SellStartDate) = 2006 AND 
Model.Name LIKE '%road%' AND 
Cate.Name LIKE '%bikes%' AND 
LEFT(CAST(Pro.ListPrice AS varchar),PATINDEX('%_.%',CAST(Pro.ListPrice AS varchar))) = '2443'
 
/* Task 3: Retrieve Sales data. */ 

-- From dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales, Write a query display ProductKey, EnglishProductName which has discount percentage >= 20% 

SELECT Prod.ProductKey, 
Prod.EnglishProductName 
FROM FactInternetSales AS Sales 
LEFT JOIN DimProduct AS Prod  
    ON Sales.ProductKey = Prod.ProductKey 
LEFT JOIN DimPromotion AS Promo  
    ON sales.PromotionKey = promo.PromotionKey 
WHERE Promo.DiscountPct >= 0.2 

-- From FactInternetSales and FactResellerSale, DimProduct. Find all SalesOrderNumber  from 2 Fact tables which sales product that have Name contains 'Road' in name and Color is Yellow 

SELECT In_sales.SalesOrderNumber,'InternetSales' AS Type 
FROM FactInternetSales AS In_sales 
LEFT JOIN DimProduct AS Prod  
    ON In_sales.ProductKey = Prod.ProductKey 
WHERE Prod.ModelName LIKE '%road%' AND 
Prod.Color = 'Yellow' 
UNION ALL
SELECT Re_sales.SalesOrderNumber,'ResellerSales' 
FROM FactResellerSales AS Re_sales 
LEFT JOIN DimProduct AS Prod  
    ON Re_sales.ProductKey = Prod.ProductKey 
WHERE Prod.ModelName LIKE '%road%' AND 
Prod.Color = 'Yellow' 

-- Assignment Day 4 & 5

/* Ex 1: Write a query using DimProduct and DimProductSubcategory tables to display number of product in each SubcategoryName */ 

 SELECT ISNULL(Sub_cate.EnglishProductSubcategoryName,'Other') AS SubCategoryName, 
COUNT(ISNULL(Sub_cate.EnglishProductSubcategoryName,'Other')) AS Quantily 
FROM DimProduct AS Prod 
LEFT JOIN DimProductSubcategory AS Sub_cate 
    ON Prod.ProductSubcategoryKey = Sub_cate.ProductSubcategoryKey 
GROUP BY ISNULL(Sub_cate.EnglishProductSubcategoryName,'Other') 

/* Ex 2: From FactFinance, DimOrganization, DimScenario 
Write a query display OrganizationKey, OrganizationName, Parent OrganizationKey, Parent OrganizationName, Amount 
where ScenarioName is 'Actual' */  

SELECT F_Finan.OrganizationKey, 
Organ.OrganizationName, 
Organ.ParentOrganizationKey, 
Organ1.OrganizationName AS ParentOrganizationName, 
F_Finan.Amount 
FROM FactFinance AS F_Finan 
LEFT JOIN DimScenario AS Scen  
    ON F_Finan.ScenarioKey = Scen.ScenarioKey 
LEFT JOIN DimOrganization AS Organ  
    ON F_Finan.OrganizationKey = Organ.OrganizationKey 
LEFT JOIN DimOrganization AS Organ1 
    ON OrgaN.ParentOrganizationKey = Organ1.OrganizationKey 
WHERE Scen.ScenarioName = 'Actual' 

/* Ex 3: From FactInternetSale, DimProduct, 
Write a query that create new Color_group, if product color is 'Black' or 'Silver' or 'Silver/Black' leave 'Basic', else keep Color. 
Then Caculate total SalesAmount by new Color_group */ 

WITH Group_Color AS ( 
SELECT Insales.SalesAmount, 
CASE WHEN Prod.Color IN ('Black','Silver','Silver/Black') THEN 'Basic' 
ELSE Prod.Color 
END AS Color 
FROM FactInternetsales AS Insales 
LEFT JOIN DimProduct AS Prod 
    ON Insales.ProductKey = Prod.ProductKey 
) 

SELECT Color, SUM(SalesAmount) AS TotalSalesAmount 
FROM Group_Color 
GROUP BY Color  

/* Ex 4: From the FactInternetsales and Resellersales tables, retrieve saleordernumber, productkey,  
orderdate, shipdate of orders in October 2011, along with sales type ('Resell' or 'Internet') */

SELECT SalesOrderNumber,ProductKey,OrderDate,ShipDate,'Internet' 
FROM FactInternetSales 
WHERE MONTH(ShipDate) = 10 AND YEAR(ShipDate)=2011 
UNION ALL 
SELECT SalesOrderNumber,ProductKey,OrderDate,ShipDate,'Resell' 
FROM FactResellerSales 
WHERE MONTH(ShipDate)=10 AND YEAR(ShipDate)=2011 

/* Ex 5: From database  
Display ProductKey, EnglishProductName, Total OrderQuantity (caculate from OrderQuantity in Quarter 3 of 2013)  
of product sold in London for each Sales type ('Resell' and 'Internet') */

SELECT Insales.ProductKey, 
Prod.EnglishProductName, 
SUM(Insales.OrderQuantity) AS TotalOrderQuantity, 
'Internet' AS SalesType  
FROM FactInternetSales AS Insales 
LEFT JOIN DimProduct AS Prod  
    ON Insales.ProductKey = Prod.ProductKey 
LEFT JOIN DimCustomer AS Cus  
    ON Insales.CustomerKey = Cus.CustomerKey 
LEFT JOIN DimGeography AS Geo 
    ON Cus.GeographyKey = geo.GeographyKey 
WHERE Geo.City = 'London' AND 
MONTH(Insales.OrderDate) IN (7,8,9) AND 
YEAR(Insales.OrderDate) = 2013 
GROUP BY Insales.ProductKey, Prod.EnglishProductName 
UNION ALL 
SELECT Resales.ProductKey, 
Prod.EnglishProductName, 
SUM(Resales.OrderQuantity) AS TotalOrderQuantity, 
'Resell'   
FROM FactResellerSales AS Resales 
LEFT JOIN DimProduct AS Prod  
    ON Resales.ProductKey = Prod.ProductKey 
LEFT JOIN DimReseller AS Seller 
    ON Resales.ResellerKey = Seller.ResellerKey 
LEFT JOIN DimGeography AS Geo  
    ON Seller.GeographyKey = Geo.GeographyKey 
WHERE Geo.City = 'London' AND 
MONTH(Resales.OrderDate) IN (7,8,9) AND 
YEAR(Resales.OrderDate) = 2013 
GROUP BY Resales.ProductKey, Prod.EnglishProductName 
ORDER BY SalesType,ProductKey 

/* Ex 6 (hard): From database, retrieve total SalesAmount monthly of internet_sales and reseller_sales. 
(Expected output is in picture) */

WITH Internet AS ( 
SELECT  
CONCAT_WS(' ',YEAR(OrderDate),MONTH(OrderDate)) AS KeyDate, 
YEAR(OrderDate) AS YearOrder, 
MONTH(OrderDate) AS MonthOrder,  
SUM(SalesAmount) AS InternetSalesAmount 
FROM FactInternetSales 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
), Reseller AS ( 
SELECT 
CONCAT_WS(' ',YEAR(OrderDate),MONTH(OrderDate)) AS KeyDate, 
YEAR(OrderDate) AS YearOrder, 
MONTH(OrderDate) AS MonthOrder,  
SUM(SalesAmount) AS ResellerSalesAmount 
FROM FactResellerSales 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
) 

SELECT Internet.YearOrder, Internet.MonthOrder,InternetSalesAmount,ResellerSalesAmount 
FROM Internet 
LEFT JOIN Reseller ON Internet.KeyDate = Reseller.KeyDate 
ORDER BY Internet.YearOrder, Internet.MonthOrder    

/* Ex 7 (hard): From FactInternetSales table, write a query that retrieves the following data:  
Total orders each month of the year (using OrderDate) 
Total orders each month of the year (using ShipDate) 
Total orders each month of the year (using DueDate) */ 

WITH OrderDate AS ( 
SELECT  
CONCAT_WS('',YEAR(OrderDate),MONTH(OrderDate)) AS Keydate, 
YEAR(OrderDate) AS CalendarYear,  
MONTH(OrderDate) AS CalendarMonth,  
COUNT(OrderQuantity) AS TotalOrderByOrderDate 
FROM FactInternetSales 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
),  
Shipdate AS ( 
SELECT 
CONCAT_WS('',YEAR(ShipDate),MONTH(ShipDate)) AS Keydate, 
YEAR(ShipDate) AS CalendarYear,  
MONTH(ShipDate) AS CalendarMonth,  
COUNT(OrderQuantity) AS TotalOrderByShipDate 
FROM FactInternetSales 
GROUP BY YEAR(ShipDate), MONTH(ShipDate) 
),
DueDate AS ( 
SELECT  
CONCAT_WS('',YEAR(DueDate),MONTH(DueDate)) AS Keydate, 
YEAR(DueDate) AS CalendarYear,  
MONTH(DueDate) AS CalendarMonth,  
COUNT(OrderQuantity) AS TotalOrderByDueDate 
FROM FactInternetSales 
GROUP BY YEAR(DueDate), MONTH(DueDate) 
) 

SELECT ISNULL(OrderDate.CalendarYear,Shipdate.CalendarYear) AS [Year], 
ISNULL(OrderDate.CalendarMonth,Shipdate.CalendarMonth) AS [Month],  
TotalOrderByOrderDate, 
TotalOrderByShipDate, 
TotalOrderByDueDate 
FROM OrderDate 
FULL OUTER JOIN Shipdate ON OrderDate.Keydate = Shipdate.Keydate 
LEFT JOIN Duedate ON ShipDate.Keydate = DueDate.Keydate 
ORDER BY[Year],[Month] 

/* Ex 8: Find out 5 SaleOrderNumber with highest SalesAmount in InternetSales table */ 

WITH RANKED AS ( 
SELECT DENSE_RANK() OVER (Order By SalesAmount) AS [Rank], 
SalesOrderNumber 
FROM FactInternetSales 
) 

SELECT DISTINCT * 
FROM RANKED 
WHERE [Rank] <= 5 
ORDER BY [Rank] 

/* Ex 9: Find out 5 SaleOrderNumber with highest SalesAmount in each month from FactInternetSales tables */ 

WITH Sales AS ( 
    SELECT  
    DENSE_RANK() OVER (PARTITION BY MONTH(OrderDate) ORDER BY SalesAmount DESC) AS [Rank], 
    MONTH(OrderDate) AS [Month],  
    SalesOrderNumber, 
    SalesAmount 
    FROM FactInternetSales 
) 

SELECT * 
FROM Sales 
WHERE [Rank] <= 5  