data {
    int<lower=0> N; // total number of measurements
    int<lower=0> J; // total number of groups
    int<lower=0> m; // max value of group_id
//    vector[N] log_minchi2; // uncertainty in best fit template
    vector[N] z_sigma; // uncertainty in redshift, y
    vector[N] median_z; // measured redshift, x
    array[N] int<lower=0, upper=m> group_id; // assign group to an observation
    real<lower=0> a1;
    real<lower=0> b1;
    real<lower=0> a2;
    real<lower=0> b2; 
    real<lower = 0> nu; // prior shape for sigma^2
    real<lower = 0> lambda; // hyper-parameter for sigma^2
}
parameters {
    real alpha_bar; // global mean linear intercept
    real beta_bar; // global mean linear slope

    vector[m] alpha; // linear intercepts for each group
    vector[m] beta; // slope coefficients for each group

    real<lower=0> sigma2; // normal standard deviation for normal linear distribution
}
transformed parameters{
    real<lower = 0> sigma;
    sigma = sqrt(sigma2);
    vector[N] mu;
    for(i in 1:N){
        mu[i] = alpha[group_id[i]] + beta[group_id[i]] * median_z[i];
    }
}
model {
    sigma2 ~ inv_gamma(nu/2, nu * lambda/2);

    alpha_bar ~ normal(0, a2*sigma);
    beta_bar ~ normal(1, b2*sigma);

    alpha ~ normal(alpha_bar, a1*sigma);
    beta ~ normal(beta_bar, b1*sigma);

    z_sigma ~ normal(mu, sigma);
}