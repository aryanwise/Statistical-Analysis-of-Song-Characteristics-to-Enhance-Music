# Statistical Analysis of Song Popularity
~ By Aryan Mishra

## Project Overview

This project conducts a comprehensive statistical analysis of the "Spotify Popular Songs from 1999-2020" dataset to identify the key drivers of song popularity and genre characteristics. The primary goal is to provide a music streaming service with data-driven insights to improve its song recommendation engine. The analysis progresses from exploratory data analysis to inferential testing and predictive modeling.

---
## Key Business Questions

1.  What are the defining audio features (e.g., energy, danceability) of different music genres?
2.  Is there a statistically significant relationship between a song's sonic qualities and its commercial popularity?
3.  Can a predictive model be built to forecast a song's popularity?

---
## Methodology

The analysis was conducted in R and followed a structured workflow:

1.  **Data Cleaning & Preparation:** Ensured data quality and prepared variables for analysis (e.g., converting data types, grouping infrequent categories).
2.  **Exploratory Data Analysis (EDA):** Visualized distributions and relationships to understand the dataset's core characteristics.
3.  **Inferential Statistics:** Performed a series of hypothesis tests, including the T-Test, Kruskal-Wallis Test, Spearman Correlation, and Chi-Squared Test. For each, assumptions were rigorously checked, and non-parametric alternatives were used when necessary.
4.  **Predictive Modelling:**
    * Attempted to predict `popularity` using simple and multiple linear regression, which proved ineffective.
    * Successfully built a **Random Forest** model after engineering a new `artist_popularity` feature.

---
## Key Findings

* **Artist fame is the primary driver of song popularity.** An engineered `artist_popularity` feature was, by far, the most important predictor in a successful Random Forest model that explained 44.3% of the variance in popularity.
* **Audio features do not predict popularity.** Simple sonic qualities like `danceability` and `energy` have no significant correlation with a song's commercial success.
* **Genre is a strong proxy for a song's mood.** There are statistically significant differences in the `energy` levels between genres, validating the use of genre for creating mood-based playlists.

---
## Repository Structure

* `/EDA-Results/`: Contains all plots and visuals from the initial Exploratory Data Analysis.
* `/Results/`: Contains the plots generated during hypothesis testing and predictive modeling.
* `/data/`: Contains the raw `songs_normalize.csv` dataset.
* `/descriptive-stats-results/`: Contains the summary findings from the descriptive analysis in CSV format.
* `/scripts/`: Contains all R scripts used for the analysis.
* `Final_Report.pdf`: The complete, detailed report of the project, including all methodologies, interpretations, and business recommendations.

-----

## How to Use This Repository

To replicate this analysis, follow these steps:

1.  **Clone the repository** to your local machine using Git:
    ```bash
    git clone "https://github.com/aryanwise/Statistical-Analysis-of-Song-Characteristics-to-Enhance-Music.git"
    ```
2.  **Set the Working Directory in R:**
    Open your R or RStudio environment. Before running any scripts, set your working directory to the root of the cloned folder. Use the `setwd()` command with the path to the folder:
    ```r
    # Example:
    setwd("./Statistical-Analysis-of-Song-Characteristics-to-Enhance-Music")
    ```
3.  **Run the Scripts:**
    You can now run the scripts located in the `/scripts/` folder. Ensure you have installed the necessary packages listed at the top of each script.
