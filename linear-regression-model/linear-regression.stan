data {
    int<lower=0> N; // number of measurements
    vector[N] log_minchi2; // uncertainty in best fit template
    vector[N] z_sigma; // uncertainty in redshift
    vector[N] median_z; // measured redshift
}
parameters {
    real beta_0; // linear intercept
    real beta_1; // coefficient for log_minchi2
    real beta_2; // coefficient for z_sigma
    real<lower=0> sigma; // normal standard deviation for normal linear distribution
}
model {
    beta_0 ~ normal(0, 10);
    beta_1 ~ normal(0, 10);
    beta_2 ~ normal(0, 10);
    sigma ~ normal(0, 5);

    median_z ~ normal(beta_0 + beta_1 * log_minchi2 + beta_2 * z_sigma, sigma);
}