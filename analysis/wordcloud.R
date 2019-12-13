library(stringi)
library(tm)
library(wordcloud2)
library(wordcloud)

stop_words <- read.csv("data/clean/stop_words.csv")
stop_words <- as.character(stop_words$stop_word)

lyrics_df <- read.csv("data/clean/lyrics.csv")



# number of pure English songs
length(which(stri_enc_isascii(lyrics_df$lyric))==T)

eng_id <- c()
eng_lyrics <- c()
for(i in 1:nrow(lyrics_df)){
  id <- as.character(lyrics_df[i,"id"])
  text <- as.character(lyrics_df[i,"lyric"])
  dat2 <- unlist(strsplit(text, split=" |;|,|\\?|\\."))
  dat3 <- grep("dat2", iconv(dat2, "latin1", "ASCII", sub="dat2"))
  if(length(dat3)>(length(dat2)/10)){
    # ignore this song, i.e. don't append
  }
  else if(length(dat3)>0){
    dat4 <- dat2[-dat3]
    result <- paste(dat4, collapse = " ")
    eng_id <- c(eng_id, id)
    eng_lyrics <- c(eng_lyrics, result)
  }
  else{
    eng_id <- c(eng_id, id)
    eng_lyrics <- c(eng_lyrics, text)
  }
}

# Songs which have >2/3 english words as lyrics
df <- data.frame(track_id = eng_id, text = eng_lyrics)

# Match this df with song features by track id
yearly_data <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/yearly_data.csv", 
                        header = T)[,c(2,7,10:20)]
yearly_data <- subset(yearly_data, Region=="us")[,c(2:13)]
rownames(yearly_data) <- NULL
merged_df <- unique(merge(x = df, y = yearly_data, by = "track_id", all.x = TRUE))
merged_df <- na.omit(merged_df)
colnames(merged_df)[1] <- "doc_id"

write.csv(merged_df,"/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/lyrics_eng_merged.csv")

nrow(merged_df)


# get the min and max value for each feature
for(f in colnames(merged_df)){
  if(f %in% c("danceability", "energy", "loudness", "speechiness", 
              "acousticness","instrumentalness", "liveness", "valence", "tempo")){
    print(paste(f,min(merged_df[,f]),max(merged_df[,f])))
  }
}

# Text Processing

lyrics_corpus = Corpus(DataframeSource(merged_df[,c("doc_id","text")]))

lyrics_corpus = tm_map(lyrics_corpus, content_transformer(tolower))
lyrics_corpus = tm_map(lyrics_corpus, removeNumbers)
lyrics_corpus = tm_map(lyrics_corpus, removePunctuation)
lyrics_corpus = tm_map(lyrics_corpus, removeWords, c(stop_words,
                                                     
                                                     c(stopwords("english"),stopwords("spanish"))))
lyrics_corpus =  tm_map(lyrics_corpus, stripWhitespace)

lyrics_dtm <- DocumentTermMatrix(lyrics_corpus)

lyrics_dtm = removeSparseTerms(lyrics_dtm, 0.95)

# inspect(lyrics_dtm[1,1:20])

# findFreqTerms(lyrics_dtm, lowfreq = 1000, highfreq = Inf)

get_freq_df <- data.frame(colSums(as.matrix(lyrics_dtm)))
freq = data.frame(name = rownames(get_freq_df),value = get_freq_df[,1])



##################
## Christmas
##################

lyrics_df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/lyrics_christmas.csv")[,c(2:3)]
colnames(lyrics_df) <- c("doc_id","text")
lyrics_df$text <- as.character(lyrics_df$text)


# Text Processing

lyrics_corpus = Corpus(DataframeSource(lyrics_df))

lyrics_corpus = tm_map(lyrics_corpus, content_transformer(tolower))
lyrics_corpus = tm_map(lyrics_corpus, removeNumbers)
lyrics_corpus = tm_map(lyrics_corpus, removePunctuation)
lyrics_corpus = tm_map(lyrics_corpus, removeWords, c(stop_words,
                                                     
                                                     c(stopwords("english"),stopwords("spanish"))))
lyrics_corpus =  tm_map(lyrics_corpus, stripWhitespace)

lyrics_dtm <- DocumentTermMatrix(lyrics_corpus)

lyrics_dtm = removeSparseTerms(lyrics_dtm, 0.95)

get_freq_df <- data.frame(colSums(as.matrix(lyrics_dtm)))
freq = data.frame(name = rownames(get_freq_df),value = get_freq_df[,1])

wordcloud(words=freq$name, freq=freq$value,scale=c(4,0.5),
              min.freq = 1, max.words=60,
              colors=brewer.pal(8, "Dark2"),rot.per=0)


halloween <- read.csv("../data/clean/halloween.csv")
christmas <- read.csv("../data/clean/christmas.csv")
romance <- read.csv("../data/clean/romance.csv")
hiphop <- read.csv("../data/clean/hiphop.csv")

wordcloud2(data=christmas,color = "random-dark",size=0.6)
wordcloud2(data=halloween,color = "random-dark",size=0.8)
wordcloud2(data=romance,color = "random-dark",size=1)
wordcloud2(data=hiphop,color = "random-dark",size=0.9)


