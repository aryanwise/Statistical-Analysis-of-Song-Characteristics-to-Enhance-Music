# install.packages("tidyverse")
# install.packages("car")
# install.packages("lmtest")

library(tidyverse)
library(car)
library(lmtest)

music_data = read.csv("data/songs_normalize.csv") 

# Select our dependent (popularity) and independent variables.
multi_reg_data <- music_data %>%
  select(popularity, danceability, energy, valence, loudness) %>%
  na.omit()

# Build model
multi_model <- lm(popularity ~ danceability + energy + valence + loudness,
                  data = multi_reg_data)


# Assumption Check

# Assumption 1: Linear Relationship (for each predictor)
# scatter plot for each predictor variable against the response variable.
plot_danceability <- ggplot(multi_reg_data, aes(x = danceability, y = popularity)) + geom_point(alpha = 0.2) + geom_smooth(method="lm", se=FALSE)
plot_energy <- ggplot(multi_reg_data, aes(x = energy, y = popularity)) + geom_point(alpha = 0.2) + geom_smooth(method="lm", se=FALSE)
plot_valence <- ggplot(multi_reg_data, aes(x = valence, y = popularity)) + geom_point(alpha = 0.2) + geom_smooth(method="lm", se=FALSE)
plot_loudness <- ggplot(multi_reg_data, aes(x = loudness, y = popularity)) + geom_point(alpha = 0.2) + geom_smooth(method="lm", se=FALSE)

ggsave("Results/multi-reg-results/1a_linearity_danceability.png", plot = plot_danceability)
ggsave("Results/multi-reg-results/1b_linearity_energy.png", plot = plot_energy)
ggsave("Results/multi-reg-results/1c_linearity_valence.png", plot = plot_valence)
ggsave("Results/multi-reg-results/1d_linearity_loudness.png", plot = plot_loudness)
print(plot_danceability)


# Assumption 2: No Multicollinearity
# We check this using Variance Inflation Factor (VIF)
print("--- VIF Scores (Multicollinearity Check) ---")
print(vif(multi_model))


# Assumption 3: Independence of Observations
# We check this using the Durbin-Watson test
print("--- Durbin-Watson Test (Independence Check) ---")
print(durbinWatsonTest(multi_model))


# Assumption 4: Homoscedasticity (Constant Variance of Residuals)
# We check this visually with a residuals vs. fitted plot and formally with a Breusch-Pagan test.
residuals_vs_fitted_plot <- ggplot(data.frame(fitted = fitted(multi_model), residuals = residuals(multi_model)),
                                   aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Homoscedasticity Check: Residuals vs. Fitted Values")

ggsave("Results/multi-reg-results/4_homoscedasticity_plot.png", plot = residuals_vs_fitted_plot)
print(residuals_vs_fitted_plot)

print("--- Breusch-Pagan Test (Homoscedasticity Check) ---")
print(bptest(multi_model))


# Assumption 5: Multivariate Normality (of Residuals)
# We check this visually with a Q-Q plot and formally with a Shapiro-Wilk test.
qq_plot_multi <- ggplot(data.frame(residuals = residuals(multi_model)), aes(sample = residuals)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  labs(title = "Normality of Residuals Check: Q-Q Plot")

ggsave("Results/multi-reg-results/5_residuals_qq_plot.png", plot = qq_plot_multi)
print(qq_plot_multi)

print("--- Shapiro-Wilk Test (Normality of Residuals Check) ---")
print(shapiro.test(sample(residuals(multi_model), min(5000, length(residuals(multi_model))))))


# After checking all assumptions, we can now interpret the model's summary.
print("--- Multiple Regression Model Summary ---")
print(summary(multi_model))



