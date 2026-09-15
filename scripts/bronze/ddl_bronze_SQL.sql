-- =============================================================================
-- Script Purpose: Creates (or recreates) the Bronze layer staging tables in the
--                 DataWarehouse database. Each table mirrors its raw source file
--                 (CRM and ERP CSVs) with no transformations applied.
--                 Tables are dropped and recreated if they already exist.
--
-- WARNING: Running this script will permanently DROP all existing Bronze tables
--          and delete any data they contain. Ensure raw data has been backed up
--          or can be reloaded via BULK INSERT before executing.
-- =============================================================================

USE DataWarehouse;
GO

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(5),
    cst_gndr           NVARCHAR(5),
    cst_create_date    DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(5),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
    sls_ord_num  NVARCHAR(15),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
    cid   NVARCHAR(15),
    bdate DATE,
    gen   NVARCHAR(7)
);

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
    cid   NVARCHAR(15),
    cntry NVARCHAR(25)
);

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
    id          NVARCHAR(6),
    cat         NVARCHAR(15),
    subcat      NVARCHAR(25),
    maintenance NVARCHAR(4)
);
