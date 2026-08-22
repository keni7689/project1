-- ============================================
-- STEP 1: Create the clean table with the correct structure
-- TotalCharges is now NUMERIC (fixed from raw table's VARCHAR)
-- SeniorCitizen is still INTEGER (0/1) — kept as-is, it's a valid binary flag
-- Everything else keeps the same structure as the raw table
-- ============================================
CREATE TABLE telecom_customers_clean (
    customerID          VARCHAR(20)     PRIMARY KEY,
    gender               VARCHAR(10),
    SeniorCitizen        INTEGER,
    Partner               VARCHAR(5),
    Dependents            VARCHAR(5),
    tenure                INTEGER,
    PhoneService          VARCHAR(5),
    MultipleLines         VARCHAR(30),
    InternetService       VARCHAR(20),
    OnlineSecurity        VARCHAR(30),
    OnlineBackup          VARCHAR(30),
    DeviceProtection      VARCHAR(30),
    TechSupport           VARCHAR(30),
    StreamingTV           VARCHAR(30),
    StreamingMovies       VARCHAR(30),
    Contract              VARCHAR(20),
    PaperlessBilling      VARCHAR(5),
    PaymentMethod         VARCHAR(30),
    MonthlyCharges         NUMERIC(8,2),
    TotalCharges            NUMERIC(8,2),   -- fixed: now a proper number, not text
    Churn                    VARCHAR(5)      -- kept as-is: this is our ML target column
);


-- ============================================
-- STEP 2: Insert cleaned data from the raw table
-- We SELECT from raw, fix problems along the way, and INSERT into clean
-- The raw table itself is never touched or modified
-- ============================================
INSERT INTO telecom_customers_clean
SELECT
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,

    -- Fix TotalCharges: convert text to number
    -- The 11 rows with blank TotalCharges all have tenure = 0 (brand new customers,
    -- not yet billed) — so it's realistic and safe to set their TotalCharges to 0
    -- instead of dropping these rows (they're still valid customer records)
    CASE
        WHEN TRIM(TotalCharges) = '' THEN 0
        ELSE TRIM(TotalCharges)::NUMERIC(8,2)
    END AS TotalCharges,

    Churn

FROM telecom_customers_raw

-- Remove duplicate customerID rows if any exist, keeping only one copy per ID
-- (ROW_NUMBER trick: numbers each duplicate group 1,2,3... and we only keep number 1)
WHERE customerID IN (
    SELECT customerID FROM (
        SELECT customerID,
               ROW_NUMBER() OVER (PARTITION BY customerID ORDER BY customerID) AS rn
        FROM telecom_customers_raw
    ) sub
    WHERE rn = 1
);


-- ============================================
-- STEP 3: Verify the clean table
-- Row count should match raw table (or be lower only if duplicates existed)
-- ============================================
SELECT COUNT(*) AS clean_row_count FROM telecom_customers_clean;

-- Confirm TotalCharges is now numeric and has no blanks/nulls
SELECT MIN(TotalCharges) AS min_total, MAX(TotalCharges) AS max_total
FROM telecom_customers_clean;