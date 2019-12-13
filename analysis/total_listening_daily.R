library(plotly)
library(tidyverse)
library(lubridate)

daily_df <- read.csv("data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

global_daily_df <- daily_df[daily_df$Region=="global",]
global_daily_df$Date<-  as.Date(global_daily_df$Date)

global_total_daily_df <- global_daily_df %>%
  group_by(Date) %>%
  summarize(total_listening = sum(Streams)) %>%
  ungroup()%>%
  arrange(Date)

line <- list(
  type = "line",
  line = list(color = '#ff7f0e'),
  xref = "x",
  yref = "y"
)
line[["x0"]] <- as.Date("2018-12-24")
line[["x1"]] <- as.Date("2018-12-24")
line[c("y0", "y1")] <- c(1.9e8,4e8)

a <- list(
  x = as.Date("2019-02-06"),
  y = 3.5e8,
  text = "Christmas Eve",
  xref = "x",
  yref = "y",
  showarrow = FALSE
)


plot_ly(global_total_daily_df ,x = ~Date, y = ~total_listening, mode = 'lines') %>%
  layout(title = "Daily total listening",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         shapes = line,
         annotations = a)

# ggplot
library(ggplot2)

ggplot(global_total_daily_df, aes(Date, total_listening/1000000)) +
  geom_line() +
  geom_smooth(method = "loess", se = FALSE, lwd = 1.5) +
  facet_grid(.~wday(Date, label = TRUE)) +
  xlab("Date") + ylab("Streams (million)") + theme(axis.text.x = element_text(angle = 45))








