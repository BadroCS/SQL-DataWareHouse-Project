/*
===============================================================================
Script Purpose:
    This script performs data quality checks on the 'silver' schema tables
    after they have been loaded from the 'bronze' layer. It validates:
        - Primary key uniqueness and nullability
        - Unwanted leading/trailing spaces in string columns
        - Standardization and consistency of categorical/coded values
        - Validity and logical ordering of date columns
        - Consistency between sales, quantity, and price
    Run this script after executing silver.load_silver to confirm the silver
    tables are clean before they are consumed downstream (e.g. by the gold
    layer).

WARNING:
    This is a read-only diagnostic script (SELECT statements only); it does
    not modify any data. Any query below that returns rows indicates a data
    quality issue that should be investigated and, if needed, fixed in the
    silver load logic (silver.load_silver) rather than patched here.
===============================================================================
*/

--===========================
-- CHECK silver.crm_cust_info
--===========================

-- Check for NULLs or duplicate values in the primary key (cst_id)
-- Expectation: No rows returned
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No rows returned
SELECT 
*
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
OR cst_lastname != TRIM(cst_lastname)
OR cst_marital_status != TRIM(cst_marital_status)
OR cst_gndr != TRIM(cst_gndr)


-- Data Standardization & Consistency
-- Review the set of distinct values to confirm they match the expected
-- standardized labels (e.g. 'Single', 'Married', 'n/a')
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

-- Review the set of distinct values to confirm they match the expected
-- standardized labels (e.g. 'Male', 'Female', 'n/a')
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info
-----------------------

--===========================
-- CHECK silver.crm_prd_info
--===========================

-- Check for NULLs or duplicate values in the primary key (prd_id)
-- Expectation: No rows returned
SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No rows returned
SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key)
OR prd_nm != TRIM(prd_nm)

-- Check for negative or NULL product costs
-- Expectation: No rows returned
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL




-- Data Standardization & Consistency
-- Review the set of distinct values to confirm they match the expected
-- standardized labels (e.g. 'Mountain', 'Road', 'Other Sales', 'Touring', 'n/a')
SELECT DISTINCT prd_line
FROM silver.crm_prd_info


-- Check for invalid date order (start date later than end date)
-- Expectation: No rows returned
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

------------------------

--===============================
-- CHECK silver.crm_sales_details
--===============================

-- Check for NULLs in the primary key (sls_ord_num)
-- Expectation: No rows returned
SELECT 
	sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No rows returned
SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)
OR sls_prd_key != TRIM(sls_prd_key)


-- Check for dates outside the accepted range (1900-01-01 to 2030-01-01)
-- Expectation: No rows returned
SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_order_dt NOT BETWEEN '19000101' AND '20300101'
OR sls_ship_dt NOT BETWEEN '19000101' AND '20300101'
OR sls_due_dt NOT BETWEEN '19000101' AND '20300101'


-- Check for invalid date order (order date after ship date, or ship date
-- after due date)
-- Expectation: No rows returned
SELECT 
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_ship_dt > sls_due_dt

-- Check that sales = quantity * price, and that none of the three are
-- NULL or non-positive
-- Expectation: No rows returned
SELECT 
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE 
		sls_sales != sls_price * sls_quantity
		OR sls_sales IS NULL OR sls_sales <= 0 
		OR sls_quantity IS NULL OR sls_quantity <= 0 
		OR sls_price IS NULL OR sls_price <= 0 
		
------------------------------------------

--===========================
-- CHECK silver.erp_cust_az12
--===========================

-- Check for NULLs or duplicate values in the primary key (cid)
-- Expectation: No rows returned
SELECT 
	cid,
	COUNT(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No rows returned
SELECT 
	cid,
	gen
FROM silver.erp_cust_az12
WHERE cid != TRIM(cid)
OR gen != TRIM(gen)


-- Check for out-of-range birth dates (before 1900-01-01 or in the future)
-- Expectation: No rows returned
SELECT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate NOT BETWEEN '1900-01-01' AND GETDATE()

-- Data Standardization & Consistency
-- Review the set of distinct values to confirm they match the expected
-- standardized labels (e.g. 'Male', 'Female', 'n/a')
SELECT DISTINCT gen
FROM silver.erp_cust_az12
----------------------------------

--===========================
-- CHECK silver.erp_loc_a101
--===========================

-- Check for NULLs or duplicate values in the primary key (cid)
-- Expectation: No rows returned
SELECT 
	cid,
	COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No rows returned
SELECT 
	cid,
	cntry
FROM silver.erp_loc_a101
WHERE cid != TRIM(cid)
OR cntry != TRIM(cntry)



-- Data Standardization & Consistency
-- Review the set of distinct country values to confirm they match the
-- expected standardized labels (e.g. 'United States', 'Germany', 'n/a')
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry
-------------------------

--=============================
-- CHECK silver.erp_px_cat_g1v2
--=============================

-- Check for NULLs or duplicate values in the primary key (id)
-- Expectation: No rows returned
SELECT 
	id,
	COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1 OR id IS NULL

-- Check for unwanted leading/trailing spaces in string columns
-- Expectation: No rows returned
SELECT 
	*
FROM silver.erp_px_cat_g1v2
WHERE 
	id != TRIM(id)
	OR cat != TRIM(cat)
	OR subcat != TRIM(subcat)
	OR maintenance != TRIM(maintenance)




-- Data Standardization & Consistency
-- Review the set of distinct category values
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2

-- Review the set of distinct subcategory values
SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2

-- Review the set of distinct maintenance flag values
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

-- Sanity check: number of distinct subcategories per category
SELECT 
	cat,
	COUNT(DISTINCT subcat) NB_subcat
FROM silver.erp_px_cat_g1v2
GROUP BY cat