# ONLINE-RETAIL-STORE-SALES-ANALYSIS-USING-SQL
"STORE SALES ANALYSIS FOR DATA-DRIVEN BUSINESS IMPROVEMENT"

This project involves cleaning, transforming, and analyzing an 
online retail store's transactional sales data using SQL. 
The goal is to uncover business insights and solve key operational 
challenges to help improve profitability, customer experience, and 
operational efficiency.

## 📊 Project Objectives

- Clean raw sales data for analysis
- Identify and solve business problems using SQL
- Extract actionable insights from the data
- Help stakeholders make data-driven decisions

## 🧠 Business Problem

The store lacked visibility on key performance areas such as:
- Best-selling products
- Frequent cancellations and returns
- Customer spending behavior
- High-demand product categories
- Peak sales hours
- Most preferred payment modes
- Sales trends by month
- Demographic preferences

Without these insights, the store faced:
- Missed sales opportunities  
- Inefficient inventory and staffing  
- Low customer satisfaction  
- Poor decision-making

## 🧹 Data Cleaning (SQL)

Steps performed:

1. **Duplicate Removal**  
   - Detected and removed duplicate `transaction_id` rows using `ROW_NUMBER()`.

2. **Fixing Column Names**  
   - Corrected column name typos (`quantiy` ➝ `quantity`, `prce` ➝ `price`).

3. **Data Type Verification**  
   - Checked all columns' data types using `information_schema`.

4. **Handling Null Values**  
   - Removed rows with missing critical IDs.
   - Imputed missing customer information using reference values.

5. **Standardizing Categorical Values**  
   - Unified values like `M` ➝ `Male`, `F` ➝ `Female`, `CC` ➝ `Credit Card`.

## 📈 Data Analysis & Insights

| Question | Insight | Business Impact |
|---------|---------|-----------------|
| **1. Top 5 Most Selling Products?** | Identified best-sellers | Optimize inventory, boost promotions |
| **2. Most Frequently Cancelled Products?** | Pinpointed problematic items | Improve product quality or listing |
| **3. Peak Purchase Times?** | Found busiest hours | Optimize staffing, marketing |
| **4. Top 5 Highest Spending Customers?** | Identified VIP customers | Enable loyalty and personalized offers |
| **5. Highest Revenue Product Categories?** | Ranked categories by revenue | Focus on high-margin products |
| **6. Cancellation/Return Rate by Category?** | Found problem categories | Improve product descriptions & logistics |
| **7. Preferred Payment Modes?** | Highlighted payment preference | Streamline payment processing |
| **8. Age Group Purchase Behavior?** | 26–35 age group spent most | Targeted marketing |
| **9. Monthly Sales Trend?** | Seasonal peaks observed | Better forecasting & planning |
| **10. Gender-Based Product Preference?** | Gender trends by category | Personalized advertising |


🛠️ Tools Used
- SQL (PostgreSQL)
- Sales transactional dataset (CSV/Database)
- Canva for PowerPoint preparation

Dataset download link:- [https://www.kaggle.com/datasets/ankit...](https://www.kaggle.com/datasets/ankitrajmishra/sales-store)
