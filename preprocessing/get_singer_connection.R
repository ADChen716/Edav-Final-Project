library(tidyverse)
library(spotifyr)
library(readr)

Sys.setenv(SPOTIFY_CLIENT_ID = '2396242d1c2043ae90fa37810b334c56')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e972f10fc0384e5683be1f603b869a55')
access_token <- get_spotify_access_token(client_id = Sys.getenv('SPOTIFY_CLIENT_ID'), client_secret = Sys.getenv('SPOTIFY_CLIENT_SECRET'))

year_df <- read.csv("data/clean/yearly_data.csv") 
region = c("global","us","gb","ad","ar","at","au","be","bg","bo","br","ca","ch","cl","co","cr","cy","cz","de","dk","do","ec","ee","es","fi","fr","gr","gt","hk","hn","hu","id","ie","il","in","is","it","jp","lt","lu","lv","mc","mt","mx","my","ni","nl","no","nz","pa","pe","ph","pl","pt","py","ro","se","sg","sk","sv","th","tr","tw","uy","vn","za")
for (country in region){
  print(country)
  artist_list <- unique(as.vector(year_df[year_df$Region==country,]$Artist))
  artist_id <- unique(as.vector(year_df[year_df$Region==country,]$Artist_ID))
  artist_mat <- matrix(0, nrow = length(artist_list), ncol = length(artist_list),
                       dimnames = list(artist_list,
                                       artist_list))
  if (length(artist_list)!=0){
  for (i in 1:length(artist_list)){
    Sys.sleep(0.3)
    artist <- artist_list[i]
    print(artist)
    related <- get_related_artists(artist_id[i],authorization = access_token,include_meta_info = FALSE)
    
    for (name in related$name){
      if (name %in% artist_list){
        artist_mat[artist, name] <-1
      }
    }
  }
  }
  write.csv(artist_mat,paste("data/clean/singer_connection/",country ,".csv", sep = ""))
}