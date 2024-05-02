library(rstan)       
library(readr)       
library(ggplot2)     
library(bayesplot)   
library(dplyr)       


df <- read_csv("linear-regression-model/linear-data.csv")
print(head(df))


N <- nrow(df)
log_minchi2 <- df$minchi2
z_sigma <- df$z_sigma
median_z <- df$median_z

data_list <- list(
  N = N,
  log_minchi2 = log_minchi2,
  median_z = median_z,
  z_sigma = z_sigma
)


rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


fit <- stan(
  file = "lin-reg-model.stan", 
  data = data_list,
  iter = 1000,
  chains = 2
)

mcmc_trace(fit, pars = c("beta_0", "beta_1", "beta_2", "sigma"))

print(fit)
print(summary(fit))


posterior_samples <- extract(fit, pars = "sigma")$sigma

view(posterior_samples)

print(dim(posterior_samples))

df$posterior_sigma_mean <- apply(posterior_samples, 2, mean) # Correct axis if needed

df$posterior_sigma_mean <- rowMeans(posterior_samples)  # This collapses across all columns (iterations*chains)

ggplot(df, aes(x = median_z, y = posterior_sigma_mean)) +
  geom_point() +
  labs(title = "Scatter Plot of median_z vs. Posterior Mean of sigma",
       x = "Median of z",
       y = "Posterior Mean of sigma") +
  theme_minimal()

