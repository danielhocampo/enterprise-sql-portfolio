# Enterprise Data Architecture & Analytics Portfolio 

Welcome to my portfolio! I am a Data Analyst & Business Systems Analyst bridging the gap between retail merchandising strategy and enterprise data architecture. My work focuses on data governance, pipeline optimization, and delivering clean, actionable datasets for business intelligence.

---

## 📁 Project 1: Automated Data Quality Profiler
**File:** `data_quality_profiler.sql`

** Business Context**
In omnichannel retail, raw transactional data ingested from mobile apps, physical POS systems, and e-commerce platforms is rarely perfectly clean. If dirty data reaches the reporting layer, it leads to inaccurate financial reporting and poor inventory decisions.

** The Objective & Technical Implementation**
Designed an automated QA pipeline running in the staging layer of a Data Warehouse (PostgreSQL / BigQuery). The script uses advanced SQL (Window Functions, Conditional Aggregation) to execute completeness, uniqueness, and business logic checks—flagging anomalies *before* they pass to production dashboards like Power BI or Tableau.

---

## 📁 Project 2: Omnichannel Loyalty Tracking (SCD Type 2)
**File:** `shiseido_loyalty_scd2.sql`

** Business Context**
Marketing teams need to know exactly *which* loyalty tier a customer was in at the exact time of a specific purchase to measure campaign effectiveness. Overwriting a customer's old tier with their new tier destroys historical conversion metrics. 

** The Objective & Technical Implementation**
Built a robust pipeline to process raw mobile app webhook data. 
1. **Deduplication:** Utilized `ROW_NUMBER()` to isolate and remove duplicate API triggers.
2. **Slowly Changing Dimensions (SCD Type 2):** Engineered historical tracking using the `LEAD()` window function to calculate the exact millisecond a loyalty tier expired, maintaining a perfect historical record of customer upgrades and downgrades over time.

---
*Technical Stack: PostgreSQL, Google BigQuery, Advanced SQL, Data Modeling*
