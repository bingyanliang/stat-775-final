data {
    int<lower=0> N; // Number of measurements
    vector[N] m20_i; // Predictor
    vector[N] mag_sersic_i; // Dependent variable
}
parameters {
    real alpha; // Intercept
    real beta; // Slope
    real<lower=0> sigma; // Noise standard deviation
}
model {
    alpha ~ normal(0, 10);
    beta ~ normal(0, 10);
    sigma ~ normal(0, 10);
    
    mag_sersic_i ~ normal(alpha + beta * m20_i, sigma);
}