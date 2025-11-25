# Instrumental Variables: Education and Wages

This project uses instrumental variables (IV) in R to estimate the causal effect of schooling on wages. The analysis is based on a classic labour-economics setup where **proximity to a college** is used as an instrument for years of education.

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

## 3. Assignment structure, questions, and report

This project is based on a two-part assignment: a **conceptual/theoretical** part about instrumental variables and a **hands-on empirical** part using real data on education and wages.  
A full written version of the answers is available in the report:

[iv_education_wages_report.pdf](report/iv_education_wages_report.pdf)

Below is a short summary of what each question in the assignment is doing.

---

### 3.1 Conceptual part – Instrumental variable theory

**Question 1 – Why OLS is biased with endogenous education**

This question explains why a simple OLS regression of wages on education is biased when education is **endogenous**. It discusses how unobserved factors (like ability or family background) end up in the error term and are correlated with education, violating the key assumption that the error has mean zero conditional on regressors. It also clarifies that an instrumental variable is not just another control: it is used to generate “clean” variation in the endogenous regressor that can be exploited via IV/2SLS to recover a causal effect.

**Question 2 – Different sources of bias in OLS**

Here the assignment systematically goes through several ways the OLS assumption can fail:

- **Omitted variable bias** (e.g. ability affects both education and wages)
- **Endogenous treatment / self-selection** (education choice depends on unobserved wage determinants)
- **Sample or selection bias** (wages observed only for those who are working, and selection into work is related to both education and unobserved components of wages)

Each case shows how \(E[\varepsilon \mid X] \neq 0\) and how this distorts the estimated return to education.

**Question 3 – When is proximity to college a valid instrument?**

This question takes **geographic proximity to a college** as a candidate instrument and evaluates the two core IV conditions:

- **Relevance**: proximity must shift education (people near a college should on average study more).
- **Cleanness / exogeneity**: proximity should not directly affect wages except through education.

The answer discusses potential threats to both:
for example, if commuting options make distance irrelevant (weak relevance) or if high-income families sort into neighbourhoods near colleges (violating exogeneity because proximity is then correlated with unobserved wage determinants).

The detailed reasoning and formal notation are in the report:  
[iv_education_wages_report.pdf](report/iv_education_wages_report.pdf).

---

### 3.2 Empirical part – Application to education and wages

**Question 1 – Describing the data and key variables**

The empirical part starts by computing and interpreting summary statistics for the main variables: log wages, years of education, the instruments (`nearc4`, `nearc2`), and background variables like parents’ education, family structure, and experience. This anchors the analysis in the actual data: how educated the sample is on average, how wages are distributed, and how many individuals live near 2-year or 4-year colleges.

**Question 2 – Testing instrument relevance in the data**

This question checks whether the 4-year college proximity instrument is **empirically relevant**. It:

- Runs a **first-stage regression** of education on `nearc4` (with and without controls).
- Uses **partial F-tests** to see whether `nearc4` significantly explains education, both unconditionally and conditional on predetermined covariates (age, parents’ education, family structure at 14).
- Uses a **boxplot of education by `nearc4`** to visually confirm that people living near a 4-year college tend to have more schooling.

The conclusion is that `nearc4` is a strong, relevant instrument in both the simple and the controlled first-stage specifications.

**Question 3 – Interpreting IV estimates and robust standard errors**

This question runs the core **IV regressions** using `nearc4` as the instrument, first without controls and then with controls. It interprets:

- The size of the estimated return to education (e.g. how much wages increase in % terms for an extra year of schooling).
- The change in the coefficient and its standard error when controls are added.
- The impact of using **robust (heteroskedasticity-consistent) standard errors** versus conventional ones.

The key takeaway is that the IV estimates suggest a substantial causal effect of education on wages, and using robust SEs does not materially change the inference.

It also compares these estimates with those from using `nearc2` as an alternative instrument and shows how weak first-stage strength for `nearc2` leads to unstable and unreliable IV results.

**Question 4 – Comparing IV to OLS and testing exogeneity**

The last question directly compares **OLS vs IV** estimates:

- OLS gives smaller returns to education, consistent with downward bias from endogeneity.
- IV gives larger returns, which is in line with the theoretical discussion that OLS is biased when education is endogenous.

The analysis then applies **Wu–Hausman exogeneity tests** to formally test whether education can be treated as exogenous. The test strongly rejects exogeneity, justifying the use of IV instead of OLS.

Finally, when both `nearc4` and `nearc2` are used as instruments in an overidentified model, a **Sargan–Hansen overidentification test** is used to check whether all instruments are jointly valid. The results indicate that at least one instrument (here, `nearc2`) is invalid, reinforcing the choice to rely on `nearc4` as the main instrument in the preferred specification.

For full derivations, regression tables, and narrative discussion, see the report:  
[iv_education_wages_report.pdf](report/iv_education_wages_report.pdf).

