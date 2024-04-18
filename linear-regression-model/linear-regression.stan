data {
    int<lower=0> N; // number of measurements
    vector[N] z_sigma; // uncertainty in redshift, y
    vector[N] median_z; // measured redshift, x
    real<lower = 0> nu; // prior shape for sigma^2
    real<lower = 0> lambda; // hyper-parameter for sigma
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
    z_sigma ~ normal(alpha + beta * median_z, sigma);
}
