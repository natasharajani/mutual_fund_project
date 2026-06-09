-- 10 Analytical SQL Queries Deployment

-- Query 1: Top 5 Funds by AUM
SELECT f.scheme_name, p.aum_crore 
FROM fact_performance p
JOIN dim_fund f ON p.amfi_code = f.amfi_code
ORDER BY p.aum_crore DESC LIMIT 5;

-- Query 2: Average NAV per Month
SELECT strftime('%m', date_id) as Month, ROUND(AVG(nav), 2) as Avg_NAV 
FROM fact_nav GROUP BY Month;

-- Query 3: State-wise Investment Volume
SELECT state, ROUND(SUM(amount_inr)/10000000, 2) as Total_Cr 
FROM fact_transactions GROUP BY state ORDER BY Total_Cr DESC;

-- Query 4: Funds with Expense Ratio < 1%
SELECT f.scheme_name, p.expense_ratio_pct 
FROM fact_performance p
JOIN dim_fund f ON p.amfi_code = f.amfi_code
WHERE p.expense_ratio_pct < 1.0;

-- Query 5: Risk Profile Analysis
SELECT f.risk_category, COUNT(*) as Total_Schemes, ROUND(AVG(p.return_3yr_pct), 2) as Avg_3Yr_Return 
FROM fact_performance p
JOIN dim_fund f ON p.amfi_code = f.amfi_code
GROUP BY f.risk_category;