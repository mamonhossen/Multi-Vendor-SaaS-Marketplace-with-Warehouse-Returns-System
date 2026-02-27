CREATE TABLE [SubscriptionPlan] (
  [PlanID] int PRIMARY KEY,
  [PlanName] varchar(20),
  [MonthlyFee] decimal(10,2),
  [ProductLimit] int,
  [CommissionPercent] decimal(5,2),
  [Features] varchar(500)
)
GO

CREATE TABLE [Vendor] (
  [VendorID] int PRIMARY KEY,
  [BusinessName] varchar(100),
  [OwnerName] varchar(100),
  [Email] varchar(100) UNIQUE,
  [Phone] varchar(20),
  [Address] varchar(200),
  [VATNumber] varchar(50),
  [JoinDate] date,
  [Status] varchar(20),
  [PlanID] int
)
GO

CREATE TABLE [Warehouse] (
  [WarehouseID] int PRIMARY KEY,
  [VendorID] int,
  [WarehouseName] varchar(100),
  [Location] varchar(100),
  [Capacity] int
)
GO

CREATE TABLE [Product] (
  [ProductID] int PRIMARY KEY,
  [VendorID] int,
  [ProductName] varchar(100),
  [Brand] varchar(100),
  [BasePrice] decimal(10,2),
  [Description] varchar(500),
  [Status] varchar(20)
)
GO

CREATE TABLE [ProductVariation] (
  [VariationID] int PRIMARY KEY,
  [ProductID] int,
  [Size] varchar(50),
  [Color] varchar(50),
  [AdditionalPrice] decimal(10,2),
  [SKU] varchar(50) UNIQUE
)
GO

CREATE TABLE [Category] (
  [CategoryID] int PRIMARY KEY,
  [CategoryName] varchar(100),
  [Description] varchar(300)
)
GO

CREATE TABLE [ProductCategory] (
  [ProductID] int,
  [CategoryID] int,
  PRIMARY KEY ([ProductID], [CategoryID])
)
GO

CREATE TABLE [WarehouseStock] (
  [WarehouseID] int,
  [VariationID] int,
  [StockQty] int,
  PRIMARY KEY ([WarehouseID], [VariationID])
)
GO

CREATE TABLE [Customer] (
  [CustomerID] int PRIMARY KEY,
  [FullName] varchar(100),
  [Email] varchar(100) UNIQUE,
  [Phone] varchar(20),
  [Address] varchar(200),
  [RegistrationDate] date,
  [Status] varchar(20)
)
GO

CREATE TABLE [Orders] (
  [OrderID] int PRIMARY KEY,
  [CustomerID] int,
  [OrderDate] date,
  [Status] varchar(20),
  [TotalAmount] decimal(12,2)
)
GO

CREATE TABLE [OrderItem] (
  [OrderItemID] int PRIMARY KEY,
  [OrderID] int,
  [VariationID] int,
  [VendorID] int,
  [Quantity] int,
  [UnitPrice] decimal(10,2),
  [Subtotal] decimal(12,2)
)
GO

CREATE TABLE [Payment] (
  [PaymentID] int PRIMARY KEY,
  [OrderID] int UNIQUE,
  [Method] varchar(20),
  [Amount] decimal(12,2),
  [PaymentDate] date,
  [Status] varchar(20)
)
GO

CREATE TABLE [ReturnRequest] (
  [ReturnID] int PRIMARY KEY,
  [OrderID] int,
  [VariationID] int,
  [Reason] varchar(300),
  [Status] varchar(20),
  [RequestDate] date
)
GO

ALTER TABLE [Vendor] ADD FOREIGN KEY ([PlanID]) REFERENCES [SubscriptionPlan] ([PlanID])
GO

ALTER TABLE [Warehouse] ADD FOREIGN KEY ([VendorID]) REFERENCES [Vendor] ([VendorID])
GO

ALTER TABLE [Product] ADD FOREIGN KEY ([VendorID]) REFERENCES [Vendor] ([VendorID])
GO

ALTER TABLE [ProductVariation] ADD FOREIGN KEY ([ProductID]) REFERENCES [Product] ([ProductID])
GO

ALTER TABLE [ProductCategory] ADD FOREIGN KEY ([ProductID]) REFERENCES [Product] ([ProductID])
GO

ALTER TABLE [ProductCategory] ADD FOREIGN KEY ([CategoryID]) REFERENCES [Category] ([CategoryID])
GO

ALTER TABLE [WarehouseStock] ADD FOREIGN KEY ([WarehouseID]) REFERENCES [Warehouse] ([WarehouseID])
GO

ALTER TABLE [WarehouseStock] ADD FOREIGN KEY ([VariationID]) REFERENCES [ProductVariation] ([VariationID])
GO

ALTER TABLE [Orders] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([CustomerID])
GO

ALTER TABLE [OrderItem] ADD FOREIGN KEY ([OrderID]) REFERENCES [Orders] ([OrderID])
GO

ALTER TABLE [OrderItem] ADD FOREIGN KEY ([VariationID]) REFERENCES [ProductVariation] ([VariationID])
GO

ALTER TABLE [OrderItem] ADD FOREIGN KEY ([VendorID]) REFERENCES [Vendor] ([VendorID])
GO

ALTER TABLE [Payment] ADD FOREIGN KEY ([OrderID]) REFERENCES [Orders] ([OrderID])
GO

ALTER TABLE [ReturnRequest] ADD FOREIGN KEY ([OrderID]) REFERENCES [Orders] ([OrderID])
GO

ALTER TABLE [ReturnRequest] ADD FOREIGN KEY ([VariationID]) REFERENCES [ProductVariation] ([VariationID])
GO
