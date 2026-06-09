#  Data Dictionary - Mutual Fund Analytics

This document provides the complete structural definitions, data types, and business descriptions for the Star Schema data warehouse implemented in `bluestock_mf.db`.

---

##  1. dim_fund (Dimension Table)
Stores primary master information for all mutual fund schemes.
* **amfi_code** (INTEGER, Primary Key): Unique 6-digit identification code assigned by the Association of Mutual Funds in India.
* **fund_house** (TEXT): Name of the Asset Management Company (AMC) managing the fund.
* **scheme_name** (TEXT): Full market name of the mutual fund scheme.
* **category** (TEXT): Broad asset class (e.g., Equity, Debt, Hybrid).
* **sub_category** (TEXT): Specific investment style (e.g., Large Cap, Mid Cap, Sectoral).
* **plan** (TEXT): Investment plan route (e.g., Direct, Regular).
* **launch_date** (TEXT): The official inception date of the fund.
* **benchmark** (TEXT): The baseline market index against which the fund's performance is measured.
* **fund_manager** (TEXT): Name of the professional managing the portfolio.
* **risk_category** (TEXT): Risk assessment tier (e.g., High, Very High, Moderate, Low).
* **sebi_category_code** (TEXT): Standardized regulatory code defined by SEBI.

---

##  2. dim_date (Dimension Table)
A time-dimension table generated to support granular time-series trend tracking.
* **date_id** (TEXT, Primary Key): Date string formatted as `YYYY-MM-DD`.
* **day** (INTEGER): Day of the month (1-31).
* **month** (INTEGER): Month of the year (1-12).
* **year** (INTEGER): Calendar year.
* **quarter** (INTEGER): Financial quarter of the year (1-4).

---

##  3. fact_nav (Fact Table)
Stores historical daily Net Asset Value (NAV) records for the funds.
* **nav_id** (INTEGER, Primary Key, Autoincrement): Internal surrogate key.
* **amfi_code** (INTEGER, Foreign Key): References `dim_fund(amfi_code)`.
* **date_id** (TEXT, Foreign Key): References `dim_date(date_id)`.
* **nav** (REAL): Net Asset Value price per unit on that specific date (validated to be > 0, forward-filled for holidays).

---

##  4. fact_transactions (Fact Table)
Captures granular retail investor purchase and redemption actions.
* **transaction_id** (TEXT, Primary Key): Unique alphanumeric transactional ledger reference identifier.
* **investor_id** (TEXT): Masked unique identifier for individual retail investors.
* **amfi_code** (INTEGER, Foreign Key): References `dim_fund(amfi_code)`.
* **transaction_date** (TEXT): Date of the transaction event (`YYYY-MM-DD`).
* **transaction_type** (TEXT): Standardized transactional action (SIP, Lumpsum, or Redemption).
* **amount_inr** (REAL): Net monetary value of the transaction in Indian Rupees (validated to be > 0).
* **state** (TEXT): Indian state where the investor is registered.
* **city** (TEXT): City name of the investor.
* **city_tier** (TEXT): Geographical market categorization (T30 for Top 30 cities, B30 for Beyond 30 cities).
* **age_group** (TEXT): Demographic classification of the investor.
* **gender** (TEXT): Gender profile of the investor.
* **annual_income_lakh** (REAL): Investor's self-declared annual income brackets in Lakhs.
* **payment_mode** (TEXT): Mode of transaction settlement (e.g., Net Banking, UPI, Mandate).
* **kyc_status** (TEXT): Standardized regulatory compliance enum status (e.g., Verified, Pending, Failed).

---

##  5. fact_performance (Fact Table)
Maintains analytical risk-return metrics for fund benchmarking evaluation.
* **amfi_code** (INTEGER, Primary Key / Foreign Key): References `dim_fund(amfi_code)`.
* **return_1yr_pct** (REAL): Total annualized percentage return over the trailing 12 months.
* **return_3yr_pct** (REAL): Annualized percentage return over the last 3 years.
* **return_5yr_pct** (REAL): Annualized percentage return over the last 5 years.
* **benchmark_3yr_pct** (REAL): Annualized percentage return of the fund's index benchmark over 3 years.
* **alpha** (REAL): Metric indicating the fund manager's outperformance relative to the benchmark.
* **beta** (REAL): Volatility indicator relative to the market index.
* **sharpe_ratio** (REAL): Risk-adjusted performance return index.
* **sortino_ratio** (REAL): Downside risk-adjusted performance return matrix.
* **std_dev_ann_pct** (REAL): Annualized standard deviation reflecting overall historical volatility.
* **max_drawdown_pct** (REAL): Peak-to-trough decline percentage representing maximum potential historical loss.
* **aum_crore** (REAL): Asset Under Management valuation sizing denoted in Crores.
* **expense_ratio_pct** (REAL): Total annual operating expenses charged by the scheme (validated within range 0.1% - 2.5%).
* **morningstar_rating** (INTEGER): Quantitative fund rating metric scaling from 1 to 5 stars.
* **risk_grade** (TEXT): Performance assessment grading category.
* **is_anomaly** (INTEGER): Flag (1 = Outlier data anomaly detected, 0 = Standard valid record).

---

## 6. fact_aum (Fact Table)
Tracks macroeconomic institutional fund asset sizing at the AMC level.
* **aum_id** (INTEGER, Primary Key, Autoincrement): Internal layout key identifier.
* **date_id** (TEXT, Foreign Key): References `dim_date(date_id)`.
* **fund_house** (TEXT): Name of the Asset Management Company.
* **aum_lakh_crore** (REAL): Cumulative industry assets sizing managed, in Lakh Crores.
* **aum_crore** (REAL): Absolute asset portfolio sizing in Crores.
* **num_schemes** (INTEGER): Count of total active structural schemes hosted by the AMC.