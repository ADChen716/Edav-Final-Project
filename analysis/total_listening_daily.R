library(plotly)
library(tidyverse)
library(lubridate)

daily_df <- read.csv("/Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("//Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

global_daily_df <- daily_df[daily_df$Region=="global",]
global_daily_df$Date<-  as.Date(global_daily_df$Date)

global_total_daily_df <- global_daily_df %>%
  group_by(Date) %>%
  summarize(total_listening = sum(Streams)) %>%
  ungroup()%>%
  arrange(Date)

plot_ly(global_total_daily_df ,x = ~Date, y = ~total_listening, mode = 'lines') %>%
  layout(title = "Daily total listening",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"))


# plotly
global_total_daily_df%>%
  mutate(Weekday = wday(Date,label = TRUE)) %>%
  group_by(Weekday) %>%
  do(p=plot_ly(., x = ~Date, y = ~total_listening, color = ~Weekday, mode = "lines"),) %>%
  subplot(nrows = 1, shareX = TRUE, shareY = TRUE)

# group_df <- global_total_daily_df%>%
#   mutate(Weekday = wday(Date,label = TRUE)) %>%
#   group_by(Weekday) %>%
#   mutate(ll = predict(loess(total_listening~Date,., span=0.1)))
#   
# group_df %>% p=plot_ly(., x = ~Date, y = ~total_listening, color = ~Weekday, mode = "lines")%>%
#        add_lines(., x= ~Date, y=predict(loess(total_listening~Date, span=0.1)), line=line.fmt, n)%>%
#   subplot(nrows = 1, shareX = TRUE, shareY = TRUE)


# ggplot
library(ggplot2)

ggplot(global_total_daily_df, aes(Date, total_listening)) +
  geom_line() +
  geom_smooth(method = "loess", se = FALSE, lwd = 1.5) +
  facet_grid(.~wday(Date, label = TRUE))








