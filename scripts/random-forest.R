# install.packages("tidyverse")
# install.packages("randomForest")

library(tidyverse)
library(randomForest)

music_data = read.csv("data/songs_normalize.csv") 

# Creating a new feature: the average popularity for each artist.
# This is a powerful predictor because famous artists tend to produce popular songs.
feature_data <- music_data %>%
  group_by(artist) %>%
  mutate(artist_popularity = mean(popularity, na.rm = TRUE)) %>%
  ungroup() %>%
  select(popularity, danceability, energy, valence, loudness, artist_popularity) %>%
  na.omit()


# Split Data into Training and Testing Sets 
set.seed(123) # for reproducibility
train_indices <- sample(1:nrow(feature_data), 0.8 * nrow(feature_data))
train_data <- feature_data[train_indices, ]
test_data <- feature_data[-train_indices, ]


# Model Training
## predict 'popularity' using all other variables.
rf_model <- randomForest(popularity ~ ., data = train_data, ntree = 100, importance = TRUE)
print("--- Random Forest Model ---")
print(rf_model)


# Predictions on unseen data (test data)
predictions <- predict(rf_model, test_data)

# Model Evaluation
# Root Mean Squared Error (RMSE).
rmse <- sqrt(mean((predictions - test_data$popularity)^2))
print(paste("Model Performance (RMSE):", round(rmse, 2)))

# Plotting the results
importance_data <- as.data.frame(importance(rf_model))
importance_data$variable <- rownames(importance_data)
importance_plot <- ggplot(importance_data, aes(x = reorder(variable, `%IncMSE`), y = `%IncMSE`)) +
  geom_col(fill = "skyblue") + 
  coord_flip() + 
  labs(title = "Feature Importance for Predicting Popularity",
       x = "Features",
       y = "Importance (% Increase in Mean Squared Error)") +
  theme_minimal()
ggsave("Results/Random-Forest-Results/feature_importance.png", plot = importance_plot)
print(importance_plot)