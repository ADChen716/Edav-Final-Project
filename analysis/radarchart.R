library(readr)
library(tidyverse)
library(plotly)

yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")
global_yearly_data <- subset(yearly_df, Region == "global")

feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                 "instrumentalness", "liveness", "valence", "tempo")

fn <- function(x) (x-min(x)) * 100 / (max(x)-min(x))
std_global_yearly_data <- data.frame(lapply(global_yearly_data[, feature_name], fn))
std_global_yearly_data$Track <- global_yearly_data$Track.Name
std_global_yearly_data$Region <- global_yearly_data$Region
std_global_yearly_data$Artist <- global_yearly_data$Artist
View(std_global_yearly_data)


PM_tracks <- subset(std_global_yearly_data, Artist == "Post Malone")
plot_ly(
  type = 'scatterpolar',
  fill = 'toself',
  mode = "markers"
) %>%
  add_trace(
    r = c(unlist(matrix(PM_tracks[1,1:9])), PM_tracks[1,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = PM_tracks[1, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(PM_tracks[2, 1:9])), PM_tracks[2,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = PM_tracks[2, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(PM_tracks[3, 1:9])), PM_tracks[3,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = PM_tracks[3, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(PM_tracks[4, 1:9])), PM_tracks[4,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = PM_tracks[4, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(PM_tracks[5, 1:9])), PM_tracks[5,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = PM_tracks[5, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(PM_tracks[6, 1:9])), PM_tracks[6,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = PM_tracks[6, "Track"]
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,100)
      )
    )
  )

ES_tracks <- subset(std_global_yearly_data, Artist == "Ed Sheeran")
plot_ly(
  type = 'scatterpolar',
  fill = 'toself',
  mode = "markers"
) %>%
  add_trace(
    r = c(unlist(matrix(ES_tracks[1,1:9])), ES_tracks[1,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = ES_tracks[1, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(ES_tracks[2, 1:9])), ES_tracks[2,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = ES_tracks[2, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(ES_tracks[3, 1:9])), ES_tracks[3,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = ES_tracks[3, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(ES_tracks[4, 1:9])), ES_tracks[4,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = ES_tracks[4, "Track"]
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,100)
      )
    )
  )

BE_tracks <- subset(std_global_yearly_data, Artist == "Billie Eilish")
plot_ly(
  type = 'scatterpolar',
  fill = 'toself',
  mode = "markers"
) %>%
  add_trace(
    r = c(unlist(matrix(BE_tracks[1,1:9])), BE_tracks[1,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = BE_tracks[1, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(BE_tracks[2, 1:9])), BE_tracks[2,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = BE_tracks[2, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(BE_tracks[3, 1:9])), BE_tracks[3,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = BE_tracks[3, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(BE_tracks[4, 1:9])), BE_tracks[4,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = BE_tracks[4, "Track"]
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,100)
      )
    )
  )

XX_tracks <- subset(std_global_yearly_data, Artist == "XXXTENTACION")
plot_ly(
  type = 'scatterpolar',
  fill = 'toself',
  mode = "markers"
) %>%
  add_trace(
    r = c(unlist(matrix(XX_tracks[1,1:9])), XX_tracks[1,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = XX_tracks[1, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(XX_tracks[2, 1:9])), XX_tracks[2,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = XX_tracks[2, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(XX_tracks[3, 1:9])), XX_tracks[3,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = XX_tracks[3, "Track"]
  ) %>%
  add_trace(
    r = c(unlist(matrix(XX_tracks[4, 1:9])), XX_tracks[4,1]),
    theta = c(unlist(feature_name), feature_name[1]),
    name = XX_tracks[4, "Track"]
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,100)
      )
    )
  )

