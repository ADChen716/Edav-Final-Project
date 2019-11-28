library(Rspotify)
keys <- spotifyOAuth("EDAV","2396242d1c2043ae90fa37810b334c56","e972f10fc0384e5683be1f603b869a55")

df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/raw/global.csv")
regions <- c("gb","us","ad","ar","at","au","be","bg","bo","br",
             "ca","ch","cl","co","cr","cy","cz","de","dk",
             "do","ec","ee","es","fi","fr","gr","gt","hk",
             "hn","hu","id","ie","il","in","is","it","jp",
             "lt","lu","lv","mc","mt","mx","my","ni","nl",
             "no","nz","pa","pe","ph","pl","pt","py","ro",
             "se","sg","sk","sv","th","tr","tw","uy","vn","za")
for(r in regions){
  df <- rbind(df, read.csv(paste("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/raw/",r,".csv", sep = "")))
}

clean_df <- subset(df, Position!="Position")

clean_df$track_id <- sub("https://open.spotify.com/track/", "", clean_df$URL)

track_id_unique = unique(clean_df$track_id)

artist_name_id <- data.frame()
features_df <- data.frame()
for(i in 1:length(track_id_unique)){
  track_id <- track_id_unique[i]
  Sys.sleep(0.2)
  if(track_id==""){
    artist_name_id <- rbind(artist_name_id, rep(c(""),2))
    features_df <- rbind(features_df, rep(c(""),16))
  }
  else{
    artist_name_id <- rbind(artist_name_id, getTrack(track_id, keys)[1,c("artists","artists_IDs")])
    features_df <- rbind(features_df, getFeatures(track_id, keys))
  }
  print(paste(i == nrow(features_df) & i == nrow(artist_name_id), i))
}

track_ID_dict <- cbind(track_id = track_id_unique, artist_name_id, features_df[,!names(features_df) %in% c("id","uri","analysis_url")])

merged_df <- merge(x = clean_df, y = track_ID_dict, by = "track_id", all.x = TRUE)
merged_df <- merged_df[,!names(merged_df) %in% c("URL")]

clean_final <- merged_df
clean_final[clean_final == ""] <- NA

write.csv(clean_final, "/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/daily_data.csv")


main_artist_id <- c()
for(i in 1134543:nrow(merged_df)){
  main_artist = as.character(merged_df[i,"Artist"])
  index = match(main_artist, unlist(strsplit(as.character(merged_df[i,"artists"]), split = ";")))
  if(is.na(index)){
    main_artist_id = c(main_artist_id,"")
  } else {
    main_artist_id = c(main_artist_id,unlist(strsplit(as.character(merged_df[i,"artists_IDs"]), split = ";"))[index])
  }
  print(paste(i == length(main_artist_id), i/nrow(merged_df)))
}
merged_df$Artist_ID <- main_artist_id


clean_final_full <- merged_df
clean_final_full[clean_final_full == ""] <- NA

write.csv(clean_final_full, "/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/daily_data_final.csv")




