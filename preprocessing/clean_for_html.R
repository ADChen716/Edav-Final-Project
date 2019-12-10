df <- read.csv("/Users/ruibai/Documents/study/STAT5702EDAV/final pj/Edav-Final-Project/data/raw/global.csv")
df <- df %>%
  select(Track.Name, Artist,Streams, Date)%>%
  filter(Streams!="Streams")
colnames(df) <- c("name","type","value","date")

write.csv(df,"/Users/ruibai/Documents/study/STAT5702EDAV/final pj/data/clean_for_html/global.csv",row.names = FALSE)