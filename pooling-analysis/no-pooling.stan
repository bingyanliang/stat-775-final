data {
    int<lower=0> N; // number of measurements
    int<lower=0> J; // total number of groups
    int<lower=0> m; // max value of group_id
    vector[N] y_data;
    vector[N] x_data;
    array[N] int<lower=0, upper=m> group_id; // assign group to an observation
    real<lower = 0> lambda; // hyper-parameter for sigma
    real<lower = 0> nu; // prior shape for sigma^2
}
parameters {
    vector[m] alpha; // linear intercepts for each group
    vector[m] beta; // slope coefficients for each group
    real<lower=0> sigma2; // standard deviation for normal linear distribution for each group
    //array[m] real<lower=0> sigma2;
}
transformed parameters{
  //array[N] real<lower=0> sigma;
  real<lower = 0> sigma;
  sigma = sqrt(sigma2);
  vector[N] mu;
  for(i in 1:N){
    mu[i] = alpha[group_id[i]] + beta[group_id[i]] * x_data[i];
  }
}
model {
    sigma2 ~ inv_gamma(nu/2, nu * lambda/2);
    alpha ~ normal(0, sigma);
    beta ~ normal(0, sigma);
    y_data ~ normal(mu, sigma);
}