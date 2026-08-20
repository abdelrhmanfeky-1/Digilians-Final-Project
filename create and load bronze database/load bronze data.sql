USE ElectronicsSupplyChainDB;
GO

		/*
		=========================================================
					  ElectronicsSupplyChainDB
					  DATA LOADING SCRIPT
		=========================================================
		*/

CREATE OR ALTER PROCEDURE dbo.Load_bronze_data
AS
BEGIN
;
BEGIN TRY
			BEGIN TRANSACTION;



		/*=========================================================
						  DELETE ALL DATA
		=========================================================*/

		DELETE FROM bronze.Returns;

		DELETE FROM bronze.FinishedGoodsInventoryTransactions;
		DELETE FROM bronze.CustomerShipmentDetails;
		DELETE FROM bronze.CustomerShipments;
		DELETE FROM bronze.SalesOrderDetails;
		DELETE FROM bronze.SalesOrders;
		DELETE FROM bronze.Customers;
		DELETE FROM bronze.FinishedGoodsInventory;

		DELETE FROM bronze.RawMaterialInventoryTransactions;

		DELETE FROM bronze.ProductionDetails;
		DELETE FROM bronze.Production;
		DELETE FROM bronze.ProductBOM;
		DELETE FROM bronze.Products;

		DELETE FROM bronze.RawMaterialInventory;
		DELETE FROM bronze.Warehouses;

		DELETE FROM bronze.SupplierPayments;
		DELETE FROM bronze.SupplierInvoiceDetails;
		DELETE FROM bronze.SupplierInvoices;
		DELETE FROM bronze.QualityInspections;
		DELETE FROM bronze.GoodsReceiptDetails;
		DELETE FROM bronze.GoodsReceipts;
		DELETE FROM bronze.SupplierShipmentDetails;
		DELETE FROM bronze.SupplierShipments;

		DELETE FROM bronze.PurchaseOrderDetails;
		DELETE FROM bronze.PurchaseOrders;
		DELETE FROM bronze.PurchaseRequisitionDetails;
		DELETE FROM bronze.PurchaseRequisitions;
		DELETE FROM bronze.SupplierMaterials;
		DELETE FROM bronze.Suppliers;
		DELETE FROM bronze.Materials;
		DELETE FROM bronze.Departments;


		/*=========================================================
							  PROCUREMENT
		=========================================================*/

		BULK INSERT bronze.Departments
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Departments.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.Materials
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Materials.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.Suppliers
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Suppliers.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SupplierMaterials
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SupplierMaterials.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.PurchaseRequisitions
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\PurchaseRequisitions.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.PurchaseRequisitionDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\PurchaseRequisitionDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.PurchaseOrders
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\PurchaseOrders.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.PurchaseOrderDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\PurchaseOrderDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);


		/*=========================================================
						  INBOUND & QUALITY
		=========================================================*/

		BULK INSERT bronze.SupplierShipments
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SupplierShipments.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SupplierShipmentDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SupplierShipmentDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.GoodsReceipts
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\GoodsReceipts.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.GoodsReceiptDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\GoodsReceiptDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.QualityInspections
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\QualityInspections.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SupplierInvoices
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SupplierInvoices.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SupplierInvoiceDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SupplierInvoiceDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SupplierPayments
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SupplierPayments.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);


		/*=========================================================
							  INVENTORY
		=========================================================*/

		BULK INSERT bronze.Warehouses
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Warehouses.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.RawMaterialInventory
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\RawMaterialInventory.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);


		/*=========================================================
							  PRODUCTION
		=========================================================*/

		BULK INSERT bronze.Products
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Products.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.ProductBOM
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\ProductBOM.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

			BULK INSERT bronze.Production
			FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Production.csv'
			WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.ProductionDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\ProductionDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.RawMaterialInventoryTransactions
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\RawMaterialInventoryTransactions.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);


		/*=========================================================
								SALES
		=========================================================*/

		BULK INSERT bronze.FinishedGoodsInventory
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\FinishedGoodsInventory.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.Customers
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Customers.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SalesOrders
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SalesOrders.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.SalesOrderDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\SalesOrderDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.CustomerShipments
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\CustomerShipments.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.CustomerShipmentDetails
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\CustomerShipmentDetails.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);

		BULK INSERT bronze.FinishedGoodsInventoryTransactions
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\FinishedGoodsInventoryTransactions.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);


		/*=========================================================
								RETURNS
		=========================================================*/

		BULK INSERT bronze.Returns
		FROM 'C:\Users\A-FF-L5-D16\Desktop\raw data\Returns.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);


			COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;

		/*=========================================================
					  FINAL VALIDATION - 31 TABLES
		=========================================================*/

		WITH Validation AS
		(
			SELECT 1 AS load_order, 'bronze.Departments' AS table_name,
				   (SELECT COUNT(*) FROM bronze.Departments) AS row_count

			UNION ALL SELECT 2, 'bronze.Materials',
				   (SELECT COUNT(*) FROM bronze.Materials)
			UNION ALL SELECT 3, 'bronze.Suppliers',
				   (SELECT COUNT(*) FROM bronze.Suppliers)
			UNION ALL SELECT 4, 'bronze.SupplierMaterials',
				   (SELECT COUNT(*) FROM bronze.SupplierMaterials)
			UNION ALL SELECT 5, 'bronze.PurchaseRequisitions',
				   (SELECT COUNT(*) FROM bronze.PurchaseRequisitions)
			UNION ALL SELECT 6, 'bronze.PurchaseRequisitionDetails',
				   (SELECT COUNT(*) FROM bronze.PurchaseRequisitionDetails)
			UNION ALL SELECT 7, 'bronze.PurchaseOrders',
				   (SELECT COUNT(*) FROM bronze.PurchaseOrders)
			UNION ALL SELECT 8, 'bronze.PurchaseOrderDetails',
				   (SELECT COUNT(*) FROM bronze.PurchaseOrderDetails)

			UNION ALL SELECT 9, 'bronze.SupplierShipments',
				   (SELECT COUNT(*) FROM bronze.SupplierShipments)
			UNION ALL SELECT 10, 'bronze.SupplierShipmentDetails',
				   (SELECT COUNT(*) FROM bronze.SupplierShipmentDetails)
			UNION ALL SELECT 11, 'bronze.GoodsReceipts',
				   (SELECT COUNT(*) FROM bronze.GoodsReceipts)
			UNION ALL SELECT 12, 'bronze.GoodsReceiptDetails',
				   (SELECT COUNT(*) FROM bronze.GoodsReceiptDetails)
			UNION ALL SELECT 13, 'bronze.QualityInspections',
				   (SELECT COUNT(*) FROM bronze.QualityInspections)
			UNION ALL SELECT 14, 'bronze.SupplierInvoices',
				   (SELECT COUNT(*) FROM bronze.SupplierInvoices)
			UNION ALL SELECT 15, 'bronze.SupplierInvoiceDetails',
				   (SELECT COUNT(*) FROM bronze.SupplierInvoiceDetails)
			UNION ALL SELECT 16, 'bronze.SupplierPayments',
				   (SELECT COUNT(*) FROM bronze.SupplierPayments)

			UNION ALL SELECT 17, 'bronze.Warehouses',
				   (SELECT COUNT(*) FROM bronze.Warehouses)
			UNION ALL SELECT 18, 'bronze.RawMaterialInventory',
				   (SELECT COUNT(*) FROM bronze.RawMaterialInventory)

			UNION ALL SELECT 19, 'bronze.Products',
				   (SELECT COUNT(*) FROM bronze.Products)
			UNION ALL SELECT 20, 'bronze.ProductBOM',
				   (SELECT COUNT(*) FROM bronze.ProductBOM)
			UNION ALL SELECT 21, 'bronze.Production',
				   (SELECT COUNT(*) FROM bronze.Production)
			UNION ALL SELECT 22, 'bronze.ProductionDetails',
				   (SELECT COUNT(*) FROM bronze.ProductionDetails)

			UNION ALL SELECT 23, 'bronze.RawMaterialInventoryTransactions',
				   (SELECT COUNT(*) FROM bronze.RawMaterialInventoryTransactions)

			UNION ALL SELECT 24, 'bronze.FinishedGoodsInventory',
				   (SELECT COUNT(*) FROM bronze.FinishedGoodsInventory)
			UNION ALL SELECT 25, 'bronze.Customers',
				   (SELECT COUNT(*) FROM bronze.Customers)
			UNION ALL SELECT 26, 'bronze.SalesOrders',
				   (SELECT COUNT(*) FROM bronze.SalesOrders)
			UNION ALL SELECT 27, 'bronze.SalesOrderDetails',
				   (SELECT COUNT(*) FROM bronze.SalesOrderDetails)
			UNION ALL SELECT 28, 'bronze.CustomerShipments',
				   (SELECT COUNT(*) FROM bronze.CustomerShipments)
			UNION ALL SELECT 29, 'bronze.CustomerShipmentDetails',
				   (SELECT COUNT(*) FROM bronze.CustomerShipmentDetails)
			UNION ALL SELECT 30, 'bronze.FinishedGoodsInventoryTransactions',
				   (SELECT COUNT(*) FROM bronze.FinishedGoodsInventoryTransactions)

			UNION ALL SELECT 31, 'bronze.Returns',
				   (SELECT COUNT(*) FROM bronze.Returns)
		)

		SELECT
			load_order,
			table_name,
			row_count,
			CASE
				WHEN row_count > 0 THEN 'PASS'
				ELSE 'EMPTY'
			END AS validation_status
		FROM Validation
		ORDER BY load_order;

END;
GO
