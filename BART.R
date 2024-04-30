rm(list = ls())

library(readr)
library(dbarts)



data <- read_csv("data_mags_5000.csv")

X <- as.matrix(data$mag_sersic_i)

features <- c("concentration_i", "asymmetry_i") 
###"clumpiness_i", "gini_i", "m20_i")##

bart_models <- list()
predictions <- list()

set.seed(114)

for (feature in features) {
  # Set the response variable
  y <- data[[feature]]
  
  # Split the data into training and test sets (80% training, 20% test)
  train_indices <- sample(1:length(y), size = 0.8*length(y))
  
  # Training data
  X_train <- matrix(X[train_indices], ncol = 1)  # Ensure matrix format
  y_train <- y[train_indices]
  
  # Testing data
  X_test <- matrix(X[-train_indices], ncol = 1)  # Ensure matrix format
  y_test <- y[-train_indices]
  
  # Fit the BART model
  bart_model <- bart(X_train, y_train, keeptrees = TRUE)
  bart_models[[feature]] <- bart_model
  
  # Predict on the test set
  pred <- predict(bart_model, newdata = X_test)
  predictions[[feature]] <- list(Predicted = pred, Actual = y_test)
}

library(ggplot2)

for (feature in names(predictions)) {
  plot_data <- data.frame(Actual = predictions[[feature]]$Actual,
                          Predicted = predictions[[feature]]$Predicted)
  
  ggplot(plot_data, aes(x = Actual, y = Predicted)) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm", color = "blue", se = FALSE) +
    ggtitle(paste("Actual vs Predicted for", feature)) +
    xlab("Actual Values") +
    ylab("Predicted Values") +
    theme_minimal()
}


