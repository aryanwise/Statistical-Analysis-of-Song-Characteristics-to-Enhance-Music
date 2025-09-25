# install.packages("tidyverse")
# install.packages("moments")

library(tidyverse)
library(moments)

music_data = read.csv("data/songs_normalize.csv") 

# numerical columns from dataset
numerical_data <- music_data %>% select_if(is.numeric)

# summary table
desc_stats <- tibble(
  Variable = names(numerical_data),
  Mean = sapply(numerical_data, mean, na.rm = TRUE),
  Median = sapply(numerical_data, median, na.rm = TRUE),
  Std_Dev = sapply(numerical_data, sd, na.rm = TRUE),
  Variance = sapply(numerical_data, var, na.rm = TRUE),
  Min = sapply(numerical_data, min, na.rm = TRUE),
  Max = sapply(numerical_data, max, na.rm = TRUE),
  Range = Max - Min,
  Skewness = sapply(numerical_data, skewness, na.rm = TRUE),
  Kurtosis = sapply(numerical_data, kurtosis, na.rm = TRUE)
)

print("--- Detailed Descriptive Statistics for Numerical Variables ---")
print(desc_stats)

print("--- Top 15 Genre Frequencies ---")
genre_counts <- music_data %>%
  count(genre, sort = TRUE) %>%
  top_n(15)
print(genre_counts)

print("--- Explicit Song Frequencies ---")
explicit_counts <- music_data %>% count(explicit)
print(explicit_counts)

print("--- Song Key Frequencies ---")
key_counts <- music_data %>% count(key, sort = TRUE)
print(key_counts)


# average audio features for the top 10 most frequent genres.
top_10_genres <- music_data %>%
  count(genre, sort = TRUE) %>%
  top_n(10) %>%
  pull(genre)

grouped_stats <- music_data %>%
  filter(genre %in% top_10_genres) %>%
  group_by(genre) %>%
  summarise(
    Avg_Danceability = mean(danceability, na.rm = TRUE),
    Avg_Energy = mean(energy, na.rm = TRUE),
    Avg_Loudness = mean(loudness, na.rm = TRUE),
    Avg_Valence = mean(valence, na.rm = TRUE),
    Avg_Tempo = mean(tempo, na.rm = TRUE),
    Total_Songs = n()
  ) %>%
  arrange(desc(Total_Songs))

print("--- Average Audio Features by Top 10 Genres ---")
print(grouped_stats)

if(!dir.exists("descriptive-stats-results")){
  dir.create("descriptive-stats-results")
}

write.csv(desc_stats,
          "descriptive-stats-results/descriptive_statistics.csv",
          row.names = FALSE)

write.csv(genre_counts,
          "descriptive-stats-results/top15_genre_frequencies.csv",
          row.names = FALSE)

write.csv(explicit_counts,
          "descriptive-stats-results/explicit_song_frequencies.csv",
          row.names = FALSE)

write.csv(key_counts,
          "descriptive-stats-results/song_key_frequencies.csv",
          row.names = FALSE)

write.csv(grouped_stats,
          "descriptive-stats-results/avg_audio_features_top10_genres.csv",
          row.names = FALSE)
