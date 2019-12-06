library(plotly)
library(tidyverse)

daily_df <- read.csv("/Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("//Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

global_daily_df <- daily_df[daily_df$Region=="global",]
global_daily_df$Date<-  as.Date(global_daily_df$Date)

daily_average_feature <- global_daily_df %>%
  group_by(Date) %>%
  summarise(danceability = mean(danceability),
            energy = mean(energy),
            loudness = mean(loudness),
            speechiness = mean(speechiness),
            acousticness = mean(acousticness),
            instrumentalness = mean(instrumentalness),
            liveness = mean(liveness),
            valence = mean(valence),
            tempo = mean(tempo)
            #duration_ms = mean(duration_ms)
            ) %>%
  ungroup()

# weighted version: weight is the stream, the results are similar
# daily_average_feature <- global_daily_df %>%
#   group_by(Date) %>%
#   summarise(danceability = mean(danceability*Streams)/sum(Streams),
#             energy = mean(energy*Streams)/sum(Streams),
#             loudness = mean(loudness*Streams)/sum(Streams),
#             speechiness = mean(speechiness*Streams)/sum(Streams),
#             acousticness = mean(acousticness*Streams)/sum(Streams),
#             instrumentalness = mean(instrumentalness*Streams)/sum(Streams),
#             liveness = mean(liveness*Streams)/sum(Streams),
#             valence = mean(valence*Streams)/sum(Streams),
#             tempo = mean(tempo*Streams)/sum(Streams)
#             #duration_ms = mean(duration_ms)
#   ) %>%
#   ungroup()

daily_average_feature <- daily_average_feature %>%
  gather(key = "feature", value = value, -Date) %>%
  group_by(feature) %>%
  mutate(rescaled_value = 100* value/value[1])



plot_ly(daily_average_feature, x = ~Date, y = ~ rescaled_value, color = ~feature, mode = 'lines') %>%
  layout(title = "Trend of tastes",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Feature Value"))



  