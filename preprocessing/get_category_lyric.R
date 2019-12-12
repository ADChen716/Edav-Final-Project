library(tidyverse)
library(spotifyr)
library(genius)

Sys.setenv(SPOTIFY_CLIENT_ID = '2396242d1c2043ae90fa37810b334c56')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e972f10fc0384e5683be1f603b869a55')


playlist_id <- get_category_playlists("jazz", country = NULL, limit = 20,offset = 0, authorization = get_spotify_access_token(),include_meta_info = FALSE)[3,4]


df <- get_playlist_tracks(playlist_id, fields = NULL, limit = 100,
                          offset = 0, market = NULL,
                          authorization = get_spotify_access_token(),
                          include_meta_info = FALSE)

track <- select(df, c("track.name", "track.artists", "track.id"))
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
  
  artist <- track[i, 2][[1]][1,3]
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

write.csv(lyrics, "data/clean/lyrics_jazz.csv")
