library(plotly)
library(tidyverse)

daily_df <- read.csv("data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

global_daily_df <- daily_df[daily_df$Region=="global",]
global_daily_df$Date<-  as.Date(global_daily_df$Date)

daily_average_feature <- global_daily_df %>%
  group_by(Date) %>%
  dplyr::summarise(danceability = mean(danceability),
                   energy = mean(energy),
                   loudness = mean(loudness),
                   speechiness = mean(speechiness),
                   acousticness = mean(acousticness),
                   liveness = mean(liveness),
                   valence = mean(valence),
                   tempo = mean(tempo)
                   #duration_ms = mean(duration_ms)
  ) %>%
  ungroup()

daily_average_feature <- daily_average_feature %>%
  gather(key = "feature", value = value, -Date) %>%
  group_by(feature) %>%
  dplyr::mutate(rescaled_value = 100* value/value[1])

plot_ly(daily_average_feature, x = ~Date, y = ~ rescaled_value, color = ~feature, type = "scatter", mode = 'lines') %>%
  layout(title = "Average feature values as time goes by",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Feature Value"))


  