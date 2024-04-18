library(rstan)
library(readr)


df <- read_csv("C:/Users/Bingyan/Desktop/STAT 775/stat-775-final/linear-regression-model/linear-data.csv")
View(df)

N = nrow(df)

log_minchi2 = df$minchi2
z_sigma = df$z_sigma
median_z = df$median_z

data_list <- list(
  N = N,
  log_minchi2 = log_minchi2,
  median_z = median_z,
  z_sigma = z_sigma
)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

fit <- stan(
  file = "C:/Users/Bingyan/Desktop/STAT 775/stat-775-final/bingyan-code/lin-reg-model.stan",
  data = data_list,
  iter = 1000,
  chains = 4
)


library(bayesplot)
mcmc_trace(fit, pars = c("beta_0", "beta_1", "beta_2", "sigma"))

print(fit)
print(summary(fit))

