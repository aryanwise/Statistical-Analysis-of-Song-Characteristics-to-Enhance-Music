# install.packages("tidyverse")
# install.packages("car")
# install.packages("lmtest")

library(tidyverse)
library(car)
library(lmtest)

music_data = read.csv("data/songs_normalize.csv") 

regression_data <- music_data %>%
  select(danceability, popularity) %>%
  na.omit()

# First simple linear model 
initial_model <- lm(popularity ~ danceability, data = regression_data)

# Assumptions for the Initial Model
# For a linear regression model to be valid, its residuals must meet four key assumptions.

# Assumption 1: Linearity.
linearity_plot <- ggplot(regression_data, aes(x = danceability, y = popularity)) +
  geom_point(alpha = 0.2, color = "blue") +
  geom_smooth(method = "lm", color = "red", se = FALSE)
ggsave("Results/linear-regression-results/1_linearity_plot.png", plot = linearity_plot)
print(linearity_plot) 

# Assumption 2: Independence of Residuals.
durbinWatsonTest(initial_model)

# Assumption 3: Homoscedasticity (Constant Variance). 
bptest(initial_model) 

# Assumption 4: Normality of Residuals. 
shapiro.test(sample(residuals(initial_model), min(5000, length(residuals(initial_model)))))


# Fixing the Violated Assumption 
# Applying Box-Cox transformation to the dependent variable ('popularity').
lambda <- powerTransform(regression_data$popularity + 1)
regression_data$popularity_transformed <- bcPower(regression_data$popularity + 1, lambda$lambda)

# Build a new model using the transformed variable.
transformed_model <- lm(popularity_transformed ~ danceability, data = regression_data)


# We now check if the transformation fixed the normality issue for the new model's residuals.
shapiro.test(sample(residuals(transformed_model), min(5000, length(residuals(transformed_model)))))

# Q-Q Plot.
new_qq_plot <- ggplot(data.frame(residuals = residuals(transformed_model)), aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line(color = "red")
ggsave("Results/linear-regression-results/2_transformed_residuals_qq_plot.png", plot = new_qq_plot)
print(new_qq_plot)

# The Shapiro-Wilk test on the transformed model's residuals still returned a p-value < 0.05.
# The transformation FAILED to make the residuals normal.

# DECISION: We will proceed with the INITIAL model. Because our dataset is large,
# the Central Limit Theorem makes the regression model robust to the violation of the
# normality assumption. The model's results are still considered reliable.

print("--- Final Model Summary (Initial Model) ---")
summary(initial_model)
