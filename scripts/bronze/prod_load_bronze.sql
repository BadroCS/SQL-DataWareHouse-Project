-- =============================================================================
-- Script Purpose: Defines and creates the stored procedure [bronze].[load_bronze]
--                 responsible for loading raw data into the Bronze layer of the
--                 DataWarehouse. The procedure truncates each Bronze table and
--                 reloads it via BULK INSERT from flat CSV source files (CRM and
--                 ERP systems). Execution time is tracked per table and for the
--                 full batch. Errors are caught and printed without halting the
--                 calling session.
--
-- Parameters:     None — the procedure takes no input parameters.
--
-- Usage Example:
--                 EXEC bronze.load_bronze;
--
-- WARNING: This procedure TRUNCATES all Bronze tables before reloading them.
--          Any existing data will be permanently deleted on each execution.
--          Ensure source CSV files are accessible at the hardcoded paths before
--          running, or the BULK INSERT steps will fail.
-- =============================================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE
        @start_time       DATETIME,
        @end_time         DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME

    BEGIN TRY
        PRINT '==========================================';
        PRINT 'Loading the Bronze Layer';
        PRINT '==========================================';

        PRINT '------------------------------------------';
        PRINT 'Loading Source 1: CRM Tables';
        PRINT '------------------------------------------';

        SET @batch_start_time = GETDATE();

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info

        PRINT '>> Inserting Data Into bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Bougara Computer\Desktop\SQL_with_baraa\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '#--------#--------#--------#--------#';

        -- -----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info

        PRINT '>> Inserting Data Into bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Bougara Computer\Desktop\SQL_with_baraa\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '#--------#--------#--------#--------#';

        -- -----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details

        PRINT '>> Inserting Data Into bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Bougara Computer\Desktop\SQL_with_baraa\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '#--------#--------#--------#--------#';

        PRINT '------------------------------------------';
        PRINT 'Loading Source 2: ERP Tables';
        PRINT '------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12

        PRINT '>> Inserting Data Into bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Bougara Computer\Desktop\SQL_with_baraa\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '#--------#--------#--------#--------#';

        -- -----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101

        PRINT '>> Inserting Data Into bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Bougara Computer\Desktop\SQL_with_baraa\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '#--------#--------#--------#--------#';

        -- -----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> TRUNCATING Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2

        PRINT '>> Inserting Data Into bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Bougara Computer\Desktop\SQL_with_baraa\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading the Bronze Layer is Completed';
        PRINT ' - Load Batch Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';
        PRINT '#--------#--------#--------#--------#';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END
