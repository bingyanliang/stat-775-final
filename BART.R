rm(list = ls())

library(readr)
library(dbarts)

data <- read_csv("data_mags_5000.csv")

X <- as.matrix(data$mag_sersic_i)

feature <- "m20_i"

bart_models <- list()
predictions <- list()

set.seed(114)

y <- data[[feature]]

train_indices <- sample(1:length(y), size = 0.8*length(y))

X_train <- matrix(X[train_indices], ncol = 1)  # Ensure matrix format
y_train <- y[train_indices]

X_test <- matrix(X[-train_indices], ncol = 1)  # Ensure matrix format
y_test <- y[-train_indices]

bart_model <- bart(X_train, y_train, keeptrees = TRUE)
bart_models[[feature]] <- bart_model

pred <- predict(bart_model, newdata = X_test)
predictions[[feature]] <- list(Predicted = pred, Actual = y_test)

print(str(predictions))


mean_predictions <- apply(predictions[["m20_i"]][["Predicted"]], 1, mean)
predictions[["m20_i"]][["Predicted"]] <- mean_predictions


plot_data <- data.frame(
  Actual = predictions[["m20_i"]][["Actual"]],
  Predicted = predictions[["m20_i"]][["Predicted"]]
)

print(head(plot_data))


p <- ggplot(plot_data, aes(x = Actual, y = Predicted)) +
  geom_point(alpha = 0.5) +  # semi-transparent points
  geom_smooth(method = "lm", color = "blue", se = FALSE) +  # linear model fit line
  ggtitle("Actual vs Predicted for m20_i") +
  xlab("Actual Values") +
  ylab("Predicted Values") +
  theme_minimal()


print(p)

