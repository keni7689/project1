# Telecom Customer Churn Analysis & Risk Prediction

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)](https://scikit-learn.org/)
[![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org/)

---

## 1. Project Title & Description

**Project Title:** Telecom Customer Churn Analysis & Risk Prediction

**Description:**  
This project is an **end-to-end data analytics and predictive machine learning solution** designed to analyze customer retention drivers and predict customer churn for a telecommunications provider. By combining **PostgreSQL database operations**, **Exploratory Data Analysis (EDA)**, **Scikit-Learn Machine Learning Models**, and **Power BI Visual Analytics**, this repository provides a complete pipeline from raw unstructured CSV ingestion to actionable, business-ready risk segmentations.

The core objective is to empower retention and customer success teams to identify high-risk customers before they cancel their service, quantify lost revenue, and implement targeted retention strategies.

---

## 2. Tech Stack

- **Database & Data Warehousing:** ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue?logo=postgresql) ![SQL](https://img.shields.io/badge/SQL-ANSI-lightgrey?logo=sqlite)
- **Data Engineering & Analysis:** ![Python](https://img.shields.io/badge/Python-3.13-blue?logo=python) ![Pandas](https://img.shields.io/badge/Pandas-2.3-150458?logo=pandas) ![NumPy](https://img.shields.io/badge/NumPy-2.3-013243?logo=numpy)
- **Machine Learning & Modeling:** ![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-LogisticRegression%20%26%20RandomForest-orange?logo=scikit-learn)
- **Database Connectivity:** ![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0-red?logo=python) ![Psycopg2](https://img.shields.io/badge/psycopg2--binary-2.9-darkgreen?logo=postgresql)
- **Business Intelligence & Visualization:** ![Power BI](https://img.shields.io/badge/Power_BI-Desktop-yellow?logo=powerbi) ![Seaborn](https://img.shields.io/badge/Seaborn-Visualization-blue) ![Matplotlib](https://img.shields.io/badge/Matplotlib-Plotting-green)
- **Development Environment:** ![Jupyter Notebook](https://img.shields.io/badge/Jupyter-Notebook-orange?logo=jupyter) ![VS Code](https://img.shields.io/badge/VS_Code-Editor-blue?logo=visualstudiocode)

---

## 3. Features

Within this project, users and analysts can perform the following actions:

- 🗄️ **Automated SQL ETL & Data Cleaning:**
  - Ingest raw customer dataset (`7,043` rows) into PostgreSQL untouched.
  - Automatically fix string-formatted monetary values (`TotalCharges`), handle nulls/blanks for brand new customers (`tenure = 0`), and eliminate duplicate customer records using window functions (`ROW_NUMBER()`).

- 🔍 **In-Depth Business Analysis via SQL Queries:**
  - Calculate overall baseline churn rate and churn counts.
  - Analyze churn breakdown across contract types (*Month-to-month*, *One year*, *Two year*), payment methods (*Electronic check*, *Mailed check*, etc.), and internet services (*Fiber Optic*, *DSL*).
  - Perform customer lifetime spend and recurring revenue impact analysis to measure revenue at risk.

- 🤖 **Predictive Churn Machine Learning Models:**
  - One-hot encode categorical features and scale numerical variables.
  - Train and evaluate predictive classification models (**Logistic Regression** and **Random Forest Classifier**) with stratified 80/20 train-test splits.
  - Generate churn prediction flags (`0` / `1`) and exact churn probability scores (`0.00` to `1.00`) per customer.

- 🎯 **Business Risk Tiering (Segmentation):**
  - Categorize customers into actionable risk levels:
    - 🟢 **Low Risk (`< 0.30`):** Customers expected to stay.
    - 🟡 **Medium Risk (`0.30 - 0.59`):** Watchlist customers requiring standard engagement.
    - 🔴 **High Risk (`>= 0.60`):** Top-priority retention targets for immediate intervention.

- 📊 **Interactive Power BI Executive Dashboard (`dashboard_redesigned.pbix`):**
  - Visually inspect customer churn demographics, key drivers, contract distribution, monthly charge impact, and high-risk customer lists for marketing teams.

---

## 4. Process

### How It Was Built

1. **Step 1: SQL Database Architecture & Data Ingestion (`/sql/create table.sql`)**
   - Created `telecom_customers_raw` table in PostgreSQL to store the raw CSV data without modifying the source structure.
   - Performed data quality checks (`/sql/data quality check.sql`) to inspect missing values, out-of-bound tenure values, and data type discrepancies.

2. **Step 2: SQL Data Cleaning & Staging (`/sql/clean.sql` & `/sql/analysis.sql`)**
   - Cleaned text-formatted `TotalCharges` into `NUMERIC(8,2)`. Replaced empty space strings for `tenure = 0` customers with `0`.
   - Built a clean analytical view `telecom_churn_analysis` containing filtered, structured features ready for downstream analytics.

3. **Step 3: Machine Learning Pipeline in Python (`/ML/load_data.ipynb`)**
   - Connected Python directly to PostgreSQL using `SQLAlchemy` and `psycopg2-binary`.
   - Preprocessed data: dropped non-predictive identifiers (`customerID`), mapped target `Churn` ('Yes'/'No' to 1/0), and applied `pd.get_dummies(drop_first=True)` for one-hot encoding.
   - Split dataset with stratification to maintain class balance.
   - Built and tested `LogisticRegression` and `RandomForestClassifier` models.
   - Computed churn probabilities and mapped them to `Low`, `Medium`, and `High` business risk labels.
   - Exported enriched predictions dataset `telecom_churn_predictions.csv` for BI dashboard consumption.

4. **Step 4: Interactive Dashboard Development (`dashboard_redesigned.pbix`)**
   - Designed Power BI reports to connect the prediction outputs with interactive slicers, KPIs (total revenue lost, churn rate %, high-risk customer count), and diagnostic charts.

### Key Learnings

- **Data Cleaning Hygiene:** Handling edge cases (e.g., zero tenure customers with blank total charges) early in SQL prevents downstream ML feature engineering failures.
- **Handling Multicollinearity:** Using `drop_first=True` during one-hot encoding avoids dummy variable traps in linear models.
- **Business-Oriented ML Metrics:** Raw probability values are hard for non-technical stakeholders to act on; mapping probabilities into clear risk tiers (`Low`, `Medium`, `High`) dramatically improves decision-making utility.
- **Key Churn Insights:**
  - Month-to-month contract holders with Fiber Optic service paying via Electronic Check demonstrate significantly higher churn rates than long-term contract holders.
  - New customers (tenure $\le$ 12 months) account for the highest concentration of churn.

---

## 5. Setup Instructions

Follow these steps to run the project locally on your system:

### Prerequisites

- **Python 3.10+**
- **PostgreSQL 13+** installed and running locally
- **Power BI Desktop** (Optional, for opening `.pbix` dashboard)
- Git & Code Editor (e.g. VS Code)

---

### Step-by-Step Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/your-username/telecom-churn-analysis.git
cd telecom-churn-analysis
```

#### 2. Configure PostgreSQL Database
1. Open PostgreSQL (via `psql` or `pgAdmin`).
2. Create a database named `telecom_churn_db`:
   ```sql
   CREATE DATABASE telecom_churn_db;
   ```
3. Execute the SQL scripts in order:
   - Run [`create table.sql`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/sql/create%20table.sql) to set up raw schema.
   - Import [`telecom_churn_analysis.csv`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/telecom_churn_analysis.csv) into table `telecom_customers_raw`.
   - Run [`clean.sql`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/sql/clean.sql) to clean data and create `telecom_customers_clean`.
   - Run [`analysis.sql`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/sql/analysis.sql) to generate `telecom_churn_analysis`.
   - (Optional) Run [`questions.sql`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/sql/questions.sql) to view SQL analytical query outputs.

#### 3. Python Environment Setup
Install required packages using pip:
```bash
pip install pandas numpy scikit-learn sqlalchemy psycopg2-binary matplotlib seaborn jupyter
```

#### 4. Run Machine Learning Pipeline
1. Open the Jupyter Notebook:
   ```bash
   jupyter notebook ML/load_data.ipynb
   ```
2. Update the PostgreSQL connection string in cell 2 if necessary:
   ```python
   engine = create_engine("postgresql://postgres:YOUR_PASSWORD@localhost:5432/telecom_churn_db")
   ```
3. Run all cells to execute the model, compute predictions, and output [`telecom_churn_predictions.csv`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/ML/telecom_churn_predictions.csv).

#### 5. View Dashboard
Open [`dashboard_redesigned.pbix`](file:///c:/Users/LEGION/Documents/class%20notes/project/project1/dashboard_redesigned.pbix) in Power BI Desktop to explore the interactive visual analytics.

---

## 6. Improvements

Here are planned future enhancements and optimizations for this project:

- 🚀 **Advanced Model Tuning & Ensemble Algorithms:** Implement **XGBoost**, **LightGBM**, and **CatBoost** alongside automated hyperparameter optimization (`GridSearchCV` / `Optuna`).
- ⚖️ **Imbalance Handling:** Apply **SMOTE** (Synthetic Minority Over-sampling Technique) or class weighting to boost recall for churned instances.
- ⚡ **API Service Deployment:** Wrap the trained machine learning model in a **FastAPI / Flask REST API** to enable real-time churn prediction requests.
- 🔄 **Automated ETL Pipeline:** Build an **Apache Airflow** or **Prefect** workflow to automate daily/weekly SQL ingestion and churn probability updating.
- 🔔 **Retention Alerting System:** Integrate automated notifications (Slack/Email Webhooks) to alert customer relationship managers when a client moves into the **High Risk** category.
