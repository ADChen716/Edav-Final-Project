library(plotly)
library(tidyverse)

daily_df <- read.csv("/Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("//Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

global_daily_df <- daily_df[daily_df$Region=="global",]
global_daily_df$Date<-  as.Date(global_daily_df$Date)
# str(global_daily_df)


# Post Malone

singer_daily_df <- global_daily_df[which(global_daily_df$Artist=="Post Malone"),] %>%
  arrange(Date)%>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()
  
  
a <- list(text = "Movie 'Spider-Man' is on!",
  showarrow = TRUE,
  arrowhead = 1,
  x = as.Date("2018-12-14"),
  y = 4e6
)
b <- list(text = "3rd album is out!",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-09-06"),
          y = 7.3e6
)
plot_ly(singer_daily_df ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
  layout(title = "Popularity of Post Malone",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = list(a,b))



# Billie Eilish
singer_daily_df2 <- global_daily_df[which(global_daily_df$Artist=="Billie Eilish"),] %>%
  arrange(Date)%>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()

a <- list(text = "New album is out!",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-02-01"),
          y = 5.56e6
)
b <- list(text = "Another album is out!",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-03-29"),
          y = 7e6
)
c <- list(text = "A new concert at CA",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-07-11"),
          y = 6.25e6
)
plot_ly(singer_daily_df2 ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
  layout(title = "Popularity of Billie Eilish",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = list(a,b,c))



# Ed Sheeran
singer_daily_df3 <- global_daily_df[which(global_daily_df$Artist=="Ed Sheeran"),] %>%
  arrange(Date) %>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()

a <- list(text = "Collaboration with Justin Bieber \n after 'Love Yourself' 4 years ago",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-05-10"),
          y = 11e6
)
b <- list(text = "New album is out!",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-07-12"),
          y = 6.3e6
)

plot_ly(singer_daily_df3 ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
  layout(title = "Popularity of Ed Sheeran",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = list(a,b))

# XXXTENTACION
singer_daily_df4 <- global_daily_df[which(global_daily_df$Artist=="XXXTENTACION"),] %>%
  arrange(Date) %>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()

a <- list(text = "New album is out!",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2018-12-07"),
          y = 3.56e6
)

plot_ly(singer_daily_df4 ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
  layout(title = "Popularity of XXXTENTACION",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = a)




