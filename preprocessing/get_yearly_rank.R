library(tidyverse)
cleaned_df <- read.csv("data/raw/global_sample.csv")

cleaned_df <- select(cleaned_df,-c(X, URL,uri,analysis_url))
                     
year_rank_df <- cleaned_df %>% 
  group_by(Region, track_id) %>% 
  summarise(total_stream = sum(Streams)) %>%
  arrange(desc(total_stream), .by_group = TRUE) %>%
  ungroup()
  
year_rank_df <- year_rank_df %>%
  group_by(Region) %>% 
  rowid_to_column("yearly_rank")%>%
  slice(1:100) %>%
  ungroup()

year_df <- merge(x=select(year_rank_df,-Region), y=cleaned_df, by.x="track_id", by.y="track_id")

write.csv(year_df,"data/clean/yearly.csv")
