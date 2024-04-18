data {
    int<lower=0> N; // total number of measurements
    int<lower=0> J; // total number of groups
//    vector[N] log_minchi2; // uncertainty in best fit template
    vector[N] z_sigma; // uncertainty in redshift, y
    vector[N] median_z; // measured redshift, x
    int<lower=1, upper=J> group_id[N]; // assign group to an observation
    real<lower=0> a; // pooling parameter for intercept
    real<lower=0> b; // pooling parameter for slope
    real<lower = 0> nu; // prior shape for sigma^2
    real<lower = 0> lambda; // hyper-parameter for sigma^2
    int<lower=0> N_grid; // grid spacing
    vector[N_grid] x_grid; // x bins
}
parameters {
    real alpha_bar; // global mean linear intercept
    real beta_bar; // global mean linear slope
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

    alpha_bar ~ normal(0, sigma);
    beta_bar ~ normal(0, sigma);

    alpha ~ normal(alpha_bar, a*sigma);
    beta ~ normal(beta_bar, b*sigma);

    z_sigma ~ normal(alpha + beta * median_z, sigma);
}
