library(readr)
library(tidyverse)
library(plotly)

yearly_data <- read_csv("data/clean/yearly_data.csv")
global_yearly_data <- subset(yearly_data, Region == "global")


# singers who have more than one songs on the ranking
singers <- global_yearly_data %>%
  group_by(Artist) %>%
  dplyr::summarise(Count = n())
top_singers <- subset(singers, Count > 1)

# draw a barchart to have an overview of top singers
plot_ly(top_singers, x=~reorder(Artist, -Count), y=~Count, type="bar") %>%
  layout(title = "Top singers",
         xaxis = list(title = "Artist"),
         yaxis = list(title = "Count of songs on the ranking"))

# standardize features that are continuous 
feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                 "instrumentalness", "liveness", "valence", "tempo")
standardized_feature <- data.frame(scale(global_yearly_data[, feature_name]))

# draw a boxplot to have an overview of the track features
features <- gather(standardized_feature, "feature", "value")
plot_ly(features, y = ~value, x = ~reorder(features$feature, -features$value, FUN = median), type = "box") %>%
  layout(xaxis = list(title = "Song Feature"),
         yaxis = list(title = "Standardized Value"),
         title = "Distribution of Features")

