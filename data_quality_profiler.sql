/*
===============================================================================
Data Quality Profiling Script: Retail Transaction Staging Layer
===============================================================================
Author: Daniel Ocampo
Date: 2026-06-18
Database: PostgreSQL / Google BigQuery
Description: 
This script acts as an automated QA pipeline. It profiles raw retail transaction 
data in the staging layer to flag anomalies (duplicates, nulls, business logic 
errors) BEFORE the data is pushed to the production data warehouse or BI tools.

Business Context: 
Designed for an omnichannel retail environment (e.g., e-commerce + physical stores).
Identifies revenue-impacting data flaws such as negative prices, orphaned 
customer IDs, and duplicate mobile app transaction hashes.
===============================================================================
*/

WITH Basic_Metrics AS (
    -- 1. Volume and Completeness Checks
    SELECT 
        COUNT(*) AS total_transactions,
        COUNT(transaction_id) AS non_null_transactions,
        SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_ids,
        SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS null_store_ids
    FROM 
        stg_retail_transactions
),

Duplicate_Check AS (
    -- 2. Duplicate Detection using Window Functions
    SELECT 
        COUNT(*) AS duplicate_records
    FROM (
        SELECT 
            transaction_id,
            ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_timestamp DESC) as row_num
        FROM 
            stg_retail_transactions
    ) sub
    WHERE row_num > 1
),

Business_Logic_Check AS (
    -- 3. Business Rule Validations (e.g., No negative prices, dates in the future)
    SELECT 
        SUM(CASE WHEN item_price < 0 THEN 1 ELSE 0 END) AS negative_price_errors,
        SUM(CASE WHEN transaction_timestamp > CURRENT_TIMESTAMP THEN 1 ELSE 0 END) AS future_date_errors
    FROM 
        stg_retail_transactions
)

-- 4. Final Aggregated QA Report
SELECT 
    b.total_transactions,
    b.null_customer_ids,
    b.null_store_ids,
    d.duplicate_records,
    bl.negative_price_errors,
    bl.future_date_errors,
    CASE 
        WHEN d.duplicate_records > 0 OR bl.negative_price_errors > 0 THEN 'FAIL: Immediate Action Required'
        WHEN b.null_customer_ids > (b.total_transactions * 0.05) THEN 'WARNING: High Missing Customer Data'
        ELSE 'PASS: Ready for Production'
    END AS overall_data_health_status
FROM 
    Basic_Metrics b
CROSS JOIN 
    Duplicate_Check d
CROSS JOIN 
    Business_Logic_Check bl;
