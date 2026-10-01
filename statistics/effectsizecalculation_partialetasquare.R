# Effect sizes for LMM for Condition*Group and Trial History*Group
# Script to reproduce all effect sizes reported in the supplementary material tables

# set working directory 
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))
options(warn = -1)

# Library
library(effectsize)
library(MBESS)
options(es.use_symbols = TRUE)

# effect sizes for LMM (Condition x Group)
# All F statistics and df from JASP
# APA onset
F_to_eta2(
  f = c(105.8, 16.24, 7),
  df = c(1, 1, 1),
  df_error = c(46.5, 47, 46.5)
)

F_values <- c(105.8, 16.24, 7)   
df1 <- c(1, 1, 1)         
df2 <- c(46.5, 47, 46.5)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# Max APA
F_to_eta2(
  f = c(94.0, 16.1, 9.6),
  df = c(1, 1, 1),
  df_error = c(46.5, 47, 46.5)
)

F_values <- c(94.0, 16.1, 9.6)  
df1 <- c(1, 1, 1)         
df2 <- c(46.5, 47, 46.5)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})


# Lift off
F_to_eta2(
  f = c(66.3, 6.9, 6.9),
  df = c(1, 1, 1),
  df_error = c(47, 47, 47)
)

F_values <- c(66.3, 6.9, 6.9)  
df1 <- c(1, 1, 1)         
df2 <- c(47, 47, 47)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# Touchdown
F_to_eta2(
  f = c(20.8, 8.4, 6.2),
  df = c(1, 1, 1),
  df_error = c(47, 47, 47)
)

F_values <- c(20.8, 8.4, 6.2) 
df1 <- c(1, 1, 1)         
df2 <- c(47, 47, 47)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# Movement time
F_to_eta2(
  f = c(10.8, 4.83, 1.4),
  df = c(1, 1, 1),
  df_error = c(47, 47, 47)
)

F_values <- c(10.8, 4.83, 1.4) 
df1 <- c(1, 1, 1)         
df2 <- c(47, 47, 47)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# effect sizes for LMM (Condition x Group)
# All F statistics and df from JASP
# Stepping force at max APA
F_to_eta2(
  f = c(11.1, 1.4, 10.8),
  df = c(1, 1, 1),
  df_error = c(47.9, 46.9, 47.9)
)

F_values <- c(11.1, 1.4, 10.8) 
df1 <- c(1, 1, 1)         
df2 <- c(47.9, 46.9, 47.9)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# effect sizes for LMM (Trial History x Group)
# All F statistics and df from JASP
# APA onset
F_to_eta2(
  f = c(101.7, 19.1, 7.7),
  df = c(1, 1, 1),
  df_error = c(43.4, 47, 43.4)
)

F_values <- c(101.7, 19.1, 7.7)   
df1 <- c(1, 1, 1)         
df2 <- c(43.4, 47, 43.4)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# Max APA
F_to_eta2(
  f = c(121.9, 18.8, 11.8),
  df = c(1, 1, 1),
  df_error = c(44, 47, 44)
)

F_values <- c(121.9, 18.8, 11.8)  
df1 <- c(1, 1, 1)         
df2 <- c(44, 47, 44)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# Lift-off
F_to_eta2(
  f = c(101.9, 8.1, 8.9),
  df = c(1, 1, 1),
  df_error = c(46, 47, 46)
)

F_values <- c(101.9, 8.1, 8.9) 
df1 <- c(1, 1, 1)         
df2 <- c(46, 47, 46)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})

# Touchdown
F_to_eta2(
  f = c(54.7, 9.8, 6.6),
  df = c(1, 1, 1),
  df_error = c(45.1, 47.1, 45.1)
)

F_values <- c(54.7, 9.8, 6.6) 
df1 <- c(1, 1, 1)         
df2 <- c(45.1, 47.1, 45.1)


eta2_vf_CI <- sapply(1:length(F_values), function(i) {
  ci <- conf.limits.ncf(F.value = F_values[i], df.1 = df1[i], df.2 = df2[i], conf.level = 0.90)
  lower <- ci$Lower.Limit / (ci$Lower.Limit + df2[i] + df1[i] + 1)
  upper <- ci$Upper.Limit / (ci$Upper.Limit + df2[i] + df1[i] + 1)
  c(lower, upper)
})
