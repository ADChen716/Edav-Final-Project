library(plotly)
library(tidyverse)
library(lubridate)

daily_df <- readr::read_csv("/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/data/clean/daily_data_final.csv")
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("//Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

global_daily_df <- daily_df[which(daily_df$Region=="global"),]
global_daily_df$Date<-  as.Date(global_daily_df$Date)
global_daily_df <-global_daily_df %>%
  arrange(Date)%>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()

global_yearly_df <- yearly_df[which(yearly_df$Region == "global"),]%>%
  arrange(yearly_rank)
# https://plot.ly/r/parallel-coordinates-plot/


# top 50
global_top_daily_df <- left_join(global_yearly_df[1:50,c("Track.Name","Artist","total_stream","yearly_rank")], global_daily_df, by=c("Track.Name","Artist"))


# draw graph for typical tracks


track <- "thank u, next"
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "lines",name = ~"streams")
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Falling: thank u, next--Ariana Grande" )



track <- "Wow."
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "lines",name = ~"streams")
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Up and down: Wow.--Post Malone" )


track <- "Dance Monkey"
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "lines",name = ~"streams")
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Rising: Dance Monkey--Tones and I" )

