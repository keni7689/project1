-- ============================================
-- 1. Overall churn rate
-- What % of all customers have left the company?
-- ============================================
SELECT
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis;
-- Result: a single percentage — the baseline churn rate for the whole company


-- ============================================
-- 2. How many customers churned (raw count)
-- Simple headcount of Yes vs No
-- ============================================
SELECT
    Churn,
    COUNT(*) AS customer_count
FROM telecom_churn_analysis
GROUP BY Churn;
-- Result: two rows — count of 'Yes' (churned) and 'No' (stayed)


-- ============================================
-- 3. Churn rate by contract type
-- Does contract length affect whether customers leave?
-- ============================================
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY Contract
ORDER BY churn_rate_percent DESC;
-- Result: churn % per contract type — expect month-to-month to have the highest churn


-- ============================================
-- 4. Churn rate by internet service type
-- Does the type of internet service affect churn?
-- ============================================
SELECT
    InternetService,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;
-- Result: churn % per internet type — often Fiber optic customers churn more


-- ============================================
-- 5. Churn rate by payment method
-- Do certain payment methods correlate with higher churn?
-- ============================================
SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;
-- Result: churn % per payment type — electronic check often shows the highest churn


-- ============================================
-- 6. Churn rate by gender
-- Sanity-check: does gender actually influence churn? (usually it doesn't, much)
-- ============================================
SELECT
    gender,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY gender;
-- Result: churn % per gender — expect roughly similar rates for both, useful for
-- ruling gender out as a strong predictor when explaining feature choices


-- ============================================
-- 7. Churn rate by tenure group
-- Buckets customers into loyalty stages instead of looking at every individual month
-- ============================================
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months (new)'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months (loyal)'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY tenure_group
ORDER BY churn_rate_percent DESC;
-- Result: churn % per loyalty stage — expect newer customers to churn far more


-- ============================================
-- 8. Average MonthlyCharges: churned vs non-churned
-- Do customers who leave pay more per month on average?
-- ============================================
SELECT
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM telecom_churn_analysis
GROUP BY Churn;
-- Result: two average values — a higher average for 'Yes' suggests price sensitivity drives churn


-- ============================================
-- 9. Average TotalCharges: churned vs non-churned
-- Compares lifetime spend between the two groups
-- ============================================
SELECT
    Churn,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges
FROM telecom_churn_analysis
GROUP BY Churn;
-- Result: churned customers often show LOWER total charges — not because they pay less
-- per month, but because they leave early (low tenure), so they never accumulate spend


-- ============================================
-- 10. Which contract type has the highest churn? (single answer)
-- Same logic as query 3, but returns only the top result
-- ============================================
SELECT
    Contract,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY Contract
ORDER BY churn_rate_percent DESC
LIMIT 1;
-- Result: one row — the single riskiest contract type


-- ============================================
-- 11. Which payment method has the highest churn? (single answer)
-- Same logic as query 5, but returns only the top result
-- ============================================
SELECT
    PaymentMethod,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC
LIMIT 1;
-- Result: one row — the single riskiest payment method


-- ============================================
-- 12. Which customer segment has the highest churn?
-- Combines Contract + InternetService together for a more specific risk profile
-- ============================================
SELECT
    Contract,
    InternetService,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY Contract, InternetService
ORDER BY churn_rate_percent DESC
LIMIT 5;
-- Result: top 5 combined segments — usually "Month-to-month + Fiber optic" is the riskiest


-- ============================================
-- 13. Number of customers by contract type
-- Basic volume count — how large is each contract group?
-- ============================================
SELECT
    Contract,
    COUNT(*) AS total_customers
FROM telecom_churn_analysis
GROUP BY Contract
ORDER BY total_customers DESC;
-- Result: customer count per contract type — useful context alongside churn rate,
-- since a high churn % on a tiny group matters less than on a large one


-- ============================================
-- 14. Revenue comparison: churned vs non-churned customers
-- Estimates how much monthly revenue is "at risk" from churned customers
-- ============================================
SELECT
    Churn,
    COUNT(*) AS customer_count,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_revenue_per_customer
FROM telecom_churn_analysis
GROUP BY Churn;
-- Result: total and average monthly revenue for each group — the 'Yes' row shows
-- how much recurring monthly revenue the company has already lost to churn


-- ============================================
-- 15. Top risky customer segments (combined view)
-- Brings together Contract + PaymentMethod + tenure group for the clearest "who is likely to leave" picture
-- ============================================
SELECT
    Contract,
    PaymentMethod,
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        ELSE '13+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_percent
FROM telecom_churn_analysis
GROUP BY Contract, PaymentMethod, tenure_group
HAVING COUNT(*) >= 20   -- ignore tiny groups so the % isn't misleading (e.g., 1 out of 2 customers = 50%)
ORDER BY churn_rate_percent DESC
LIMIT 10;
-- Result: the 10 riskiest customer segments by combined profile — this is the kind of
-- output you'd hand to a retention/marketing team as an action list