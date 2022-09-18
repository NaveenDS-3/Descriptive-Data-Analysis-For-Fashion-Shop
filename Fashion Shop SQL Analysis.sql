-- Create Database For Store The Dataset --
CREATE DATABASE IF NOT EXISTS Fashion_Shop_Data;

-- Creat Table For Store The Data --
-- Customer Table For Store Customers Details --
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID CHAR(10) PRIMARY KEY NOT NULL,
    CustomerName VARCHAR(55),
    Gender VARCHAR(55),
    Age SMALLINT,
    ContactNumber VARCHAR(55),
    EmailAddress VARCHAR(55)
);
-- Create Orders Table For Store Customer Orders Details --
CREATE TABLE IF NOT EXISTS Orders (
    OrderID CHAR(10) PRIMARY KEY NOT NULL,
    BillID CHAR(10),
    Year INT,
    City VARCHAR(55),
    State VARCHAR(55),
    CONSTRAINT fk_BillID FOREIGN KEY (BillID)
        REFERENCES Purchase_Details (BillID)
        ON DELETE CASCADE
);
-- Create Table For Products To Stroe the Products Details --
CREATE TABLE IF NOT EXISTS Products (
    ProductID CHAR(10) PRIMARY KEY NOT NULL,
    ProductCategory VARCHAR(55),
    ProductDepartment VARCHAR(55),
    ProductCost INT,
    SellingCost INT,
    TaxAmount INT
);
-- Create Table For Purchase To Store The Purchase Details of Our Customers --
CREATE TABLE IF NOT EXISTS Purchase_Details (
    CustomerID CHAR(10),
    BillID CHAR(10) PRIMARY KEY NOT NULL,
    ProductID CHAR(10),
    Quantity INT DEFAULT 0,
    PaymentMode VARCHAR(55),
    CONSTRAINT Customers_ibfk1 FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
        ON DELETE CASCADE,
    CONSTRAINT Products_ibfk1 FOREIGN KEY (ProductID)
        REFERENCES Products (ProductID)
        ON DELETE CASCADE
);
-- Create Table For Customer Products Retrun Details -- 
CREATE TABLE IF NOT EXISTS Return_Details (
    OrderID CHAR(10),
    ProductID CHAR(10),
    RefundDetails VARCHAR(55),
    Return_Reason VARCHAR(55),
    CONSTRAINT Orders_ibfk1 FOREIGN KEY (OrderID)
        REFERENCES Orders (OrderID)
        ON DELETE CASCADE,
    CONSTRAINT Products_ibfk2 FOREIGN KEY (ProductID)
        REFERENCES Products (ProductID)
        ON DELETE CASCADE
);
-- Calculate Total Revenue --
SELECT 
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS Total_Revenue
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID;
-- Total Revenue by Year / 2021 2020 2019 Revenue --
SELECT 
    BillID,
    SUM(Quantity * SellingCost + TaxAmount) AS 2021_Revenue
FROM
    Purchase_Details
        JOIN
    Products ON Purchase_Details.ProductID = Products.ProductID
WHERE
    BillID IN (SELECT 
            BillID
        FROM
            Orders
        WHERE
            Year = 2021);

SELECT 
    BillID,
    SUM(Quantity * SellingCost + TaxAmount) AS 2021_Revenue
FROM
    Purchase_Details
        JOIN
    Products ON Purchase_Details.ProductID = Products.ProductID
WHERE
    BillID IN (SELECT 
            BillID
        FROM
            Orders
        WHERE
            Year = 2020);

SELECT 
    BillID,
    SUM(Quantity * SellingCost + TaxAmount) AS 2021_Revenue
FROM
    Purchase_Details
        JOIN
    Products ON Purchase_Details.ProductID = Products.ProductID
WHERE
    BillID IN (SELECT 
            BillID
        FROM
            Orders
        WHERE
            Year = 2019);
 -- Calculate Customers Buying Amount--
SELECT 
    pd.BillID,
    (pd.Quantity * p.SellingCost + p.Taxamount) AS Revenue
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
ORDER BY BillID;
-- Find Max, MIN, AVG amount Individual buy --
SELECT 
    pd.BillID,
    MAX(pd.Quantity * p.SellingCost + p.Taxamount) AS Revenue
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
ORDER BY BillID;
-- Refund Details by Individual Customers --
SELECT 
    rd.ProductID, (p.SellingCost + p.TaxAmount) AS Refund_Amount
