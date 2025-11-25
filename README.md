# Instrumental Variables: Education and Wages

This project uses instrumental variables (IV) in R to estimate the causal effect of schooling on wages. The analysis is based on a classic labour-economics setup where **proximity to a college** is used as an instrument for years of education.

The work was originally done as part of an Advanced Statistics & Programming assignment, and has been refactored here into a standalone, portfolio-ready project with reproducible R code and a separate written report.

> ⚠️ **Data note**  
> The underlying dataset is course material and is **not included** in this repository. The code assumes access to a data frame with the variables described below (loaded from `education.RData`). Anyone with a similar dataset can adapt the code to replicate the analysis.

---

## 1. Research question

The central question is:

> **What is the causal effect of an additional year of education on log hourly wages?**

Simply regressing wages on years of schooling (OLS) is likely biased, because education is correlated with unobserved factors like ability, family background, or motivation. To address this endogeneity, the project uses **geographic proximity to a college** as an instrument for education.

---

## 2. Data

The project uses an individual-level dataset loaded from `education.RData`. In the code, the main data frame is stored as `dfeduc`, and a subset of relevant variables is selected into `dfeduc_rel`.

### 2.1 Key variables

- **Outcome**
  - `wage`: Hourly wage.
  - `lwage`: Log hourly wage (dependent variable in most models).

- **Endogenous regressor**
  - `educ`: Years of completed education.

- **Instruments**
  - `nearc4`: Indicator for living near a 4-year college.
  - `nearc2`: Indicator for living near a 2-year college.

- **Controls**
  - `age`: Age in years.
  - `fatheduc`: Father’s years of education.
  - `motheduc`: Mother’s years of education.
  - `IQ`: IQ score measure.
  - `married`: Indicator for being married.
  - `momdad14`: Lived with both parents at age 14.
  - `sinmom14`: Lived with single mother at age 14.
  - `step14`: Lived with a step-parent at age 14.
  - `exper`: Labour market experience.

These variables allow us to compare **pure OLS estimates** with **IV estimates** that exploit variation in education induced by proximity to college, while controlling for background characteristics.

---

## 3. Repository structure

A typical layout for this project is:

```text
iv-education-wages-college-proximity/
├─ README.md                         # This file
├─ R/
│  └─ 02_iv_education_wages.R        # Main analysis script
├─ data/
│  ├─ README.md                      # Notes on data and schema
│  └─ raw/
│     └─ education.RData             # Not included (course material, local only)
├─ report/
│  └─ iv_education_wages_report.pdf  # Written report with interpretation

