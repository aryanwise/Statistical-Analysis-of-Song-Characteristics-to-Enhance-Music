# Hypothesis: Is there a statistically significant difference in the median energy of songs across different genres?

# install.packages("tidyverse")
# install.packages("dunn.test")

library(tidyverse)
library(dunn.test) 

music_data = read.csv("data/songs_normalize.csv")

# We will test if song energy differs across genres. To ensure a robust
# comparison, we first identify the top 5 most common genres in the dataset.
top_5_genres <- music_data %>%
  count(genre, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(genre)

# new dataframe containing only the data for these top 5 genres.
analysis_data <- music_data %>%
  filter(genre %in% top_5_genres) %>%
  select(energy, genre)


### Why the ANOVA Test Failed 
# The standard test for comparing means across multiple groups is the ANOVA.
# However, ANOVA requires that the data for each group be normally distributed.
# A Shapiro-Wilk test was performed on each genre's energy data. The results
# showed p-values less than 0.05, indicating a violation of the normality
# assumption. Data transformations were attempted but did not fully resolve the
# issue. Using ANOVA here would be statistically invalid.


#### Switching to a Non-Parametric Alternative 
# Because the normality assumption was violated, we must use a non-parametric test.
# The Kruskal-Wallis test is the correct alternative to ANOVA in this case.
# It compares the medians of the groups and does not assume normal distribution.
kruskal_test_result <- kruskal.test(energy ~ genre, data = analysis_data)
print("--- Kruskal-Wallis Test Results ---")
print(kruskal_test_result)


### Post-Hoc Analysis to Pinpoint Differences

# The Kruskal-Wallis test confirmed a significant difference exists somewhere among the groups. 
# To find out which specific genres differ from each other,
# we use Dunn's test as a post-hoc analysis.
dunn_test_result <- dunn.test(analysis_data$energy, analysis_data$genre, method="bonferroni")
print("--- Dunn's Post-Hoc Test Results ---")
print(dunn_test_result)

# Boxplot to compare the distribution of energy across genres.
energy_boxplot <- ggplot(analysis_data, aes(x = genre, y = energy, fill = genre)) +
  geom_boxplot() +
  labs(title = "Comparison of Song Energy Across Genres",
       subtitle = "Based on the Kruskal-Wallis Test",
       x = "Genre",
       y = "Energy") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none")                        
ggsave("Results/Kruskal-Wallis-test/genre_energy_boxplot.png", plot = energy_boxplot, width = 8, height = 6)
print(energy_boxplot)