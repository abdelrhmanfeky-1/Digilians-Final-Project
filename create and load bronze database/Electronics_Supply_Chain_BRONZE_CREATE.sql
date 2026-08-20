/*
===============================================================================
 Electronics Manufacturing & Supply Chain Database - FINAL 200K DATA VERSION
 SQL Server / SSMS
===============================================================================
--------------------------
01 Departments
02 Materials
03 Suppliers
04 SupplierMaterials
05 PurchaseRequisitions
06 PurchaseRequisitionDetails
07 PurchaseOrders
08 PurchaseOrderDetails
09 SupplierShipments
10 SupplierShipmentDetails
11 GoodsReceipts
12 GoodsReceiptDetails
13 QualityInspections
14 SupplierInvoices
15 SupplierInvoiceDetails
16 SupplierPayments
17 Warehouses
18 RawMaterialInventory
19 Products
20 ProductBOM
21 Production
22 ProductionDetails
23 RawMaterialInventoryTransactions
24 FinishedGoodsInventory
25 Customers
26 SalesOrders
27 SalesOrderDetails
28 CustomerShipments
29 CustomerShipmentDetails
30 FinishedGoodsInventoryTransactions
31 Returns
===============================================================================
*/

USE master;
GO

IF DB_ID(N'ElectronicsSupplyChainDB') IS NULL
BEGIN
    CREATE DATABASE ElectronicsSupplyChainDB;
END;
GO

USE ElectronicsSupplyChainDB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

/*=============================================================================
 1. SINGLE BRONZE SCHEMA
=============================================================================*/
IF SCHEMA_ID(N'bronze') IS NULL
    EXEC(N'CREATE SCHEMA bronze AUTHORIZATION dbo;');
GO

IF SCHEMA_ID(N'silver') IS NULL
    EXEC(N'CREATE SCHEMA silver AUTHORIZATION dbo;');

GO

IF SCHEMA_ID(N'gold') IS NULL
    EXEC(N'CREATE SCHEMA gold AUTHORIZATION dbo;');
GO
/*=============================================================================
 2. DROP TABLES IN REVERSE DEPENDENCY ORDER
=============================================================================*/
DROP TABLE IF EXISTS bronze.Returns;
DROP TABLE IF EXISTS bronze.FinishedGoodsInventoryTransactions;
DROP TABLE IF EXISTS bronze.CustomerShipmentDetails;
DROP TABLE IF EXISTS bronze.CustomerShipments;
DROP TABLE IF EXISTS bronze.SalesOrderDetails;
DROP TABLE IF EXISTS bronze.SalesOrders;
DROP TABLE IF EXISTS bronze.Customers;
DROP TABLE IF EXISTS bronze.FinishedGoodsInventory;

DROP TABLE IF EXISTS bronze.RawMaterialInventoryTransactions;
DROP TABLE IF EXISTS bronze.ProductionDetails;
DROP TABLE IF EXISTS bronze.Production;
DROP TABLE IF EXISTS bronze.ProductBOM;
DROP TABLE IF EXISTS bronze.Products;
DROP TABLE IF EXISTS bronze.RawMaterialInventory;
DROP TABLE IF EXISTS bronze.Warehouses;

DROP TABLE IF EXISTS bronze.SupplierPayments;
DROP TABLE IF EXISTS bronze.SupplierInvoiceDetails;
DROP TABLE IF EXISTS bronze.SupplierInvoices;
DROP TABLE IF EXISTS bronze.QualityInspections;
DROP TABLE IF EXISTS bronze.GoodsReceiptDetails;
DROP TABLE IF EXISTS bronze.GoodsReceipts;
DROP TABLE IF EXISTS bronze.SupplierShipmentDetails;
DROP TABLE IF EXISTS bronze.SupplierShipments;

DROP TABLE IF EXISTS bronze.PurchaseOrderDetails;
DROP TABLE IF EXISTS bronze.PurchaseOrders;
DROP TABLE IF EXISTS bronze.PurchaseRequisitionDetails;
DROP TABLE IF EXISTS bronze.PurchaseRequisitions;
DROP TABLE IF EXISTS bronze.SupplierMaterials;
DROP TABLE IF EXISTS bronze.Suppliers;
DROP TABLE IF EXISTS bronze.Materials;
DROP TABLE IF EXISTS bronze.Departments;
GO

/*=============================================================================
 3. PROCUREMENT & SOURCING
=============================================================================*/
CREATE TABLE bronze.Departments
(
    department_id          INT          NOT NULL,

    department_code        VARCHAR(20)  NOT NULL,

    department_name        VARCHAR(100) NOT NULL,

    department_description VARCHAR(250) NOT NULL,

    status                 VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_Departments PRIMARY KEY (department_id)
);
GO

