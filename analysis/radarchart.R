library(readr)

daily_df <- read.csv("data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")
global_yearly_data <- subset(yearly_df, Region == "global")
View(global_yearly_data)



feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                 "instrumentalness", "liveness", "valence", "tempo", "duration_ms")
fn <- function(x) x * 100/max(x, na.rm = TRUE)
PM_tracks <- subset(global_yearly_data, Artist == "Post Malone")
mean_PM_features <- data.frame(lapply(PM_tracks[, feature_name], fn))

# AG_tracks <- subset(global_yearly_data, Artist == "Ariana Grande") 
# mean_AG_features <- data.frame(scale(AG_tracks[, feature_name]))
View(mean_PM_features)
# View(mean_AG_features)




p <- plot_ly(
  type = 'scatterpolar',
  r = c(39, 28, 8, 7, 28, 39),
  theta = c('A','B','C', 'D', 'E', 'A'),
  fill = 'toself'
) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0,50)
      )
    ),
    showlegend = F
  )