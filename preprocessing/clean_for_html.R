library(tidyverse)
library(readr)

df <- read.csv("data/raw/global.csv")
df <- df %>%
  select(Track.Name, Artist,Streams, Date)%>%
  filter(Streams!="Streams")
colnames(df) <- c("name","type","value","date")

write.csv(df, "data/clean_for_html/global.csv",row.names = FALSE)