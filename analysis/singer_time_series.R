library(plotly)
library(tidyverse)

daily_df <- read.csv("data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")


global_yearly_df <- yearly_df[yearly_df$Region=="global",]


global_daily_data <- daily_df[daily_df$Region=="global",]
global_daily_data$Date<-  as.Date(global_daily_data$Date)

add_line_breaks <- function(a,n){
  a <-  str_wrap(a, width = n, indent = 0, exdent = 0)
  a <- c(paste(a, "\n"))
  return(a)
}

# Post Malone
singer_daily_df <- global_daily_data[which(global_daily_data$Artist=="Post Malone"),] %>%
  arrange(Date)%>%
  filter(Track.Name %in% c("rockstar (feat. 21 Savage)","Sunflower - Spider-Man: Into the Spider-Verse", "Wow.","Better Now","Goodbyes (Feat. Young Thug)","Circles")) %>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()
singer_daily_df$Track.Name <- add_line_breaks(singer_daily_df$Track.Name, 20)


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
plot_ly(singer_daily_df ,x = ~Date, y = ~ Streams, color = ~Track.Name, type = "scatter", mode = 'lines') %>%
  layout(title = "Popularity of Post Malone's songs",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = list(a,b))



# Billie Eilish
singer_daily_df2 <- global_daily_data[which(global_daily_data$Artist=="Billie Eilish"),] %>%
  arrange(Date)%>%
  filter(Track.Name %in% c("bad guy","when the party's over","bury a friend","wish you were gay") )%>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()
singer_daily_df2$Track.Name <- add_line_breaks(singer_daily_df2$Track.Name, 20)
a <- list(text = "New single is out!",
          showarrow = TRUE,
          arrowhead = 1,
          x = as.Date("2019-02-01"),
          y = 5.56e6
)
b <- list(text = "New album is out!",
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
plot_ly(singer_daily_df2 ,x = ~Date, y = ~ Streams, color = ~Track.Name, type = "scatter", mode = 'lines') %>%
  layout(title = "Popularity of Billie Eilish's songs",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = list(a,b,c))



# Ed Sheeran
singer_daily_df3 <- global_daily_data[which(global_daily_data$Artist=="Ed Sheeran"),] %>%
  filter(Track.Name %in% c("I Don't Care (with Justin Bieber)", "Beautiful People (feat. Khalid)","Shape of You","Perfect"))%>%
  arrange(Date) %>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()
singer_daily_df3$Track.Name <- add_line_breaks(singer_daily_df3$Track.Name, 20)
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

plot_ly(singer_daily_df3 ,x = ~Date, y = ~ Streams, color = ~Track.Name, type = "scatter", mode = 'lines') %>%
  layout(title = "Popularity of Ed Sheeran's songs",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"),
         annotations = list(a,b))

# XXXTENTACION
singer_daily_df4 <- global_daily_data[which(global_daily_data$Artist=="XXXTENTACION"),] %>%
  filter(Track.Name %in% c("SAD!", "Moonlight","Jocelyn Flores","Arms Around You (feat. Maluma & Swae Lee)"))%>%
  arrange(Date) %>%
  group_by(Track.Name) %>%
  complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
  ungroup()
singer_daily_df4$Track.Name <- add_line_breaks(singer_daily_df4$Track.Name, 20)            

plot_ly(singer_daily_df4 ,x = ~Date, y = ~ Streams, color = ~Track.Name, type = "scatter", mode = 'lines') %>%
  layout(title = "Popularity of XXXTENTACION's songs",
         xaxis = list(title = "Date"),
         yaxis = list (title = "Streams"))