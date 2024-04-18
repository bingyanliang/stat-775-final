data {
    int<lower=0> N;
    vector[N] log_minchi2;
    vector[N] median_z;
    vector[N] z_sigma;
}
parameters {
    real beta_0;
    real beta_1;
    real beta_2;
    real<lower=0> sigma;
}
model {
    beta_0 ~ normal(0, 10);
    beta_1 ~ normal(0, 10);
    beta_2 ~ normal(0, 10);
    sigma ~ normal(0, 5);
    
    for (i in 1:N)
        median_z[i] ~ normal(beta_0 + beta_1 * log_minchi2[i] + beta_2 * z_sigma[i], sigma);
}
