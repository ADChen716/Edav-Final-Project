library(readr)
library(tidyverse)
library(plotly)

daily_df <- read.csv("data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")

global_daily_data <- subset(daily_df,  Region == "global")

days_of_singers <- global_daily_data %>% 
  group_by(Artist) %>% 
  distinct(Date) %>%
  summarise(Freq = n()) %>%
  arrange(-Freq) %>%
  subset(Freq > 100) %>%
  mutate(Artist = as.character(Artist))

plot_ly(days_of_singers, x = ~Freq, y = ~reorder(Artist,Freq), type = 'scatter',
        mode = "markers", marker = list(color = "blue")) %>%
  layout(
    title = "How long are these singers staying in Global Top 100?",
    xaxis = list(title = "Number of days in Global Top 100"),
    yaxis = list(title = "Artist")
  )

global_daily_data$Track <- sub("(\\(|-).*$", "", as.character(global_daily_data$Track.Name))
days_of_songs <- global_daily_data %>% 
  group_by(Track) %>% 
  distinct(Date) %>%
  summarise(Freq = n()) %>%
  arrange(-Freq) %>%
  subset(Freq > 100)
# View(days_of_songs)

plot_ly(days_of_songs, x = ~Freq, y = ~reorder(Track,Freq), type = 'scatter',
        mode = "markers", marker = list(color = "blue")) %>%
  layout(
    title = "How long are these songs staying in Global Top 100?",
    xaxis = list(title = "Number of days in Global Top 100"),
    yaxis = list(title = "Track")
  )
