library(tidyverse)
library(extracat)

daily_df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

colnames(daily_df) <- c("Track ID","Position","Track Name", "Artist", "Streams", "Date",
                        "Region", "Artists",
                        "Artists IDs", "Danceability", "Energy", "Key", "Loudness",
                        "Mode", "Speechiness", "Acousticness", "Instrumentalness", "Liveness",
                        "Valence", "Tempo",
                        "Duration_ms", "Time Signature", "Artist ID")

# Daily missing pattern
visna(daily_df, sort = "b")

# Yearly missing pattern
visna(yearly_df, sort = "b")

