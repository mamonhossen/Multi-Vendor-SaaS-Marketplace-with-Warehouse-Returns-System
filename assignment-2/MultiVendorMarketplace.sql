--  making database named as MultiVendorMarketplace
CREATE DATABASE MultiVendorMarketplace;
--active the database MultiVendorMarketplace
USE MultiVendorMarketplace;
                               -- answer 1 Entities/table 1-13(at least 10)
                               --  table shown in bellow (various places)
/*
1. SubscriptionPlan (PlanID, PlanName, MonthlyFee, ProductLimit, CommissionPercent, Features)
2. Vendor (VendorID, BusinessName, OwnerName, Email, Phone, Address, VATNumber, JoinDate, Status, PlanID)
3. Warehouse (WarehouseID, VendorID, WarehouseName, Location, Capacity)
4. Product (ProductID, VendorID, ProductName, Brand, BasePrice, Description, Status)
5. ProductVariation (VariationID, ProductID, Size, Color, AdditionalPrice, SKU)
6. Category (CategoryID, CategoryName, Description)
7. ProductCategory (ProductID, CategoryID) -- Junction (M:N)
8. WarehouseStock (WarehouseID, VariationID, StockQty) -- Associative
9. Customer (CustomerID, FullName, Email, Phone, Address, RegistrationDate, Status)
10. Orders (OrderID, CustomerID, OrderDate, Status, TotalAmount)
11. OrderItem (OrderItemID, OrderID, VariationID, VendorID, Quantity, UnitPrice, Subtotal)
12. Payment (PaymentID, OrderID, Method, Amount, PaymentDate, Status)
13. ReturnRequest (ReturnID, OrderID, VariationID, Reason, Status, RequestDate)
*/
                                       -- answer 2 shown in pdf by dbdiagram.IO           -------
/*
Vendor → SubscriptionPlan (N:1)
Vendor → Product (1:N)
Vendor → Warehouse (1:N)
Product → ProductVariation (1:N)
Product ↔ Category (M:N)
Warehouse ↔ ProductVariation (M:N)
Customer → Orders (1:N)
Orders → OrderItem (1:N)
Orders → Payment (1:1)
Orders → ReturnRequest (1:N)
*/
                                                         -- answer 3 Weak & Associative Entities
/*

Weak Entity:
-- OrderItem (depends on Orders)

Associative Entities:
-- ProductCategory
-- WarehouseStock
*/
                                                            -- answer 4 Relational Schema
/*
Vendor(VendorID PK, PlanID FK)
Product(ProductID PK, VendorID FK)
ProductVariation(VariationID PK, ProductID FK)
Warehouse(WarehouseID PK, VendorID FK)
WarehouseStock(WarehouseID PK/FK, VariationID PK/FK)
Orders(OrderID PK, CustomerID FK)
Payment(PaymentID PK, OrderID FK UNIQUE)
*/
                                                         --Subscription Plan Table
-- Stores subscription plans
CREATE TABLE SubscriptionPlan (
    PlanID INT IDENTITY PRIMARY KEY,
    PlanName VARCHAR(20) CHECK (PlanName IN ('Basic','Standard','Enterprise')),
    MonthlyFee DECIMAL(10,2) NOT NULL,
    ProductLimit INT NOT NULL,
    CommissionPercent DECIMAL(5,2) NOT NULL,
    Features VARCHAR(500)
);
                                                                -- answer 5 Vendor Table 
-- Vendor table with unique email and FK to SubscriptionPlan
CREATE TABLE Vendor (
    VendorID INT IDENTITY PRIMARY KEY,
    BusinessName VARCHAR(100) NOT NULL,
    OwnerName VARCHAR(100),
    Email VARCHAR(100) UNIQUE NOT NULL, -- Unique email
    Phone VARCHAR(20),
    Address VARCHAR(200),
    VATNumber VARCHAR(50),
    JoinDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) CHECK (Status IN ('Active','Suspended')), -- Status constraint
    PlanID INT,
    FOREIGN KEY (PlanID) REFERENCES SubscriptionPlan(PlanID)
);
                                                        -- Warehouse Table 
