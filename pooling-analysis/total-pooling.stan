data {
    int<lower=0> N; // number of measurements
    vector[N] y_data;
    vector[N] x_data;
    real<lower = 0> lambda; // hyper-parameter for sigma
    real<lower = 0> nu; // prior shape for sigma^2
}
parameters {
    real alpha; // linear intercept
    real beta; // slope coefficient
    real<lower=0> sigma2; // normal standard deviation for normal linear distribution
}
transformed parameters{
  real<lower = 0> sigma;
  sigma = sqrt(sigma2);
}
model {
    sigma2 ~ inv_gamma(nu/2, nu * lambda/2);
    alpha ~ normal(0, sigma);
    beta ~ normal(0, sigma);
    y_data ~ normal(alpha + beta * x_data, sigma);
}