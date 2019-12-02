library(tidyverse)
cleaned_df <- read.csv("data/clean/daily_data_final.csv")


year_rank_df <- cleaned_df %>%
  filter(!is.na(Track.Name)& ! is.na(Artist)) %>%
  group_by(Region, Track.Name, Artist) %>% 
  summarise(total_stream = sum(Streams)) %>%
  ungroup()



year_rank_df <- year_rank_df %>%
  group_by(Region) %>%
  arrange(desc(total_stream), .by_group = TRUE) %>%
  mutate(yearly_rank = 1:n())%>%
  slice(1:100) %>%
  ungroup()


year_cleaned_df<- cleaned_df %>%
  select(-c(X,Region,Date,Streams,Position))%>%
  unique() %>%
  group_by(Track.Name, Artist) %>%
  slice(1:1) %>%
  ungroup()
  
year_df <- left_join(year_rank_df, year_cleaned_df, by=c("Track.Name","Artist"))
# View(year_df[which(year_df$Region =="global"& year_df$Track.Name == "Wow."),])
write.csv(year_df,"data/clean/yearly_data.csv")
