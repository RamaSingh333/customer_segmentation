# customer_segmentation
 SQL project for banking customer segmentation and product recommendation.
# 🏦 Customer Segmentation Analysis with Loan Seekers

## 📌 Project Overview
This project demonstrates how SQL can be used to segment banking customers based on their transaction behavior.  
The analysis identifies customer groups such as **Loan Seekers**, **High Spenders**, and **Savers**, then recommends relevant banking products for each group.

The project is implemented in **MySQL** using aggregation, conditional logic, and Common Table Expressions (CTEs).

---

## 🎯 Objectives
1. Analyze customer transactions.
2. Segment customers based on activity and spending patterns.
3. Recommend appropriate banking products for each segment.
4. Provide insights on customer distribution across segments.

---

## 🗂 Database Schema
### **Tables**
- **`customers`** – Stores customer details (ID, name, age, gender, location).
- **`transactions`** – Stores transaction history (amount, date, category).
- **`products`** – Stores bank products and their target segment.

---

## 📊 Segmentation Logic
| Segment         | Criteria                                                                 |
|-----------------|--------------------------------------------------------------------------|
| Loan Seekers    | More than half of transactions are loan repayments                       |
| High Spenders   | Total transaction amount > 1500                                           |
| Savers          | Total transaction amount between 500 and 1500                            |
| Low Activity    | Total transaction amount < 500                                           |

---

## 🛠 SQL Features Used
- **DDL**: `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY`
- **DML**: `INSERT`, `SELECT`, `JOIN`
- **Aggregation**: `SUM()`, `COUNT()`
- **Conditional Logic**: `CASE WHEN`
- **CTE (WITH)** for modular queries

---

## 📈 Example Output
### **Customer Segments**
| customer_id | name   | segment       |
|-------------|--------|--------------|
| 1           | Alice  | Savers       |
| 2           | Bob    | Loan Seekers |
| 3           | Carol  | High Spenders|
| 4           | David  | Loan Seekers |

### **Product Recommendations**
| customer_id | name   | segment       | recommended_product     |
|-------------|--------|--------------|-------------------------|
| 1           | Alice  | Savers       | Savings Account         |
| 2           | Bob    | Loan Seekers | Home Loan               |
| 3           | Carol  | High Spenders| Premium Credit Card     |
| 4           | David  | Loan Seekers | Home Loan               |

---

## 🚀 How to Run
1. Open **MySQL Workbench**.
2. Create a new database:
   ```sql
   CREATE DATABASE customer_seg_proj;
   USE customer_seg_proj;