-- Warehouse belongs to Vendor
CREATE TABLE Warehouse (
    WarehouseID INT IDENTITY PRIMARY KEY,
    VendorID INT,
    WarehouseName VARCHAR(100),
    Location VARCHAR(100),
    Capacity INT,
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);
                                                                --Product Table
-- Product belongs to Vendor
CREATE TABLE Product (
    ProductID INT IDENTITY PRIMARY KEY,
    VendorID INT,
    ProductName VARCHAR(100),
    Brand VARCHAR(100),
    BasePrice DECIMAL(10,2),
    Description VARCHAR(500),
    Status VARCHAR(20) CHECK (Status IN ('Active','Inactive')),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);
                                                               -- answer 6 ProductVariation Table
-- Product variation with unique SKU
CREATE TABLE ProductVariation (
    VariationID INT IDENTITY PRIMARY KEY,
    ProductID INT,
    Size VARCHAR(50),
    Color VARCHAR(50),
    AdditionalPrice DECIMAL(10,2),
    SKU VARCHAR(50) UNIQUE, -- Unique SKU
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
                                                                -- categori table/entity
CREATE TABLE Category (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName VARCHAR(100),
    Description VARCHAR(300)
);
                                                                -- answer 7 ProductCategory ( M:N)
-- Junction table for M:N between Product and Category
CREATE TABLE ProductCategory (
    ProductID INT,
    CategoryID INT,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);
                                                                -- answer 8 WarehouseStock
-- Stock per warehouse per variation
CREATE TABLE WarehouseStock (
    WarehouseID INT,
    VariationID INT,
    StockQty INT,
    PRIMARY KEY (WarehouseID, VariationID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (VariationID) REFERENCES ProductVariation(VariationID)
);
                                                            -- customer table/entity
CREATE TABLE Customer (
    CustomerID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(200),
    RegistrationDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20)
);

*************

                                                            --Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) CHECK (Status IN ('Pending','Confirmed','Shipped','Delivered','Cancelled')),
    TotalAmount DECIMAL(12,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
                                                        --OrderItem Table (Weak Entity)
CREATE TABLE OrderItem (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    VariationID INT,
    VendorID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Subtotal DECIMAL(12,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (VariationID) REFERENCES ProductVariation(VariationID),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);
                                                    --Payment Table (1:1 with Order)
CREATE TABLE Payment (
    PaymentID INT IDENTITY PRIMARY KEY,
    OrderID INT UNIQUE, -- Ensures one payment per order
    Method VARCHAR(20) CHECK (Method IN ('Card','Bkash','Nagad','PayPal','COD')),
    Amount DECIMAL(12,2),
    PaymentDate DATE,
    Status VARCHAR(20) CHECK (Status IN ('Pending','Paid','Failed','Refunded')),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
                                                                        --ReturnRequest Table
CREATE TABLE ReturnRequest (
    ReturnID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    VariationID INT,
    Reason VARCHAR(300),
    Status VARCHAR(20) CHECK (Status IN ('Requested','Approved','Rejected','Refunded')),
    RequestDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (VariationID) REFERENCES ProductVariation(VariationID)
);

*******************************************


                                                                -- answer 9 Insert Standard Plan
INSERT INTO SubscriptionPlan
VALUES ('Standard',3000,200,8,'Standard Plan Features');

                                                                       -- answer 10 Insert TechZone Ltd.

INSERT INTO Vendor (BusinessName,OwnerName,Email,Phone,Address,VATNumber,Status,PlanID)
VALUES ('TechZone Ltd.','Rahim Ahmed','techzone@email.com',
'01700000000','Dhaka','VAT123','Active',1);

                                                                            -- answer 11 Insert Smartphone

INSERT INTO Product (VendorID,ProductName,Brand,BasePrice,Description,Status)
VALUES (1,'Smartphone','Samsung',50000,'Android Smartphone','Active');

                                                                                -- answer 12 Insert 128GB Black variation
INSERT INTO ProductVariation (ProductID,Size,Color,AdditionalPrice,SKU)
VALUES (1,'128GB','Black',0,'SP128B');
                                                                                    /*Insert Warehouse & Stock
                                                                                     Create Dhaka Warehouse*/
INSERT INTO Warehouse (VendorID,WarehouseName,Location,Capacity)
VALUES (1,'Dhaka Warehouse','Dhaka',500);

                                                                                        -- Insert stock
INSERT INTO WarehouseStock VALUES (1,1,10);


                                                                            -- answer 13 Update stock to 25
UPDATE WarehouseStock
SET StockQty = 25
WHERE WarehouseID = 1 AND VariationID = 1;

                                                                            -- answer 14 Delete inactive customers
DELETE FROM Customer
WHERE Status='Inactive';


                                                                                --answer 15 Vendors with Plan
SELECT V.BusinessName, S.PlanName, S.CommissionPercent
FROM Vendor V
JOIN SubscriptionPlan S ON V.PlanID=S.PlanID;
                                                                                --answer 16 Products with Total Stock
SELECT P.ProductName, SUM(W.StockQty) AS TotalStock
FROM Product P
JOIN ProductVariation PV ON P.ProductID=PV.ProductID
JOIN WarehouseStock W ON PV.VariationID=W.VariationID
GROUP BY P.ProductName;
                                                                                    --answer 17 Orders Last 30 Days
SELECT *
FROM Orders
WHERE OrderDate >= DATEADD(DAY,-30,GETDATE());
                                                                                --answer 18 Top 5 Best-Selling Variations
SELECT TOP 5 VariationID, SUM(Quantity) AS TotalSold
FROM OrderItem
GROUP BY VariationID
ORDER BY TotalSold DESC;
                                                                                --answer 19 Customers Who Requested Returns
SELECT DISTINCT C.FullName
FROM Customer C
JOIN Orders O ON C.CustomerID=O.CustomerID
JOIN ReturnRequest R ON O.OrderID=R.OrderID;
                                                                                    --answer 20 Delivered but Payment Not Paid
SELECT O.OrderID
FROM Orders O
JOIN Payment P ON O.OrderID=P.OrderID
WHERE O.Status='Delivered'
AND P.Status<>'Paid';

                                                                                    --answer 21 Total Revenue per Vendor
SELECT V.BusinessName, SUM(OI.Subtotal) AS Revenue
FROM Vendor V
JOIN OrderItem OI ON V.VendorID=OI.VendorID
GROUP BY V.BusinessName;
                                                                                    --answer 22 Customers Buying from >2 Vendors
SELECT O.CustomerID
FROM Orders O
JOIN OrderItem OI ON O.OrderID=OI.OrderID
GROUP BY O.CustomerID
HAVING COUNT(DISTINCT OI.VendorID) > 2;
                                                                                           --answer 23 Monthly Sales Summary
SELECT MONTH(OrderDate) AS Month,
       SUM(TotalAmount) AS TotalSales
FROM Orders
WHERE YEAR(OrderDate)=YEAR(GETDATE())
GROUP BY MONTH(OrderDate);
                                                                                            --answer 24 Vendors Exceeding Product Limit
SELECT V.BusinessName
FROM Vendor V
JOIN SubscriptionPlan S ON V.PlanID=S.PlanID
JOIN Product P ON V.VendorID=P.VendorID
GROUP BY V.BusinessName,S.ProductLimit
HAVING COUNT(P.ProductID) > S.ProductLimit;
                                                                                            --answer 25 CTE Ranking Vendors by Sales
WITH VendorSales AS (
    SELECT V.VendorID,
           V.BusinessName,
           SUM(OI.Subtotal) AS TotalSales
    FROM Vendor V
    JOIN OrderItem OI ON V.VendorID=OI.VendorID
    GROUP BY V.VendorID,V.BusinessName
)
SELECT *,
       RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM VendorSales;