CREATE TABLE bronze.Materials
(
    material_id       INT           NOT NULL,

    material_code     VARCHAR(30)   NOT NULL,

    material_name     VARCHAR(100)  NOT NULL,

    material_category VARCHAR(60)   NOT NULL,

    material_type     VARCHAR(50)   NOT NULL,

    uom               VARCHAR(20)   NOT NULL,

    unit_weight       DECIMAL(18,3) NOT NULL,

    status            VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_Materials PRIMARY KEY (material_id)
);
GO

CREATE TABLE bronze.Suppliers
(
    supplier_id       INT          NOT NULL,

    supplier_code     VARCHAR(30)  NOT NULL,

    supplier_name     VARCHAR(120) NOT NULL,

    supplier_type     VARCHAR(50)  NOT NULL,

    supplier_category VARCHAR(50)  NOT NULL,

    country           VARCHAR(50)  NOT NULL,

    city              VARCHAR(50)  NOT NULL,

    address           VARCHAR(250) NOT NULL,

    contact_person    VARCHAR(100) NOT NULL,

    phone             VARCHAR(20)  NOT NULL,

    email             VARCHAR(120) NOT NULL,

    payment_terms     VARCHAR(50)  NOT NULL,

    status            VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_Suppliers PRIMARY KEY (supplier_id)
);
GO

