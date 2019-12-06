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
View(days_of_singers)


plot_ly(days_of_singers, x = ~Freq, y = ~reorder(Artist,Freq), type = 'scatter',
        mode = "markers", marker = list(color = "blue")) %>%
  layout(
    title = "How long are the singers staying in Global Top 100?",
    xaxis = list(title = "Number of days in Global Top 100"),
    yaxis = list(title = "Artist")
  )