FROM
    Products p
        INNER JOIN
    return_details rd ON p.ProductID = rd.ProductID
WHERE
    rd.RefundDetails = 'Money Refunded'
ORDER BY ProductID;
-- Total Refund Amount --
SELECT 
    SUM(p.SellingCost + p.TaxAmount) AS Refund_Amount
FROM
    Products p
        INNER JOIN
    return_details rd ON p.ProductID = rd.ProductID
WHERE
    rd.RefundDetails = 'Money Refunded';
 -- Total Replaced Amount --
SELECT 
    SUM(p.SellingCost + p.TaxAmount) AS Replaced_Amount
FROM
    Products p
        LEFT JOIN
    return_details rd ON p.ProductID = rd.ProductID
WHERE
    rd.RefundDetails = 'Prodcut Replaced';
-- Total Profits --
SELECT 
    SUM(pd.quantity * (p.sellingcost - productcost) + p.taxamount)
FROM
    purchase_details pd
        INNER JOIN
    products p ON pd.productid = p.productid;
-- Total Product Selling Cost --
SELECT 
    SUM(pd.Quantity * p.ProductCost) AS Total_Cost
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID;
-- Total Product Selling Cost By Year 2021 2021 2019 --
SELECT 
    SUM(pd.Quantity * p.ProductCost) AS 2021_TotalCost
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    BillID IN (SELECT 
            BillID
        FROM
            Orders
        WHERE
            Year = 2019);

SELECT 
    SUM(pd.Quantity * p.ProductCost) AS 2021_TotalCost
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    BillID IN (SELECT 
            BillID
        FROM
            Orders
        WHERE
            Year = 2020);

SELECT 
    SUM(pd.Quantity * p.ProductCost) AS 2021_TotalCost
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    BillID IN (SELECT 
            BillID
        FROM
            Orders
        WHERE
            Year = 2021);
-- Total Revenue By Product Catagory --
SELECT 
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS Men_Catagory
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    p.ProductDepartment = 'Men';

SELECT 
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS Men_Catagory
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    p.ProductDepartment = 'Women';

SELECT 
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS Men_Catagory
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    p.ProductDepartment = 'Boys';

SELECT 
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS Men_Catagory
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    p.ProductDepartment = 'Girls';

SELECT 
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS Men_Catagory
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    p.ProductDepartment = 'Babys';

-- Sales Analysis --

SELECT 
    SUM(Quantity)
FROM
    Purchase_Details;

-- Total Return Products --

SELECT 
    COUNT(OrderID)
FROM
    Return_Details;

-- Total Replaced Products --

SELECT 
    COUNT(RefundDetails) AS Replaced_Orders
FROM
    Return_Details
WHERE
    RefundDetails = 'Product Replaced';

-- Total Refund Products--

SELECT 
    COUNT(RefundDetails) Return_Orders
FROM
    Return_Details
WHERE
    RefundDetails = 'Money Refunded';

-- Most Return Product --

SELECT 
    rd.ProductID,
    p.ProductCategory,
    COUNT(rd.ProductID) AS Count_of_Product
FROM
    return_details rd
        INNER JOIN
    Products p ON rd.ProductID = p.ProductID
GROUP BY rd.ProductID
ORDER BY Count_of_Product DESC;

-- Sales By Product Department --

SELECT 
    COUNT(pd.BillID) AS Product_Category_Men
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    ProductDepartment = 'Men';

-- Total Orders By Product Category --

SELECT 
    p.ProductID,
    p.ProductCategory,
    SUM(pd.Quantity) AS Quantity_by_Category
FROM
    Purchase_Details pd
        LEFT JOIN
    Products p ON pd.ProductID = p.ProductID
GROUP BY pd.ProductID
ORDER BY pd.ProductID;

-- Most Selling Product --

SELECT 
    MAX(Quantity_by_Category)
FROM
    (SELECT 
        p.ProductID,
            p.ProductCategory,
            SUM(pd.Quantity) AS Quantity_by_Category
    FROM
        Purchase_Details pd
    INNER JOIN Products p ON pd.ProductID = p.ProductID
    GROUP BY pd.ProductID
    ORDER BY p.ProductID) Purchase_Details;

