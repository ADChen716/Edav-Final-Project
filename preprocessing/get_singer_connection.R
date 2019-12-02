library(tidyverse)
library(Rspotify)
keys <- spotifyOAuth("EDAV","2396242d1c2043ae90fa37810b334c56","e972f10fc0384e5683be1f603b869a55")

year_df <- read.csv("data/clean/yearly_data.csv") 
region = c("global","us","gb","ad","ar","at","au","be","bg","bo","br","ca","ch","cl","co","cr","cy","cz","de","dk","do","ec","ee","es","fi","fr","gr","gt","hk","hn","hu","id","ie","il","in","is","it","jp","lt","lu","lv","mc","mt","mx","my","ni","nl","no","nz","pa","pe","ph","pl","pt","py","ro","se","sg","sk","sv","th","tr","tw","uy","vn","za")
unwanted_array = list(    'Š'='S', 'š'='s', 'Ž'='Z', 'ž'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A', 'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E'
                          ,'Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I', 'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O', 'Ù'='U'
                          ,'Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a', 'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c'
                          ,'è'='e', 'é'='e', 'ê'='e', 'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o', 'ô'='o', 'õ'='o'
                          ,'ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y', 'þ'='b', 'ÿ'='y')
for (country in region){
  print(country)
  artist_list <- unique(as.vector(year_df[year_df$Region==country,]$Artist))
  artist_mat <- matrix(0, nrow = length(artist_list), ncol = length(artist_list),
                       dimnames = list(artist_list,
                                       artist_list))
  
  for (artist in artist_list){
    Sys.sleep(1)
    print(artist)
    artist_name = chartr(paste(names(unwanted_array), collapse=''),
           paste(unwanted_array, collapse=''),
           artist)
    artist_name <- gsub("[^0-9A-Za-z///' ]","'" , artist_name,ignore.case = TRUE)
    related <- getRelated(artist_name, keys)

    for (name in related$name){
      if (name %in% artist_list){
        artist_mat[artist, name] <-1
      }
    }
  }
  print(artist_mat)
  write.csv(artist_mat,paste("data/clean/singer_connection/",country ,".csv", sep = ""))
}


# 
# library(igraph)
# network <- graph_from_adjacency_matrix( artist_mat, weighted=T, mode="undirected", diag=F)
# plot(network)
