# Hypothesis: "Is there a statistically significant relationship between a song's danceability and its popularity?"

# install.packages("tidyverse")
# install.packages("ggplot2")

library(tidyverse)
library(ggplot2)

music_data = read.csv("data/songs_normalize.csv") 

# Checking assumption 

### Assumption 1: Level of Measurement 
# We need to confirm that 'popularity' and 'danceability' are interval or ratio variables.

print("Data type for 'popularity':")
class(music_data$popularity)

print("Data type for 'danceability':")
class(music_data$danceability)

print("Summary of values for both variables:")
summary(music_data[, c("popularity", "danceability")])


### Assumption 2: Linear Relationship 

# Data Preparation 
correlation_data <- music_data %>%
  select(danceability, popularity) %>%
  na.omit()

# scatter plot to visualize the relationship
linearity_plot <- ggplot(correlation_data, aes(x = danceability, y = popularity)) +
  geom_point(alpha = 0.2, color = "purple") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Linearity Check: Popularity vs. Danceability",
       x = "Danceability",
       y = "Popularity") +
  theme_minimal()
ggsave("Results/Correlation-results/correlation_linearity_plot.png", plot = linearity_plot)
print(linearity_plot)



### Assumption 3: Normality
correlation_data <- music_data %>%
  select(danceability, popularity) %>%
  na.omit()

# histogram for the 'popularity' variable
popularity_hist <- ggplot(correlation_data, aes(x = popularity)) +
  geom_histogram(bins = 30, fill = "orange", color = "black") +
  labs(title = "Normality Check for Popularity") +
  theme_minimal()
ggsave("Results/Correlation-results/popularity_histogram.png", plot = popularity_hist)
print(popularity_hist)

# histogram for the 'danceability' variable
danceability_hist <- ggplot(correlation_data, aes(x = danceability)) +
  geom_histogram(bins = 30, fill = "lightblue", color = "black") +
  labs(title = "Normality Check for Danceability") +
  theme_minimal()
ggsave("Results/Correlation-results/danceability_histogram.png", plot = danceability_hist)
print(danceability_hist)


### Formal Test: Shapiro-Wilk
# The Shapiro-Wilk test has a limit of 5000 samples, so we test on a random sample of our data. 
# A p-value < 0.05 indicates the data is not normal.

print("--- Shapiro-Wilk Normality Test for Popularity ---")
shapiro.test(sample(correlation_data$popularity, min(5000, nrow(correlation_data))))

print("--- Shapiro-Wilk Normality Test for Danceability ---")
shapiro.test(sample(correlation_data$danceability, min(5000, nrow(correlation_data))))

# The normality is violated


### Pivoting to Spearman's Correlation 
correlation_data <- music_data %>%
  select(danceability, popularity) %>%
  na.omit()


# Assumption Check (Monotonic Relationship) .
monotonic_plot <- ggplot(correlation_data, aes(x = danceability, y = popularity)) +
  geom_point(alpha = 0.2, color = "blue") +
  labs(title = "Monotonic Relationship Check: Popularity vs. Danceability") +
  theme_minimal()
ggsave("Results/Correlation-results/spearman_monotonic_plot.png", plot = monotonic_plot)
print(monotonic_plot)

# Spearman Correlation Test 
spearman_test <- cor.test(correlation_data$danceability,
                          correlation_data$popularity,
                          method = "spearman")
print(spearman_test)