-- Less Selling Products --

SELECT 
    p.ProductID,
    p.ProductCategory,
    SUM(pd.Quantity) AS Total_Sell_Quantity
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
GROUP BY pd.ProductID
ORDER BY Total_Sell_Quantity ASC
LIMIT 1;

-- Sales or Orders By Year --

SELECT 
    SUM(Quantity)
FROM
    Purchase_Details pd
        INNER JOIN
    Orders od ON pd.BillID = od.BillID
WHERE
    od.Year = 2019;

-- Customer Analysis --

SELECT 
    COUNT(CustomerID)
FROM
    Customers;

-- Repeated Customers Count --

SELECT 
    CustomerID, COUNT(CustomerID) AS Repeat_Customer
FROM
    Purchase_Details
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 1;

-- Customers Count By Year --

SELECT 
    COUNT(BillID) Customers_by_Year
FROM
    Orders
WHERE
    Year = 2019;

-- Most Buying Customers Age Group --

SELECT 
    Age, COUNT(Age) AS Customer_Age
FROM
    Customers
GROUP BY Age
ORDER BY Customer_Age DESC;

-- Low Buying Customer Age Group --

SELECT 
    c.Age, COUNT(c.Age) AS Total_Age_Group
FROM
    Customers c
        INNER JOIN
    Purchase_Details pd ON c.CustomerID = pd.CustomerID
GROUP BY c.Age
ORDER BY Total_Age_Group DESC;

-- Total Male and Female Customers Count-- 

SELECT 
    COUNT(c.Gender) Total_Female_Customers
FROM
    Customers c
        INNER JOIN
    Purchase_Details pd ON c.CustomerID = pd.CustomerID
WHERE
    c.Gender = 'Female';

SELECT 
    COUNT(c.Gender) Total_Male_Customers
FROM
    Customers c
        INNER JOIN
    Purchase_Details pd ON c.CustomerID = pd.CustomerID
WHERE
    c.Gender = 'Male';

-- Most Buying Customer Location --

SELECT 
    od.City, COUNT(od.City) AS Customer_Location
FROM
    Orders od
GROUP BY od.City
ORDER BY Customer_Location DESC;

-- Most Customers Payment Method --

SELECT 
    PaymentMode, COUNT(PaymentMode)
FROM
    Purchase_Details
GROUP BY PaymentMode
ORDER BY PaymentMode DESC;

-- Total Purchase Amount Using Credit Card --

SELECT 
    pd.ProductID,
    SUM(pd.Quantity * p.SellingCost + p.TaxAmount) AS CreditCard_Payment
FROM
    Purchase_Details pd
        INNER JOIN
    Products p ON pd.ProductID = p.ProductID
WHERE
    pd.PaymentMode = 'Credit Card';
  
  -- Product Purchase Details By Customers Age Group --
  
    SELECT
    products.ProductCategory,
    COUNT(products.ProductCategory) AS total_purchase,
    products.ProductDepartment,
    CASE
        WHEN Age BETWEEN 13 AND 19 THEN 'Age Group (13 To 19)'
        WHEN Age BETWEEN 20 AND 28 THEN 'Age Group (20 To 28)'
        WHEN Age BETWEEN 29 AND 40 THEN 'Age Group (29 To 40)'
        WHEN Age BETWEEN 41 AND 55 THEN 'Age Group (41 To 55)'
        ELSE 'Age Group (Greater Then 55)'
    END AS Customer_Type
FROM
    Customers
        INNER JOIN
    purchase_details ON Customers.customerid = purchase_details.customerid
        INNER JOIN
    products ON purchase_details.productid = products.productid
GROUP BY products.ProductCategory
HAVING Customer_Type = 'Age Group (20 To 28)'
ORDER BY COUNT(products.ProductCategory) DESC;

-- Compare the customers present orders to previous orders
SELECT pd.*, LAG(Quantity,1,0) OVER(PARTITION BY CustomerID ORDER BY CustomerID) AS Pre_Records,
LEAD(Quantity,1,0) OVER (PARTITION BY CustomerID ORDER BY CustomerID) AS Next_Records
FROM Purchase_Details pd;

-- Average Orders Per Customers
SELECT CustomerID,ROUND(AVG(Quantity)) AS Avg_Orders FROM Purchase_Details
GROUP BY CustomerID;