CREATE TABLE bronze.SupplierMaterials
(
    supplier_material_id   INT           NOT NULL,

    supplier_id            INT           NOT NULL,

    material_id            INT           NOT NULL,

    supplier_material_code VARCHAR(50)   NOT NULL,

    standard_price         DECIMAL(18,2) NOT NULL,

    lead_time_days         INT           NOT NULL,

    minimum_order_quantity DECIMAL(18,2) NOT NULL,

    preferred_supplier     BIT           NOT NULL,

    status                 VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_SupplierMaterials PRIMARY KEY (supplier_material_id),

    CONSTRAINT FK_SupplierMaterials_Suppliers
            FOREIGN KEY (supplier_id) REFERENCES bronze.Suppliers(supplier_id),

    CONSTRAINT FK_SupplierMaterials_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

CREATE TABLE bronze.PurchaseRequisitions
(
    pr_id            INT          NOT NULL,

    pr_code          VARCHAR(20)  NOT NULL,

    department_id    INT          NOT NULL,

    requested_by     VARCHAR(100) NOT NULL,

    request_date     DATE         NOT NULL,

    order_date       DATE         NULL,

    -- NULL for rejected PRs
        required_date    DATE         NOT NULL,

    priority         VARCHAR(20)  NOT NULL,

    approval_status  VARCHAR(20)  NOT NULL,

    approved_by      VARCHAR(100) NOT NULL,

    approval_date    DATE         NOT NULL,

    rejection_reason VARCHAR(250) NULL,

    -- NULL for approved PRs
        created_date     DATETIME2(0) NOT NULL,

    CONSTRAINT PK_PurchaseRequisitions PRIMARY KEY (pr_id),

    CONSTRAINT FK_PurchaseRequisitions_Departments
            FOREIGN KEY (department_id) REFERENCES bronze.Departments(department_id)
);
GO

CREATE TABLE bronze.PurchaseRequisitionDetails
(
    pr_detail_id        INT           NOT NULL,

    pr_id               INT           NOT NULL,

    material_id         INT           NOT NULL,

    requested_quantity  DECIMAL(18,2) NOT NULL,

    estimated_unit_cost DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_PurchaseRequisitionDetails PRIMARY KEY (pr_detail_id),

    CONSTRAINT FK_PRDetails_PR
            FOREIGN KEY (pr_id) REFERENCES bronze.PurchaseRequisitions(pr_id),

    CONSTRAINT FK_PRDetails_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

CREATE TABLE bronze.PurchaseOrders
(
    po_id                  INT          NOT NULL,

    po_code                VARCHAR(20)  NOT NULL,

    supplier_id            INT          NOT NULL,

    pr_id                  INT          NOT NULL,

    order_date             DATE         NOT NULL,

    expected_delivery_date DATE         NOT NULL,

    payment_terms          VARCHAR(50)  NOT NULL,

    status                 VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_PurchaseOrders PRIMARY KEY (po_id),

    CONSTRAINT FK_PurchaseOrders_Suppliers
            FOREIGN KEY (supplier_id) REFERENCES bronze.Suppliers(supplier_id),

    CONSTRAINT FK_PurchaseOrders_PR
            FOREIGN KEY (pr_id) REFERENCES bronze.PurchaseRequisitions(pr_id)
);
GO

CREATE TABLE bronze.PurchaseOrderDetails
(
    po_detail_id           INT           NOT NULL,

    po_id                  INT           NOT NULL,

    pr_detail_id           INT           NOT NULL,

    material_id            INT           NOT NULL,

    ordered_quantity       DECIMAL(18,2) NOT NULL,

    unit_price             DECIMAL(18,2) NOT NULL,

    discount_percentage    DECIMAL(5,2)  NOT NULL,

    expected_delivery_date DATE          NOT NULL,

    total_amount           DECIMAL(18,2) NOT NULL,

    line_status            VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_PurchaseOrderDetails PRIMARY KEY (po_detail_id),

    CONSTRAINT FK_PODetails_PO
            FOREIGN KEY (po_id) REFERENCES bronze.PurchaseOrders(po_id),

    CONSTRAINT FK_PODetails_PRDetails
            FOREIGN KEY (pr_detail_id) REFERENCES bronze.PurchaseRequisitionDetails(pr_detail_id),

    CONSTRAINT FK_PODetails_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

/*=============================================================================
 4. INBOUND LOGISTICS, RECEIVING & ACCOUNTS PAYABLE
=============================================================================*/
CREATE TABLE bronze.SupplierShipments
(
    shipment_id           INT           NOT NULL,

    shipment_code         VARCHAR(20)   NOT NULL,

    po_id                 INT           NOT NULL,

    supplier_id           INT           NOT NULL,

    supplier_reference    VARCHAR(50)   NOT NULL,

    ship_date             DATE          NOT NULL,

    expected_arrival_date DATE          NOT NULL,

    actual_arrival_date   DATE          NOT NULL,

    total_shipment_value  DECIMAL(18,2) NOT NULL,

    shipping_cost         DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_SupplierShipments PRIMARY KEY (shipment_id),

    CONSTRAINT FK_SupplierShipments_PO
            FOREIGN KEY (po_id) REFERENCES bronze.PurchaseOrders(po_id),

    CONSTRAINT FK_SupplierShipments_Suppliers
            FOREIGN KEY (supplier_id) REFERENCES bronze.Suppliers(supplier_id)
);
GO

CREATE TABLE bronze.SupplierShipmentDetails
(
    shipment_detail_id INT           NOT NULL,

    shipment_id        INT           NOT NULL,

    po_detail_id       INT           NOT NULL,

    material_id        INT           NOT NULL,

    received_quantity  DECIMAL(18,2) NOT NULL,

    accepted_quantity  DECIMAL(18,2) NOT NULL,

    rejected_quantity  DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_SupplierShipmentDetails PRIMARY KEY (shipment_detail_id),

    CONSTRAINT FK_SupplierShipmentDetails_Shipments
            FOREIGN KEY (shipment_id) REFERENCES bronze.SupplierShipments(shipment_id),

    CONSTRAINT FK_SupplierShipmentDetails_PODetails
            FOREIGN KEY (po_detail_id) REFERENCES bronze.PurchaseOrderDetails(po_detail_id),

    CONSTRAINT FK_SupplierShipmentDetails_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

CREATE TABLE bronze.GoodsReceipts
(
    gr_id                INT           NOT NULL,

    gr_code              VARCHAR(20)   NOT NULL,

    shipment_id          INT           NOT NULL,

    receipt_date         DATE          NOT NULL,

    received_by          VARCHAR(100)  NOT NULL,

    quality_check_status VARCHAR(20)   NOT NULL,

    total_received_value DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_GoodsReceipts PRIMARY KEY (gr_id),

    CONSTRAINT FK_GoodsReceipts_Shipments
            FOREIGN KEY (shipment_id) REFERENCES bronze.SupplierShipments(shipment_id)
);
GO

CREATE TABLE bronze.GoodsReceiptDetails
(
    gr_detail_id       INT           NOT NULL,

    gr_id              INT           NOT NULL,

    shipment_detail_id INT           NOT NULL,

    material_id        INT           NOT NULL,

    received_quantity  DECIMAL(18,2) NOT NULL,

    accepted_quantity  DECIMAL(18,2) NOT NULL,

    rejected_quantity  DECIMAL(18,2) NOT NULL,

    inspection_status  VARCHAR(30)   NOT NULL,

    batch_number       VARCHAR(50)   NOT NULL,

    CONSTRAINT PK_GoodsReceiptDetails PRIMARY KEY (gr_detail_id),

    CONSTRAINT FK_GoodsReceiptDetails_GR
            FOREIGN KEY (gr_id) REFERENCES bronze.GoodsReceipts(gr_id),

    CONSTRAINT FK_GoodsReceiptDetails_ShipmentDetails
            FOREIGN KEY (shipment_detail_id)
            REFERENCES bronze.SupplierShipmentDetails(shipment_detail_id),

    CONSTRAINT FK_GoodsReceiptDetails_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

CREATE TABLE bronze.QualityInspections
(
    inspection_id         INT           NOT NULL,

    gr_detail_id          INT           NOT NULL,

    inspection_date       DATE          NOT NULL,

    inspection_type       VARCHAR(50)   NOT NULL,

    inspected_quantity    DECIMAL(18,2) NOT NULL,

    passed_quantity       DECIMAL(18,2) NOT NULL,

    inspection_result     VARCHAR(30)   NOT NULL,

    defect_quantity       DECIMAL(18,2) NOT NULL,

    defect_reason         VARCHAR(250)  NOT NULL,

    corrective_action     VARCHAR(250)  NOT NULL,

    reinspection_required BIT           NOT NULL,

    status                VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_QualityInspections PRIMARY KEY (inspection_id),

    CONSTRAINT FK_QualityInspections_GRDetails
            FOREIGN KEY (gr_detail_id) REFERENCES bronze.GoodsReceiptDetails(gr_detail_id)
);
GO

CREATE TABLE bronze.SupplierInvoices
(
    invoice_id     INT           NOT NULL,

    invoice_number VARCHAR(30)   NOT NULL,

    shipment_id    INT           NOT NULL,

    supplier_id    INT           NOT NULL,

    invoice_date   DATE          NOT NULL,

    invoice_amount DECIMAL(18,2) NOT NULL,

    tax_amount     DECIMAL(18,2) NOT NULL,

    total_amount   DECIMAL(18,2) NOT NULL,

    due_date       DATE          NOT NULL,

    payment_terms  VARCHAR(50)   NOT NULL,

    payment_status VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_SupplierInvoices PRIMARY KEY (invoice_id),

    CONSTRAINT FK_SupplierInvoices_Shipments
            FOREIGN KEY (shipment_id) REFERENCES bronze.SupplierShipments(shipment_id),

    CONSTRAINT FK_SupplierInvoices_Suppliers
            FOREIGN KEY (supplier_id) REFERENCES bronze.Suppliers(supplier_id)
);
GO

CREATE TABLE bronze.SupplierInvoiceDetails
(
    invoice_detail_id INT           NOT NULL,

    invoice_id        INT           NOT NULL,

    gr_detail_id      INT           NOT NULL,

    billed_quantity   DECIMAL(18,2) NOT NULL,

    unit_price        DECIMAL(18,2) NOT NULL,

    tax_amount        DECIMAL(18,2) NOT NULL,

    line_amount       DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_SupplierInvoiceDetails PRIMARY KEY (invoice_detail_id),

    CONSTRAINT FK_SupplierInvoiceDetails_Invoices
            FOREIGN KEY (invoice_id) REFERENCES bronze.SupplierInvoices(invoice_id),

    CONSTRAINT FK_SupplierInvoiceDetails_GRDetails
            FOREIGN KEY (gr_detail_id) REFERENCES bronze.GoodsReceiptDetails(gr_detail_id)
);
GO

CREATE TABLE bronze.SupplierPayments
(
    payment_id            INT           NOT NULL,

    invoice_id            INT           NOT NULL,

    payment_date          DATE          NOT NULL,

    payment_amount        DECIMAL(18,2) NOT NULL,

    payment_method        VARCHAR(30)   NOT NULL,

    currency              CHAR(3)       NOT NULL,

    transaction_reference VARCHAR(100)  NOT NULL,

    payment_status        VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_SupplierPayments PRIMARY KEY (payment_id),

    CONSTRAINT FK_SupplierPayments_Invoices
            FOREIGN KEY (invoice_id) REFERENCES bronze.SupplierInvoices(invoice_id)
);
GO

/*=============================================================================
 5. WAREHOUSES & RAW MATERIAL INVENTORY
=============================================================================*/
CREATE TABLE bronze.Warehouses
(
    warehouse_id         INT          NOT NULL,

    warehouse_code       VARCHAR(20)  NOT NULL,

    warehouse_name       VARCHAR(100) NOT NULL,

    warehouse_type       VARCHAR(50)  NOT NULL,

    country              VARCHAR(50)  NOT NULL,

    city                 VARCHAR(50)  NOT NULL,

    location_description VARCHAR(250) NOT NULL,

    status               VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_Warehouses PRIMARY KEY (warehouse_id)
);
GO

CREATE TABLE bronze.RawMaterialInventory
(
    raw_inventory_id    INT           NOT NULL,

    warehouse_id        INT           NOT NULL,

    material_id         INT           NOT NULL,

    quantity_on_hand    DECIMAL(18,2) NOT NULL,

    quantity_reserved   DECIMAL(18,2) NOT NULL,

    reorder_point       DECIMAL(18,2) NOT NULL,

    safety_stock_level  DECIMAL(18,2) NOT NULL,

    max_inventory_level DECIMAL(18,2) NOT NULL,

    unit_cost           DECIMAL(18,2) NOT NULL,

    last_updated_at     DATETIME2(0)  NOT NULL,

    CONSTRAINT PK_RawMaterialInventory PRIMARY KEY (raw_inventory_id),

    CONSTRAINT FK_RawInventory_Warehouses
            FOREIGN KEY (warehouse_id) REFERENCES bronze.Warehouses(warehouse_id),

    CONSTRAINT FK_RawInventory_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

/*=============================================================================
 6. PRODUCTION / ASSEMBLY
=============================================================================*/
CREATE TABLE bronze.Products
(
    product_id       INT           NOT NULL,

    product_code     VARCHAR(30)   NOT NULL,

    product_name     VARCHAR(100)  NOT NULL,

    product_category VARCHAR(50)   NOT NULL,

    uom              VARCHAR(20)   NOT NULL,

    standard_cost    DECIMAL(18,2) NOT NULL,

    selling_price    DECIMAL(18,2) NOT NULL,

    status           VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_Products PRIMARY KEY (product_id)
);
GO

CREATE TABLE bronze.ProductBOM
(
    bom_id            INT           NOT NULL,

    product_id        INT           NOT NULL,

    material_id       INT           NOT NULL,

    quantity_required DECIMAL(18,3) NOT NULL,

    uom               VARCHAR(20)   NOT NULL,

    status            VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_ProductBOM PRIMARY KEY (bom_id),

    CONSTRAINT FK_ProductBOM_Products
            FOREIGN KEY (product_id) REFERENCES bronze.Products(product_id),

    CONSTRAINT FK_ProductBOM_Materials
            FOREIGN KEY (material_id) REFERENCES bronze.Materials(material_id)
);
GO

CREATE TABLE bronze.Production
(
    production_id         INT           NOT NULL,

    production_order_code VARCHAR(30)   NOT NULL,

    product_id            INT           NOT NULL,

    planned_quantity      DECIMAL(18,2) NOT NULL,

    start_date            DATE          NOT NULL,

    expected_end_date     DATE          NOT NULL,

    actual_end_date       DATE          NOT NULL,

    production_quantity   DECIMAL(18,2) NOT NULL,

    rejected_quantity     DECIMAL(18,2) NOT NULL,

    production_status     VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_Production PRIMARY KEY (production_id),

    CONSTRAINT FK_Production_Products
            FOREIGN KEY (product_id) REFERENCES bronze.Products(product_id)
);
GO

CREATE TABLE bronze.ProductionDetails
(
    production_detail_id     INT           NOT NULL,

    production_id            INT           NOT NULL,

    bom_id                   INT           NOT NULL,

    raw_inventory_id         INT           NOT NULL,

    actual_consumed_quantity DECIMAL(18,3) NOT NULL,

    return_quantity          DECIMAL(18,3) NOT NULL,

    scrap_quantity           DECIMAL(18,3) NOT NULL,

    unit_cost                DECIMAL(18,2) NOT NULL,

    total_material_cost      DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_ProductionDetails PRIMARY KEY (production_detail_id),

    CONSTRAINT FK_ProductionDetails_Production
            FOREIGN KEY (production_id) REFERENCES bronze.Production(production_id),

    CONSTRAINT FK_ProductionDetails_BOM
            FOREIGN KEY (bom_id) REFERENCES bronze.ProductBOM(bom_id),

    CONSTRAINT FK_ProductionDetails_RawInventory
            FOREIGN KEY (raw_inventory_id) REFERENCES bronze.RawMaterialInventory(raw_inventory_id)
);
GO

CREATE TABLE bronze.RawMaterialInventoryTransactions
(
    raw_transaction_id INT           NOT NULL,

    raw_inventory_id   INT           NOT NULL,

    production_id      INT           NOT NULL,

    inspection_id      INT           NOT NULL,

    transaction_type   VARCHAR(40)   NOT NULL,

    quantity           DECIMAL(18,3) NOT NULL,

    unit_cost          DECIMAL(18,2) NOT NULL,

    transaction_date   DATETIME2(0)  NOT NULL,

    reference_code     VARCHAR(50)   NOT NULL,

    CONSTRAINT PK_RawMaterialInventoryTransactions PRIMARY KEY (raw_transaction_id),

    CONSTRAINT FK_RawTransactions_RawInventory
            FOREIGN KEY (raw_inventory_id) REFERENCES bronze.RawMaterialInventory(raw_inventory_id),

    CONSTRAINT FK_RawTransactions_Production
            FOREIGN KEY (production_id) REFERENCES bronze.Production(production_id),

    CONSTRAINT FK_RawTransactions_QualityInspection
            FOREIGN KEY (inspection_id) REFERENCES bronze.QualityInspections(inspection_id)
);
GO

/*=============================================================================
 7. FINISHED GOODS, SALES & CUSTOMER SHIPMENTS
=============================================================================*/
CREATE TABLE bronze.FinishedGoodsInventory
(
    finished_goods_inventory_id INT           NOT NULL,

    warehouse_id                INT           NOT NULL,

    product_id                  INT           NOT NULL,

    quantity_on_hand            DECIMAL(18,2) NOT NULL,

    quantity_reserved           INT           NOT NULL,

    reorder_point               DECIMAL(18,2) NOT NULL,

    safety_stock_level          DECIMAL(18,2) NOT NULL,

    last_updated_at             DATETIME2(0)  NOT NULL,

    CONSTRAINT PK_FinishedGoodsInventory PRIMARY KEY (finished_goods_inventory_id),

    CONSTRAINT FK_FGInventory_Warehouses
            FOREIGN KEY (warehouse_id) REFERENCES bronze.Warehouses(warehouse_id),

    CONSTRAINT FK_FGInventory_Products
            FOREIGN KEY (product_id) REFERENCES bronze.Products(product_id)
);
GO

CREATE TABLE bronze.Customers
(
    customer_id                 INT           NOT NULL,

    customer_code               VARCHAR(30)   NOT NULL,

    customer_name               VARCHAR(100)  NOT NULL,

    customer_type               VARCHAR(50)   NOT NULL,

    email                       VARCHAR(120)  NULL,

    phone                       VARCHAR(20)   NOT NULL,

    country                     VARCHAR(50)   NOT NULL,

    city                        VARCHAR(50)   NOT NULL,

    address                     VARCHAR(250)  NOT NULL,

    registration_date           DATE          NOT NULL,

    default_discount_percentage DECIMAL(5,2)  NOT NULL,

    status                      VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_Customers PRIMARY KEY (customer_id)
);
GO

CREATE TABLE bronze.SalesOrders
(
    sales_order_id         INT           NOT NULL,

    sales_order_code       VARCHAR(20)   NOT NULL,

    customer_id            INT           NOT NULL,

    order_date             DATE          NOT NULL,

    required_delivery_date DATE          NOT NULL,

    payment_method         VARCHAR(30)   NOT NULL,

    tax_percentage         DECIMAL(5,2)  NOT NULL,

    sales_order_status     VARCHAR(30)   NOT NULL,

    CONSTRAINT PK_SalesOrders PRIMARY KEY (sales_order_id),

    CONSTRAINT FK_SalesOrders_Customers
            FOREIGN KEY (customer_id) REFERENCES bronze.Customers(customer_id)
);
GO

CREATE TABLE bronze.SalesOrderDetails
(
    sales_order_detail_id INT           NOT NULL,

    sales_order_id        INT           NOT NULL,

    product_id            INT           NOT NULL,

    ordered_quantity      DECIMAL(18,2) NOT NULL,

    line_status           VARCHAR(30)   NOT NULL,

    CONSTRAINT PK_SalesOrderDetails PRIMARY KEY (sales_order_detail_id),

    CONSTRAINT FK_SalesOrderDetails_Orders
            FOREIGN KEY (sales_order_id) REFERENCES bronze.SalesOrders(sales_order_id),

    CONSTRAINT FK_SalesOrderDetails_Products
            FOREIGN KEY (product_id) REFERENCES bronze.Products(product_id)
);
GO

CREATE TABLE bronze.CustomerShipments
(
    customer_shipment_id   INT           NOT NULL,

    shipment_code          VARCHAR(20)   NOT NULL,

    sales_order_id         INT           NOT NULL,

    warehouse_id           INT           NOT NULL,

    shipment_date          DATE          NOT NULL,

    expected_delivery_date DATE          NOT NULL,

    actual_delivery_date   DATE          NULL,

    tracking_number        VARCHAR(50)   NOT NULL,

    shipping_method        VARCHAR(30)   NOT NULL,

    shipping_cost          DECIMAL(18,2) NOT NULL,

    delivery_address       VARCHAR(300)  NOT NULL,

    shipment_status        VARCHAR(30)   NOT NULL,

    delivery_confirmation  BIT           NOT NULL,

    customer_feedback      VARCHAR(500)  NOT NULL,

    CONSTRAINT PK_CustomerShipments PRIMARY KEY (customer_shipment_id),

    CONSTRAINT FK_CustomerShipments_SalesOrders
            FOREIGN KEY (sales_order_id) REFERENCES bronze.SalesOrders(sales_order_id),

    CONSTRAINT FK_CustomerShipments_Warehouses
            FOREIGN KEY (warehouse_id) REFERENCES bronze.Warehouses(warehouse_id)
);
GO

CREATE TABLE bronze.CustomerShipmentDetails
(
    customer_shipment_detail_id INT           NOT NULL,

    customer_shipment_id        INT           NOT NULL,

    sales_order_detail_id       INT           NOT NULL,

    shipped_quantity            DECIMAL(18,2) NOT NULL,

    CONSTRAINT PK_CustomerShipmentDetails PRIMARY KEY (customer_shipment_detail_id),

    CONSTRAINT FK_CustomerShipmentDetails_Shipments
            FOREIGN KEY (customer_shipment_id) REFERENCES bronze.CustomerShipments(customer_shipment_id),

    CONSTRAINT FK_CustomerShipmentDetails_SalesOrderDetails
            FOREIGN KEY (sales_order_detail_id) REFERENCES bronze.SalesOrderDetails(sales_order_detail_id)
);
GO

CREATE TABLE bronze.FinishedGoodsInventoryTransactions
(
    finished_inventory_transaction_id INT           NOT NULL,

    finished_goods_inventory_id       INT           NOT NULL,

    production_id                     INT           NOT NULL,

    customer_shipment_detail_id       INT           NOT NULL,

    transaction_type                  VARCHAR(40)   NOT NULL,

    quantity                          DECIMAL(18,2) NOT NULL,

    unit_cost                         DECIMAL(18,2) NOT NULL,

    transaction_date                  DATETIME2(0)  NOT NULL,

    reference_code                    VARCHAR(50)   NOT NULL,

    CONSTRAINT PK_FGInventoryTransactions PRIMARY KEY (finished_inventory_transaction_id),

    CONSTRAINT FK_FGTransactions_Inventory
            FOREIGN KEY (finished_goods_inventory_id) REFERENCES bronze.FinishedGoodsInventory(finished_goods_inventory_id),

    CONSTRAINT FK_FGTransactions_Production
            FOREIGN KEY (production_id) REFERENCES bronze.Production(production_id),

    CONSTRAINT FK_FGTransactions_CustomerShipmentDetails
            FOREIGN KEY (customer_shipment_detail_id)
            REFERENCES bronze.CustomerShipmentDetails(customer_shipment_detail_id)
);
GO

/*=============================================================================
 8. RETURNS
=============================================================================*/
CREATE TABLE bronze.Returns
(
    return_id                   INT           NOT NULL,

    return_code                 VARCHAR(20)   NOT NULL,

    customer_shipment_detail_id INT           NOT NULL,

    return_request_date         DATE          NOT NULL,

    return_received_date        DATE          NOT NULL,

    returned_quantity           DECIMAL(18,2) NOT NULL,

    return_reason               VARCHAR(120)  NOT NULL,

    product_condition           VARCHAR(50)   NOT NULL,

    return_status               VARCHAR(30)   NOT NULL,

    CONSTRAINT PK_Returns PRIMARY KEY (return_id),

    CONSTRAINT FK_Returns_CustomerShipmentDetails
            FOREIGN KEY (customer_shipment_detail_id)
            REFERENCES bronze.CustomerShipmentDetails(customer_shipment_detail_id)
);
GO

/*=============================================================================
 9. INDEXES FOR FOREIGN KEYS AND ANALYTICS
=============================================================================*/
CREATE INDEX IX_SupplierMaterials_Supplier ON bronze.SupplierMaterials(supplier_id);
CREATE INDEX IX_SupplierMaterials_Material ON bronze.SupplierMaterials(material_id);
CREATE INDEX IX_PR_Department ON bronze.PurchaseRequisitions(department_id);
CREATE INDEX IX_PR_ApprovalStatus ON bronze.PurchaseRequisitions(approval_status);
CREATE INDEX IX_PRDetails_PR ON bronze.PurchaseRequisitionDetails(pr_id);
CREATE INDEX IX_PO_Supplier ON bronze.PurchaseOrders(supplier_id);
CREATE INDEX IX_PO_PR ON bronze.PurchaseOrders(pr_id);
CREATE INDEX IX_PODetails_PO ON bronze.PurchaseOrderDetails(po_id);

CREATE INDEX IX_SupplierShipments_PO ON bronze.SupplierShipments(po_id);
CREATE INDEX IX_SupplierShipments_Supplier ON bronze.SupplierShipments(supplier_id);
CREATE INDEX IX_SupplierShipments_Arrival ON bronze.SupplierShipments(expected_arrival_date, actual_arrival_date);
CREATE INDEX IX_SupplierShipmentDetails_PO ON bronze.SupplierShipmentDetails(po_detail_id);
CREATE INDEX IX_GoodsReceipts_Shipment ON bronze.GoodsReceipts(shipment_id);
CREATE INDEX IX_GoodsReceiptDetails_Material ON bronze.GoodsReceiptDetails(material_id);
CREATE INDEX IX_QualityInspections_GRDetail ON bronze.QualityInspections(gr_detail_id);
CREATE INDEX IX_SupplierInvoices_Supplier ON bronze.SupplierInvoices(supplier_id);
CREATE INDEX IX_SupplierPayments_Invoice ON bronze.SupplierPayments(invoice_id);

CREATE INDEX IX_RawInventory_Material ON bronze.RawMaterialInventory(material_id);
CREATE INDEX IX_RawInventory_Warehouse ON bronze.RawMaterialInventory(warehouse_id);
CREATE INDEX IX_RawInventory_Reorder ON bronze.RawMaterialInventory(reorder_point, quantity_on_hand);
CREATE INDEX IX_RawTransactions_Date ON bronze.RawMaterialInventoryTransactions(transaction_date);
CREATE INDEX IX_RawTransactions_Inventory ON bronze.RawMaterialInventoryTransactions(raw_inventory_id);

CREATE INDEX IX_ProductBOM_Product ON bronze.ProductBOM(product_id);
CREATE INDEX IX_ProductBOM_Material ON bronze.ProductBOM(material_id);
CREATE INDEX IX_Production_Product ON bronze.Production(product_id);
CREATE INDEX IX_Production_Dates ON bronze.Production(start_date, expected_end_date, actual_end_date);
CREATE INDEX IX_ProductionDetails_Production ON bronze.ProductionDetails(production_id);

CREATE INDEX IX_FGInventory_Product ON bronze.FinishedGoodsInventory(product_id);
CREATE INDEX IX_FGInventory_Warehouse ON bronze.FinishedGoodsInventory(warehouse_id);
CREATE INDEX IX_Customers_City ON bronze.Customers(city);
CREATE INDEX IX_Customers_Type ON bronze.Customers(customer_type);
CREATE INDEX IX_Customers_Status ON bronze.Customers(status);
CREATE INDEX IX_SalesOrders_Customer ON bronze.SalesOrders(customer_id);
CREATE INDEX IX_SalesOrders_OrderDate ON bronze.SalesOrders(order_date);
CREATE INDEX IX_SalesOrderDetails_Order ON bronze.SalesOrderDetails(sales_order_id);
CREATE INDEX IX_SalesOrderDetails_Product ON bronze.SalesOrderDetails(product_id);
CREATE INDEX IX_CustomerShipments_Order ON bronze.CustomerShipments(sales_order_id);
CREATE INDEX IX_CustomerShipments_Status ON bronze.CustomerShipments(shipment_status);
CREATE INDEX IX_CustomerShipments_DeliveryDates ON bronze.CustomerShipments(expected_delivery_date, actual_delivery_date);
CREATE INDEX IX_CustomerShipmentDetails_Shipment ON bronze.CustomerShipmentDetails(customer_shipment_id);
CREATE INDEX IX_FGTransactions_Inventory ON bronze.FinishedGoodsInventoryTransactions(finished_goods_inventory_id);
CREATE INDEX IX_FGTransactions_Date ON bronze.FinishedGoodsInventoryTransactions(transaction_date);
CREATE INDEX IX_Returns_ShipmentDetail ON bronze.Returns(customer_shipment_detail_id);
CREATE INDEX IX_Returns_Condition ON bronze.Returns(product_condition);
GO

/*=============================================================================
 10. RELATIONSHIP SUMMARY
=============================================================================
 Procurement
 -----------
 Departments 1 ---- * PurchaseRequisitions
 PurchaseRequisitions 1 ---- * PurchaseRequisitionDetails
 Suppliers * ---- * Materials through SupplierMaterials
 PurchaseRequisitions 1 ---- 0..1 PurchaseOrders
 Suppliers 1 ---- * PurchaseOrders
 PurchaseOrders 1 ---- * PurchaseOrderDetails
 PurchaseRequisitionDetails 1 ---- 0..1 PurchaseOrderDetails

 Inbound / Quality / Finance
 ---------------------------
 PurchaseOrders 1 ---- 1 SupplierShipments (current generated dataset)
 PurchaseOrderDetails 1 ---- 1 SupplierShipmentDetails (current generated dataset)
 SupplierShipments 1 ---- 1 GoodsReceipts
 SupplierShipmentDetails 1 ---- 1 GoodsReceiptDetails
 GoodsReceiptDetails 1 ---- 1 QualityInspections
 SupplierShipments 1 ---- 1 SupplierInvoices
 SupplierInvoices 1 ---- * SupplierInvoiceDetails
 SupplierInvoices 1 ---- * SupplierPayments

 Inventory / Production
 ----------------------
 Warehouses 1 ---- * RawMaterialInventory
 Materials 1 ---- * RawMaterialInventory
 Products * ---- * Materials through ProductBOM
 Products 1 ---- * Production
 Production 1 ---- * ProductionDetails
 RawMaterialInventory 1 ---- * ProductionDetails
 RawMaterialInventory 1 ---- * RawMaterialInventoryTransactions
 Production 1 ---- * RawMaterialInventoryTransactions
 QualityInspections 1 ---- * RawMaterialInventoryTransactions

 Sales / Delivery / Returns
 --------------------------
 Warehouses 1 ---- * FinishedGoodsInventory
 Products 1 ---- * FinishedGoodsInventory
 Customers 1 ---- * SalesOrders
 SalesOrders 1 ---- * SalesOrderDetails
 Products 1 ---- * SalesOrderDetails
 SalesOrders 1 ---- 1 CustomerShipments (current generated dataset)
 CustomerShipments 1 ---- * CustomerShipmentDetails
 SalesOrderDetails 1 ---- 1 CustomerShipmentDetails (current generated dataset)
 FinishedGoodsInventory 1 ---- * FinishedGoodsInventoryTransactions
 Production 1 ---- * FinishedGoodsInventoryTransactions
 CustomerShipmentDetails 1 ---- * FinishedGoodsInventoryTransactions
 CustomerShipmentDetails 1 ---- * Returns
=============================================================================*/

/*=============================================================================
 11. POST-CREATION CHECK
=============================================================================*/
DECLARE @BusinessTableCount INT =
(
    SELECT COUNT(*)
    FROM sys.tables t
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE s.name = 'bronze'
);

PRINT 'ElectronicsSupplyChainDB created successfully.';
PRINT 'Business tables created: ' + CAST(@BusinessTableCount AS VARCHAR(10));
PRINT 'Expected business tables: 31';
PRINT 'DDL is aligned with the FINAL 200,000-row CSV generator.';
GO
