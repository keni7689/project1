-- ============================================
-- Create the analysis-ready table for Python & Power BI
-- Selecting only columns that are meaningful for understanding/predicting churn
-- customerID is kept only as a unique reference key, not as a predictive feature
-- ============================================
CREATE TABLE telecom_churn_analysis AS
SELECT
    customerID,          -- unique reference ID, useful for joins/tracking, not a predictor

    -- Demographic columns: describe who the customer is
    gender,
    SeniorCitizen,
    Partner,
    Dependents,

    -- Account/relationship columns: describe how long and how they're tied to the company
    tenure,
    Contract,
    PaperlessBilling,
    PaymentMethod,

    -- Service columns: what services the customer actually uses
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,

    -- Billing columns: how much the customer pays
    MonthlyCharges,
    TotalCharges,

    -- Target variable: what we want to predict
    Churn

FROM telecom_customers_clean;


-- ============================================
-- Verify final table size: number of rows and number of columns
-- ============================================

-- Row count
SELECT COUNT(*) AS total_rows
FROM telecom_churn_analysis;

-- Column count (queries PostgreSQL's system catalog for this table's columns)
SELECT COUNT(*) AS total_columns
FROM information_schema.columns
WHERE table_name = 'telecom_churn_analysis';