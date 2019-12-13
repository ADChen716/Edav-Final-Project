library(genius)
library(readr)
library(tidyverse)

yearly_df <- read.csv("data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df, -"X")
track <- select(yearly_df, c("Track.Name", "Artist", "track_id")) %>%
  unique()
View(track)
unwanted_array = list(    'Š'='S', 'š'='s', 'Ž'='Z', 'ž'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A', 'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E',
                          'Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I', 'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O', 'Ù'='U',
                          'Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a', 'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c',
                          'è'='e', 'é'='e', 'ê'='e', 'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o', 'ô'='o', 'õ'='o',
                          'ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y', 'þ'='b', 'ÿ'='y' )

lyrics <- data.frame()
for (i in 1: nrow(track)){
  trackname <- track[i, 1]
  trackname <- sub("(\\(|-).*$", "", as.character(trackname))
  trackname <- chartr(paste(names(unwanted_array), collapse=''),
                      paste(unwanted_array, collapse=''),
                      trackname)
  trackname <- gsub("[^0-9A-Za-z///' ]", "'", trackname, ignore.case = TRUE)
  print(trackname)
  
  artist <- track[i, 2]
  artist <- sub("(\\(|-).*$", "", as.character(artist))
  artist <- chartr(paste(names(unwanted_array), collapse=''),
                   paste(unwanted_array, collapse=''),
                   artist)
  artist <- gsub("[^0-9A-Za-z///' ]", "'", artist, ignore.case = TRUE)
  print(artist)
  
  trackid <- track[i, 3]
  
  try(
    {
      lyric <- genius_lyrics(artist = artist, song = trackname, info = "title") %>%
        drop_na()
      
      clean_lyric <- data.frame(id=c(NA),lyric=c(NA))
      clean_lyric$lyric <- paste(lyric$lyric, collapse = ";")
      clean_lyric$id <- trackid
      
      lyrics <- rbind(lyrics, clean_lyric)
    }
  )
  Sys.sleep(0.2)
}

write.csv(lyrics, "data/clean/lyrics.csv")

