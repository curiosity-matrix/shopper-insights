# 🛍️ ShopperInsights: Retail Store & Sales Analytics Platform
[ 🌐 View LIVE Dashboard here ] ( https://shopper-insights.onrender.com )

> **An End-to-End Retail Customer Shopping Behavior & Sales Intelligence System (Indian Retail Market)**  
> *Developed by [Ritika Singh](https://linkedin.com/in/ritika-singh-b07baa329) • B.Tech (AI & ML) @ SRMCEM*

---

## 📌 Executive Summary
In modern physical and omnichannel Indian retail stores (across cities like **Noida, Lucknow, Delhi, and Mumbai**), understanding customer purchasing habits in Indian Rupees (₹), category revenue drivers, and data quality is critical to optimizing floor layouts, inventory stocking, and business decisions.

**ShopperInsights** is a pure, production-grade **Data Analytics Platform** that:
1. Ingests and cleans retail billing transaction records using **Pandas & NumPy** (median imputation, IQR outlier capping in ₹).
2. Solves real-world store business questions using **MySQL / ANSI SQL** (`GROUP BY`, `HAVING`, `CASE WHEN`, `CTEs`, `DENSE_RANK()`).
3. Visualizes customer patterns using **Matplotlib & Seaborn**.
4. Provides an interactive, non-technical **Streamlit Dashboard** with live city/category filters and store manager recommendations.

---

## 🏗️ System Architecture

```text
       [Retail Customer Billing Records in INR (CSV)]
                            │
                            ▼
     [1. Data Cleaning Pipeline]  (Pandas & NumPy)
        - Missing Review Median Imputation
        - IQR Outlier Detection (in ₹)
        - Data Health Scoring (99.4%)
                            │
         ┌──────────────────┴──────────────────┐
         ▼                                     ▼
[2. SQL Analytics Engine]           [3. Data Visualizations]
   - MySQL / ANSI SQL                  - Seaborn & Matplotlib
   - CTEs & Window Functions           - Category Revenue & Age Trends
         │                                     │
         └──────────────────┬──────────────────┘
                            ▼
     [4. Streamlit Interactive Dashboard]
        - Simple, Non-Technical UI
        - Live Category & City Filters
        - Live SQL Question & Answer Studio
        - 1-Click Cleaned CSV Export
```

---

## 🛠️ Tech Stack & Skills Demonstrated

* **Databases & Querying**: MySQL, SQLite, ANSI SQL (`GROUP BY`, `HAVING`, `CASE WHEN`, `CTEs`, `DENSE_RANK()`)
* **Data Engineering & Cleaning**: Python, Pandas (`dropna`, `fillna`, `groupby`, `cut`), NumPy (`IQR`, `clip`, `where`)
* **Data Visualization**: Matplotlib, Seaborn, Streamlit

---

## 🗄️ Core SQL Business Questions Answered (in INR ₹)

1. **Which 5 categories generate the most sales?** (`GROUP BY`, `ORDER BY`, `LIMIT`)  
   Identifies department-wise sales volume in Rupees (₹) and average basket sizes.
2. **In which cities do customers spend more than ₹2,000 on average?** (`GROUP BY`, `HAVING`)  
   Filters premium city branches (Noida, Delhi, Mumbai, Lucknow) where average spending strictly exceeds ₹2,000.
3. **How can we divide customers into Budget, Medium, and VIP spenders?** (`CASE WHEN`)  
   Categorizes shoppers into *High Spenders (VIP >= ₹3,000)*, *Medium Spenders (>= ₹1,500)*, and *Budget Spenders*.
4. **Which categories perform above the store benchmark (₹2,000+)?** (`Common Table Expression / CTE`)  
   Calculates category-wide performance metrics and benchmarks them against store targets.
5. **Which are the top-rated products in each category?** (`Window Function: DENSE_RANK()`)  
   Ranks top-reviewed products within each category to feature on prime store displays.

---

## 🧹 Data Cleaning & Quality Audit (Pandas & NumPy)

* **Missing Values Fixed**: Blank ratings are filled using the **category-wise median** via `df.groupby('Category')['Review Rating'].transform('median')` to prevent distribution skew.
* **Outliers Checked**: Billing amounts are audited via the **Interquartile Range (IQR)** formula:
  $$\text{IQR} = Q_3 - Q_1$$
  $$\text{Upper Limit} = Q_3 + (1.5 \times \text{IQR})$$
  Abnormal scanner spikes are capped rather than dropped to preserve transactional audit integrity.

---

## 🔮 Future Scope & Planned Enhancements

* **Dynamic Multi-File Ingestion**: Allowing users to upload their own custom retail/e-commerce CSV files through the UI, with automated schema adaptation and metric mapping.
* **Automated Store Reporting**: Scheduling automated weekly PDF reports and alerts sent directly to retail store managers via email/webhook integration.
* **Machine Learning Propensity Model**: Incorporating predictive customer lifetime value and churn scoring.

---

## 🚀 How to Run Locally

### 1. Clone the repository
```bash
git clone https://github.com/curiosity-matrix/shopper-insights.git
cd shopper-insights
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Launch the Streamlit Dashboard
```bash
streamlit run app.py
```
*Your browser will automatically open at `http://localhost:8501`.*

---

## 📄 License
This project is open-source and available under the MIT License.
