library(readr)
library(tidyverse)
library(plotly)

yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")
global_yearly_data <- subset(yearly_df, Region == "global")

feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                 "instrumentalness", "liveness", "valence", "tempo")
global_yearly_feature <- select(global_yearly_data, c(unlist(feature_name), "yearly_rank"))
View(global_yearly_feature)

m <- cor(global_yearly_feature)
plot_ly(x = c(unlist(feature_name), "yearly_rank"),
        y = c(unlist(feature_name), "yearly_rank"),
        z = m,
        zmin = -1,
        zmax = 1,
        type = "heatmap",
        colors = colorRamp(c("navyblue", "white", "pink")))
