-- ============================================
-- 1. Total number of rows
-- Confirms how many customer records exist in the table
-- ============================================
SELECT COUNT(*) AS total_rows
FROM telecom_customers_raw;

-- ============================================
-- 2. Duplicate customerID check
-- customerID should be unique per customer — this finds any ID appearing more than once
-- ============================================
SELECT customerID, COUNT(*) AS occurrences
FROM telecom_customers_raw
GROUP BY customerID
HAVING COUNT(*) > 1;

-- ============================================
-- 3. NULL values in important columns
-- Counts missing values in the columns that matter most for churn analysis
-- ============================================
SELECT
    COUNT(*) FILTER (WHERE customerID IS NULL)      AS null_customerID,
    COUNT(*) FILTER (WHERE tenure IS NULL)           AS null_tenure,
    COUNT(*) FILTER (WHERE Contract IS NULL)         AS null_contract,
    COUNT(*) FILTER (WHERE MonthlyCharges IS NULL)   AS null_monthlycharges,
    COUNT(*) FILTER (WHERE TotalCharges IS NULL)     AS null_totalcharges,
    COUNT(*) FILTER (WHERE Churn IS NULL)            AS null_churn
FROM telecom_customers_raw;


-- ============================================
-- 4. Distinct values of Churn
-- Churn is the target column — should only have 2 values: 'Yes' and 'No'
-- ============================================
SELECT DISTINCT Churn
FROM telecom_customers_raw;

-- ============================================
-- 5. Distinct values of Contract
-- Should only have 3 values: 'Month-to-month', 'One year', 'Two year'
-- ============================================
SELECT DISTINCT Contract
FROM telecom_customers_raw;

-- ============================================
-- 6. Distinct values of InternetService
-- Should only have 3 values: 'DSL', 'Fiber optic', 'No'
-- ============================================
SELECT DISTINCT InternetService
FROM telecom_customers_raw;

-- ============================================
-- 7. Distinct values of PaymentMethod
-- Should only have 4 values (the 4 known payment types)
-- ============================================
SELECT DISTINCT PaymentMethod
FROM telecom_customers_raw;

-- ============================================
-- 8. Minimum and maximum tenure
-- tenure = number of months as a customer; should range roughly 0 to 72
-- ============================================
SELECT MIN(tenure) AS min_tenure, MAX(tenure) AS max_tenure
FROM telecom_customers_raw;

-- ============================================
-- 9. Minimum and maximum MonthlyCharges
-- MonthlyCharges = amount billed per month; should be a reasonable dollar range (roughly $18–$120)
-- ============================================
SELECT MIN(MonthlyCharges) AS min_monthly, MAX(MonthlyCharges) AS max_monthly
FROM telecom_customers_raw;

-- ============================================
-- 10. Minimum and maximum TotalCharges
-- TotalCharges is currently stored as TEXT (VARCHAR), not a number
-- So MIN/MAX here will sort alphabetically, not numerically — this query itself demonstrates the problem
-- ============================================
SELECT MIN(TotalCharges) AS min_total, MAX(TotalCharges) AS max_total
FROM telecom_customers_raw;

s