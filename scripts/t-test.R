# Hypthesis: Is there a statistically significant difference in the mean danceability between explicit and non-explicit songs?

# install.packages("tidyverse")
# install.packages("car")
# install.packages("moments")


library(tidyverse)
library(car)
library(moments)

music_data = read.csv("data/songs_normalize.csv") 

# column from text to a logical type (TRUE/FALSE), and removing any missing values.
analysis_data <- music_data %>%
  mutate(explicit = as.logical(explicit)) %>%
  select(danceability, explicit) %>%
  na.omit()

# check skewness of the original 'danceability' data.
skewness_original <- skewness(analysis_data$danceability)
print(paste("Results/t-test-results/Original Skewness:", skewness_original))

# This plot shows the data is left-skewed (leaning to the right).
original_dist_plot <- ggplot(analysis_data, aes(x = danceability)) +
  geom_density(fill = "skyblue", alpha = 0.7) +
  labs(title = "Distribution of Original Danceability Scores",
       subtitle = paste("Skewness:", round(skewness_original, 2)),
       x = "Danceability", y = "Density") +
  theme_minimal()
ggsave("Results/t-test-results/original_distribution.png", plot = original_dist_plot)


# Box Cox Method to normalise the data
# This finds the best power transformation to make the data as normal as possible.
lambda <- powerTransform(analysis_data$danceability)

# Apply the transformation to create a new, normalized column.
analysis_data$danceability_transformed <- bcPower(analysis_data$danceability, lambda$lambda)

# Check the skewness of the new transformed data to confirm improvement.
skewness_transformed <- skewness(analysis_data$danceability_transformed)
print(paste("Transformed Skewness:", skewness_transformed))

# This plot shows a more symmetric, bell-shaped curve, indicating successful normalization.
transformed_dist_plot <- ggplot(analysis_data, aes(x = danceability_transformed)) +
  geom_density(fill = "lightgreen", alpha = 0.7) +
  labs(title = "Distribution of Transformed Danceability Scores",
       subtitle = paste("Skewness:", round(skewness_transformed, 2)),
       x = "Transformed Danceability", y = "Density") +
  theme_minimal()
ggsave("Results/t-test-results/transformed_distribution.png", plot = transformed_dist_plot)


# Welch Two Sample t-test to compare the means of the transformed groups.
final_t_test <- t.test(danceability_transformed ~ explicit, data = analysis_data)
print(final_t_test)
