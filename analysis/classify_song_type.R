library(plotly)
library(tidyverse)
library(lubridate)

daily_df <- read.csv("/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
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
global_top_daily_df <-  left_join(global_yearly_df[1:50,c("Track.Name","Artist","total_stream","yearly_rank")], global_daily_df, by=c("Track.Name","Artist"))



# draw from the date it on chart and pick weekly
global_top_daily_df2 <- global_top_daily_df%>%
  group_by(Track.Name)%>%
  mutate(days_on_chart = Date -min(Date))%>%
  mutate(Weekday = wday(Date,label = TRUE)) %>%
  ungroup()

global_top_weekly_df <- global_top_daily_df2 %>%
  filter(Weekday =="Fri")%>%
  group_by(Track.Name)%>%
  mutate(std_streams = 100*(Streams-min(Streams))/(max(Streams)-min(Streams)))%>%
  ungroup()

plot_ly(global_top_weekly_df, x = ~days_on_chart, y = ~std_streams, color = ~Track.Name, mode = "lines")

# without standardize
plot_ly(global_top_weekly_df, x = ~days_on_chart, y = ~Streams, color = ~Track.Name, mode = "lines")

# colored by type

get_type <- function(streams){
  if (streams[1]==max(streams)|streams[2]==max(streams)){return("popular at once")}
  else if(streams[3]==max(streams)|streams[4]==max(streams)|streams[5]==max(streams)|streams[6]==max(streams)|streams[7]==max(streams)|streams[8]==max(streams)|streams[9]==max(streams)){
    return("raise and be popular")}
  else if(streams[10]==max(streams)|streams[11]==max(streams)|streams[12]==max(streams)|streams[13]==max(streams)|streams[14]==max(streams)){
    return("wait until being popular")}
  else if(streams[15]==max(streams)|streams[16]==max(streams)|streams[17]==max(streams)|streams[18]==max(streams)|streams[19]==max(streams)|streams[20]==max(streams)|streams[21]==max(streams)|streams[22]==max(streams)){
    return("wait a long time")}
  else {return("others")}
}


global_top_weekly_df2 <- global_top_weekly_df %>%
  group_by(Track.Name)%>%
  mutate(type = get_type(std_streams))%>%
  ungroup()

global_top_weekly_df3 <-global_top_weekly_df2 %>%
  group_by(Track.Name) %>%
  summarise_all(funs(last)) %>%
  mutate(days_on_chart = NA) %>%
  bind_rows(global_top_weekly_df2, .) %>% 
  arrange(yearly_rank,days_on_chart)

plot_ly(global_top_weekly_df3, 
        x = ~ days_on_chart, 
        y = ~ std_streams, 
        color = ~ type, 
        text = ~Track.Name,
        type = "scatter",
        mode = "lines",
        hovertemplate = paste('<b>%{text}</b>'),
        connectgaps = FALSE)


# without standardize
plot_ly(global_top_weekly_df3, 
        x = ~ days_on_chart, 
        y = ~ Streams, 
        color = ~ type, 
        text = ~Track.Name,
        type = "scatter",
        mode = "lines",
        hovertemplate = paste('<b>%{text}</b>'),
        connectgaps = FALSE)



# draw graph for typical tracks

# for Shiny app: input:track
track <- "thank u, next"
p1 <- plot_ly(global_top_weekly_df3[which(global_top_weekly_df3$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "markers",name = ~"streams")
p2 <- plot_ly(global_top_weekly_df3[which(global_top_weekly_df3$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Fall down: thank u, next--Ariana Grande" )

# could delete
track <- "Sunflower - Spider-Man: Into the Spider-Verse"
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "markers",name = ~"streams")
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Go down, raise and fall: Sunflower - Spider-Man: Into the Spider-Verse--Post Malone" )

track <- "Wow."
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "markers",name = ~"streams")
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Raise and fall: Wow.--Post Malone" )


track <- "Dance Monkey"
p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "markers",name = ~"streams")
p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
  layout(yaxis = list(autorange = "reversed"))
subplot(p1,p2) %>%
  layout(title="Raising: Dance Monkey--Tones and I" )

