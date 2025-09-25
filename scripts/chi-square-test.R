# Hypothesis: "Is there a statistically significant association between a song's genre and whether it is explicit?"

# install.packages("tidyverse")

library(tidyverse)


music_data = read.csv("data/songs_normalize.csv") 


# Assumption 1: Both variables are categorical.
# Genre: This variable consists of text labels (e.g., "pop", "rock"). It is a categorical variable.
# Explicit: This variable has two distinct levels (True or False). This is also a categorical variable.
# So, both the variables are categorical -> Met

# Assumption 2: All observations are independent.
# The characteristics of one song—like its genre or whether it's explicit—do not influence the characteristics of another song. 
# They are all independent entries. Therefore, the assumption is satisfied.

# Assumption 3: Cells in the contingency table are mutually exclusive.
# A song has one specific genre.
# A song is either explicit or not explicit.
# Assumption is met

# Assumption 4: Expected value of cells should be 5 or greater in at least 80% of cells.
# Select the two categorical variables.
chi_square_data <- music_data %>%
  mutate(explicit = as.logical(explicit)) %>%
  select(genre, explicit) %>%
  na.omit()

# Grouping Infrequent Genres to Meet Assumption 4
chi_square_data_cleaned <- chi_square_data %>%
  mutate(genre_grouped = fct_lump(genre, n = 6))

# Running the test 
contingency_table <- table(chi_square_data_cleaned$genre_grouped, chi_square_data_cleaned$explicit)
print("--- Contingency Table (Observed Counts) ---")
print(contingency_table)

chi_square_test <- chisq.test(contingency_table)
print("--- Chi-Squared Test Results ---")
print(chi_square_test)



























