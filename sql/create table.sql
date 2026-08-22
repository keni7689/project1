-- ============================================
-- STEP 1: Create the raw table
-- This table stores the CSV data EXACTLY as-is — no cleaning, no transformation.
-- We keep a "raw" table so we always have an untouched copy of the original data
-- to go back to if something goes wrong during cleaning later.
-- ============================================
CREATE TABLE telecom_customers_raw (
    customerID          VARCHAR(20)     PRIMARY KEY,   -- unique customer identifier (text, not numeric)
    gender               VARCHAR(10),
    SeniorCitizen        INTEGER,                       -- 0 or 1 flag, kept as-is (no cleaning yet)
    Partner               VARCHAR(5),
    Dependents            VARCHAR(5),
    tenure                INTEGER,                       -- number of months, whole number
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
    MonthlyCharges         NUMERIC(8,2),                 -- money value, 2 decimal places
    TotalCharges            VARCHAR(20),                  -- kept as TEXT for now — raw CSV has blank values here, so we don't force it to NUMERIC yet
    Churn                    VARCHAR(5)                    -- target column: 'Yes' or 'No'
);

select * from telecom_customers_raw;




