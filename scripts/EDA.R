# setwd("./Statistical-Analysis-of-Song-Characteristics-to-Enhance-Music")

# Requirements
# install.packages("tidyverse")
# install.packages("corrplot")
# install.packages("GGally")

# Load necessary libraries
library(tidyverse)
library(corrplot)
library(GGally)

# Create a directory for the results
dir.create("EDA-Results", showWarnings = FALSE)

# Load the dataset
music_data <- read.csv("data/songs_normalize.csv")

# Basic data exploration
head(music_data)
str(music_data)
summary(music_data)

# Check for missing values and duplicates
colSums(is.na(music_data))
sum(duplicated(music_data))

### Data Visualization 

# Histograms for numerical variables
numerical_cols <- music_data %>% select_if(is.numeric)

pdf("EDA-Results/histograms.pdf")
for(col_name in names(numerical_cols)) {
  p <- ggplot(numerical_cols, aes_string(x = col_name)) +
    geom_histogram(bins = 30, fill = "skyblue", color = "black") +
    ggtitle(paste("Distribution of", col_name))
  print(p)
}
dev.off()

# Bar plot for the top 10 genres
genre_plot <- ggplot(music_data, aes(x = fct_lump(fct_infreq(genre), n = 10))) +
  geom_bar(fill = "lightgreen", color = "black") +
  labs(title = "Top 10 Music Genres", x = "Genre", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("EDA-Results/genre_distribution.png", plot = genre_plot)

# Bar plot for explicit songs
explicit_plot <- ggplot(music_data, aes(x = as.factor(explicit))) +
  geom_bar(fill = "coral", color = "black") +
  labs(title = "Distribution of Explicit Songs", x = "Explicit", y = "Count")
ggsave("EDA-Results/explicit_distribution.png", plot = explicit_plot)

# Correlation matrix for numerical variables
correlation_matrix <- cor(numerical_cols)
png("EDA-Results/correlation_heatmap.png", width = 800, height = 800)
corrplot(correlation_matrix, method = "color", type = "upper", order = "hclust",
         addCoef.col = "black",
         tl.col = "black", tl.srt = 45,
         diag = FALSE)
dev.off()

# Box plot of danceability for the top 5 genres
top_genres <- music_data %>%
  count(genre, sort = TRUE) %>%
  top_n(5, n) %>%
  pull(genre)

boxplot_danceability_genre <- music_data %>%
  filter(genre %in% top_genres) %>%
  ggplot(aes(x = genre, y = danceability, fill = genre)) +
  geom_boxplot() +
  labs(title = "Danceability by Genre (Top 5)", x = "Genre", y = "Danceability") +
  theme(legend.position = "none")
ggsave("EDA-Results/boxplot_danceability_genre.png", plot = boxplot_danceability_genre)

# Scatter plot of energy vs. loudness
scatter_energy_loudness <- ggplot(music_data, aes(x = energy, y = loudness)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Energy vs. Loudness", x = "Energy", y = "Loudness")
ggsave("EDA-Results/scatter_energy_loudness.png", plot = scatter_energy_loudness)