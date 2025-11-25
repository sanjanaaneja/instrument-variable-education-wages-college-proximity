#setwd

library(stargazer)
library(ggplot2)
library(plyr)
library(AER)

#Loading R data to new environment 
env <- new.env()
load("education.RData", envir = env)
object <- mget(ls(env), envir = env)
df_list <- object[sapply(object, is.data.frame)]
dfeduc <- df_list[[1]]    

#Q1 
#selecting relevant columns 
dfeduc_rel <- dfeduc[, c("id", "nearc4", 
"nearc2", "age","educ","lwage", "wage",
"fatheduc", "motheduc", "IQ","married",
"momdad14", "sinmom14", "step14", "exper")]

# Stargazer summary table for selected variables
stargazer(dfeduc_rel, type = "latex", title = "Summary Statistics for relevant variables") 

#Q2
#First model: educ on IV (Baseline; no controls)
fs_min <- lm(
educ ~ nearc4,
data = dfeduc_rel)
#Partial F-test
anova(update(fs_min, . ~ . - nearc4), fs_min)

#Second model: Relevance + Controls (robustness)
fs_full <-
lm(educ ~ nearc4 + fatheduc + motheduc 
+ age + momdad14 + sinmom14 + 
step14, data = dfeduc_rel)
anova(update(fs_full, . ~ . - nearc4), fs_full)

#Boxplot years of school (educ) by instrument (nearc4)
ggplot(dfeduc_rel, aes(x = factor(nearc4, labels=c("Far from 4 yr","Near 4 yr")),
y = educ)) +
geom_boxplot() +
stat_summary(fun = mean, geom = "point", size = 2) +
labs(x = "Lives near 4-year college", y = "Years of schooling",
title = "Education by Proximity to a 4-year College")

#Q3
# Baseline IV regression
rsltA  <- ivreg(lwage ~ educ | nearc4, data = dfeduc_rel)
summary(rsltA, diagnostics = TRUE)  # prints weak-IV & endogeneity tests

#Adding controls to baseline IV regression

rsltB <- ivreg(
lwage ~ educ + age + fatheduc + motheduc + momdad14 + sinmom14 + step14 |
nearc4 + age + fatheduc + motheduc + momdad14 + sinmom14 + step14,
data = dfeduc_rel
)
summary(rsltB, diagnostics = TRUE)


#conventional SE
seA_conv <- sqrt(diag(vcov(rsltA)))
seB_conv <- sqrt(diag(vcov(rsltB)))
#Using robust SE instead
seA_rob <- sqrt(diag(vcovHC(rsltA, type = "HC1")))
seB_rob <- sqrt(diag(vcovHC(rsltB, type = "HC1")))

#stargazer: presenting results with robust SEs
stargazer(rsltA, rsltA, rsltB, rsltB,
type = "latex",
title = "IV regression analysis: Base and Control model (Conv vs Robust SEs)",
column.labels = c("A: Conv.", "A: Robust", "B: Conv.", "B: Robust"),
dep.var.labels = "Log hourly wage (lwage)",
se = list(seA_conv, seA_rob, seB_conv, seB_rob),
intercept.bottom = FALSE,
no.space = TRUE,
align = TRUE)

#nearc2 as instrument
# Replace instrument with nearc2 (just-identified)
rsltA2 <- ivreg(lwage ~ educ | nearc2, data = dfeduc_rel)
rsltB2 <- ivreg(
lwage ~ educ + age + fatheduc + motheduc + momdad14 + sinmom14 + step14 |
nearc2 + age + fatheduc + motheduc + momdad14 + sinmom14 + step14,
data = dfeduc_rel
)

summary(rsltA2, diagnostics = TRUE)
summary(rsltB2, diagnostics = TRUE)

# Robust SEs table comparing nearc4 vs nearc2 (IV only)
se_rsltA2 <- sqrt(diag(vcovHC(rsltA2, type = "HC1")))
se_rsltB2 <- sqrt(diag(vcovHC(rsltB2, type = "HC1")))

stargazer(rsltA, rsltA2, rsltB, rsltB2,
type = "latex",
title = "IV with nearc4 vs nearc2 (robust SEs)",
se = list(seA_rob, se_rsltA2, seB_rob, se_rsltB2),
column.labels = c("n4: no ctrls","n2: no ctrls","n4: ctrls","n2: ctrls"),
intercept.bottom = FALSE, no.space = TRUE, align = TRUE)

#Q4
# OLS base model (no controls) 
olsA <- lm(lwage ~ educ, data = dfeduc_rel)
summary(olsA)

# OLS controlled model
olsB <- lm(
lwage ~ educ + age + fatheduc + motheduc + momdad14 + sinmom14 + step14,
data = dfeduc_rel
)
summary(olsB)


stargazer(olsA, rsltA, olsB, rsltB,
type = "text",
title = "OLS vs IV using nearc4 and conventional SEs",
column.labels = c("OLS: no ctrls","IV: no ctrls","OLS: ctrls","IV: ctrls"),
intercept.bottom = FALSE, no.space = TRUE, align = TRUE)

#formal test to decide between OLS and IV 
summary(rsltA, diagnostics = TRUE)  
summary(rsltB, diagnostics = TRUE)  


#overidentifying as an issue if using both nearc4 + nearc 2
#over identifying controlled model
rsltB_overid <- ivreg(
lwage ~ educ + age + fatheduc + motheduc + momdad14 + sinmom14 + step14 |
nearc4 + nearc2 + age + fatheduc + motheduc + momdad14 + sinmom14 + step14,
data = dfeduc_rel
)
summary(rsltB_overid, diagnostics = TRUE) 

