library(plotly)
library(tidyverse)
library(lubridate)

daily_df <- readr::read_csv("data/clean/daily_data_final.csv")
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
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

# top 50
global_top_daily_df <- left_join(global_yearly_df[1:50,c("Track.Name","Artist","total_stream","yearly_rank")], global_daily_df, by=c("Track.Name","Artist"))

track <- "thank u, next"
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, color = I('#1f77b4'), type = "scatter", mode = "lines",name = ~"streams")%>%
  layout(yaxis = list(title = "Streams"),
         xaxis = list(title = "Date"))
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, color = I('#1f77b4'), type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed",title = "Rank"),
         xaxis = list(title = "Date"))
subplot(style(p1, showlegend = FALSE),style(p2, showlegend = FALSE), titleX=T, titleY = T, margin = 0.06) %>%
  layout(title="Falling: Thank U, Next--Ariana Grande")

track <- "Wow."
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, color = I('#1f77b4'),type = "scatter", mode = "lines",name = ~"streams")%>%
  layout(yaxis = list(title = "Streams"),
         xaxis = list(title = "Date"))
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, color = I('#1f77b4'),type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed",title = "Rank"),
         xaxis = list(title = "Date"))
subplot(style(p1, showlegend = FALSE),style(p2, showlegend = FALSE), titleX=T, titleY = T, margin = 0.06) %>%
  layout(title="Rising before Falling: Wow.--Post Malone")

track <- "Dance Monkey"
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, color = I('#1f77b4'),type = "scatter", mode = "lines",name = ~"streams")%>%
  layout(yaxis = list(title = "Streams"),
         xaxis = list(title = "Date"))
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, color = I('#1f77b4'),type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed",title = "Rank"),
         xaxis = list(title = "Date"))
subplot(style(p1, showlegend = FALSE),style(p2, showlegend = FALSE), titleX=T, titleY = T, margin = 0.06) %>%
  layout(title="Rising: Dance Monkey--Tones and I" )

