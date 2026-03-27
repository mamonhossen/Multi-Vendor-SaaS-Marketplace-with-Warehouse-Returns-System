A SQL Server Management Studio 21 project for creating a Multi-Vendor Marketplace database with all necessary tables, relationships, and sample queries.

This project includes:

Vendor subscription plans
Products and variations
Warehouses and stock management
Customers, orders, payments, and return requests
Relational schema and example queries for reporting
Database Overview

Database Name: MultiVendorMarketplace

Entities / Tables:

SubscriptionPlan – Stores subscription plans for vendors.
Vendor – Vendors using the marketplace, linked to a plan.
Warehouse – Storage locations for products.
Product – Products offered by vendors.
ProductVariation – Variations like size, color, and SKU.
Category – Product categories.
ProductCategory – Junction table for Product ↔ Category (M:N).
WarehouseStock – Tracks stock per warehouse per variation.
Customer – Marketplace customers.
Orders – Customer orders.
OrderItem – Items in an order (weak entity).
Payment – Payment details (1:1 with orders).
ReturnRequest – Return requests from customers.

Relationships:

Vendor → SubscriptionPlan (N:1)
Vendor → Product (1:N)
Vendor → Warehouse (1:N)
Product → ProductVariation (1:N)
Product ↔ Category (M:N) via ProductCategory
Warehouse ↔ ProductVariation (M:N) via WarehouseStock
Customer → Orders (1:N)
Orders → OrderItem (1:N)
Orders → Payment (1:1)
Orders → ReturnRequest (1:N)

Weak & Associative Entities:

Weak Entity: OrderItem depends on Orders.
Associative Entities: ProductCategory and WarehouseStock resolve M:N relationships.
Database Setup
-- Create Database
CREATE DATABASE MultiVendorMarketplace;
USE MultiVendorMarketplace;

Features & Highlights: 
Fully normalized relational schema.
Weak and associative entities for real-world marketplace logic.
Sample data for testing vendors, products, stock, and orders.
Queries for sales reports, vendor ranking, stock management, and customer insights.
