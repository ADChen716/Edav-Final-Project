library(tidyverse)

daily_df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
daily_df <- select(daily_df,-"X")
yearly_df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

# Daily missing pattern
visna(daily_df, sort = "b")

# Yearly missing pattern
visna(yearly_df, sort = "b")

yearly_df[which(is.na(yearly_df$Artist_ID)),]
daily_df[which(daily_df$track_id=="47rbjDud83d3aqvbcTssei"),]