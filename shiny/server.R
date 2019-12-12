shinyServer(function(input, output, session) {
    
    # read data
    daily_data <- read.csv("www/daily_data_final.csv", header = T)
    daily_data <- select(daily_data,-"X")
    
    global_daily_data <- daily_data[daily_data$Region=="global",]
    global_daily_data$Date<-  as.Date(global_daily_data$Date)
    
    yearly_data <- read.csv("www/yearly_data.csv", header = T)
    yearly_data$Track.Name <- add_line_breaks(yearly_data$Track.Name, 20)
    global_yearly_data <- subset(yearly_data, Region == "global")
    
    lyrics_df <- read.csv("www/lyrics_eng_merged.csv")
    
    artist_df <- read.csv("www/global.csv")
    
    global_top_daily_df <- read.csv("www/global_top_daily_df.csv")
    
    output$top_singer <- renderPlotly({
        # singers who have more than one songs on the ranking
        singers <- global_yearly_data %>%
            group_by(Artist) %>%
            dplyr::summarise(Count = n())
        top_singers <- subset(singers, Count > input$song_lowbound)

        # draw a barchart to have an overview of top singers
        plot_ly(top_singers, x=~reorder(Artist, -Count), y=~Count, type="bar") %>%
            layout(xaxis = list(title = "Artist"),
                   yaxis = list(title = "Count of songs on TOP100"))
    })
    
    output$selected_song_lowbound <- renderText({ 
        paste("Artists with more than",input$song_lowbound,"songs on Global Top 100 from Nov.01 2018 to Oct.31 2019")
    })
    
    output$feature_boxplot <- renderPlotly({
        feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                         "instrumentalness", "liveness", "valence", "tempo")
        standardized_feature <- data.frame(scale(global_yearly_data[, feature_name]))
        
        features <- gather(standardized_feature, "feature", "value")
        plot_ly(features, y = ~value, x = ~reorder(features$feature, -features$value, FUN = median), type = "box") %>%
            layout(xaxis = list(title = "Song Feature"),
                   yaxis = list(title = "Standardized Value"))
    })
    
    output$choropleth_1 <- renderPlotly({
        yearly_map_df <- subset(yearly_data, Region!="global")
        yearly_map_df$country_code <- countrycode(toupper(yearly_map_df$Region),origin = 'iso2c',destination = 'iso3c')
        
        g <- list(
            showframe = FALSE,
            showcoastlines = FALSE,
            projection = list(type = 'Mercator')
        )
        
        plot_df <- aggregate(yearly_map_df[, c("danceability","energy","loudness","speechiness",
                                               "acousticness","instrumentalness","liveness" ,
                                               "valence","tempo")], 
                             list(yearly_map_df$country_code), mean)
        plot_df$country_name <- countrycode(plot_df$Group.1,origin = 'iso3c',destination = 'country.name')
        
        l <- list(color = toRGB("grey"), width = 0.5)
        plot_geo(plot_df) %>%
            add_trace(
                z = plot_df[,c(input$choropleth_feature_1)], color = plot_df[,c(input$choropleth_feature_1)], colors = 'Blues',
                text = ~country_name, locations = ~Group.1, marker = list(line = l)
            ) %>%
            colorbar(title = '', tickprefix = '') %>%
            layout(
                autosize = T,
                title = 'Average song features by country',
                geo = g,
                margin = list(l=2)
            )
    })
    
    output$singer_radar <- renderPlotly({
        
        singer_name = input$singer_radar_input
        
        feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                         "instrumentalness", "liveness", "valence", "tempo")
        
        fn <- function(x) (x-min(x)) * 100 / (max(x)-min(x))
        std_global_yearly_data <- data.frame(lapply(global_yearly_data[, feature_name], fn))
        std_global_yearly_data$Track <- global_yearly_data$Track.Name
        std_global_yearly_data$Region <- global_yearly_data$Region
        std_global_yearly_data$Artist <- global_yearly_data$Artist
        
        if(singer_name == "Post Malone"){
            PM_tracks <- subset(std_global_yearly_data, Artist == "Post Malone")
            plot_ly(
                type = 'scatterpolar',
                fill = 'toself',
                mode = "markers"
            ) %>%
                add_trace(
                    r = c(unlist(matrix(PM_tracks[1,1:9])), PM_tracks[1,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = PM_tracks[1, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(PM_tracks[2, 1:9])), PM_tracks[2,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = PM_tracks[2, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(PM_tracks[3, 1:9])), PM_tracks[3,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = PM_tracks[3, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(PM_tracks[4, 1:9])), PM_tracks[4,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = PM_tracks[4, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(PM_tracks[5, 1:9])), PM_tracks[5,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = PM_tracks[5, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(PM_tracks[6, 1:9])), PM_tracks[6,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = PM_tracks[6, "Track"]
                ) %>%
                layout(
                    polar = list(
                        radialaxis = list(
                            visible = T,
                            range = c(0,100)
                        )
                    ),
                    legend = list(x = 100, y = 0.9)
                )
        }
        else if(singer_name == "Ed Sheeran"){
            ES_tracks <- subset(std_global_yearly_data, Artist == "Ed Sheeran")
            plot_ly(
                type = 'scatterpolar',
                fill = 'toself',
                mode = "markers"
            ) %>%
                add_trace(
                    r = c(unlist(matrix(ES_tracks[1,1:9])), ES_tracks[1,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = ES_tracks[1, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(ES_tracks[2, 1:9])), ES_tracks[2,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = ES_tracks[2, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(ES_tracks[3, 1:9])), ES_tracks[3,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = ES_tracks[3, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(ES_tracks[4, 1:9])), ES_tracks[4,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = ES_tracks[4, "Track"]
                ) %>%
                layout(
                    polar = list(
                        radialaxis = list(
                            visible = T,
                            range = c(0,100)
                        )
                    ),
                    legend = list(x = 100, y = 0.9)
                )
        }
        else if(singer_name == "Billie Eilish"){
            BE_tracks <- subset(std_global_yearly_data, Artist == "Billie Eilish")
            plot_ly(
                type = 'scatterpolar',
                fill = 'toself',
                mode = "markers"
            ) %>%
                add_trace(
                    r = c(unlist(matrix(BE_tracks[1,1:9])), BE_tracks[1,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = BE_tracks[1, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(BE_tracks[2, 1:9])), BE_tracks[2,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = BE_tracks[2, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(BE_tracks[3, 1:9])), BE_tracks[3,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = BE_tracks[3, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(BE_tracks[4, 1:9])), BE_tracks[4,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = BE_tracks[4, "Track"]
                ) %>%
                layout(
                    polar = list(
                        radialaxis = list(
                            visible = T,
                            range = c(0,100)
                        )
                    ),
                    legend = list(x = 100, y = 0.9)
                )
        }
        else{
            XX_tracks <- subset(std_global_yearly_data, Artist == "XXXTENTACION")
            plot_ly(
                type = 'scatterpolar',
                fill = 'toself',
                mode = "markers"
            ) %>%
                add_trace(
                    r = c(unlist(matrix(XX_tracks[1,1:9])), XX_tracks[1,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = XX_tracks[1, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(XX_tracks[2, 1:9])), XX_tracks[2,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = XX_tracks[2, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(XX_tracks[3, 1:9])), XX_tracks[3,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = XX_tracks[3, "Track"]
                ) %>%
                add_trace(
                    r = c(unlist(matrix(XX_tracks[4, 1:9])), XX_tracks[4,1]),
                    theta = c(unlist(feature_name), feature_name[1]),
                    name = XX_tracks[4, "Track"]
                ) %>%
                layout(
                    polar = list(
                        radialaxis = list(
                            visible = T,
                            range = c(0,100)
                        )
                    ),
                    legend = list(x = 100, y = 0.9)
                )
        }
    })
    
    output$singer_cleveland <- renderPlotly({
        
        days_of_singers <- global_daily_data %>% 
            group_by(Artist) %>% 
            distinct(Date) %>%
            dplyr::summarise(Freq = n()) %>%
            arrange(-Freq) %>%
            subset(Freq > 100) %>%
            mutate(Artist = as.character(Artist))
        
        plot_ly(days_of_singers, x = ~Freq, y = ~reorder(Artist,Freq), type = 'scatter',
                mode = "markers", marker = list(color = "blue")) %>%
            layout(
                xaxis = list(title = "Number of days in Global Top 100"),
                yaxis = list(title = "Singer")
            )
    })
    
    output$song_cleveland <- renderPlotly({
        global_daily_data$Track <- sub("(\\(|-).*$", "", as.character(global_daily_data$Track.Name))
        days_of_songs <- global_daily_data %>% 
            group_by(Track) %>% 
            distinct(Date) %>%
            dplyr::summarise(Freq = n()) %>%
            arrange(-Freq) %>%
            subset(Freq > 100)
        
        plot_ly(days_of_songs, x = ~Freq, y = ~reorder(Track,Freq), type = 'scatter',
                mode = "markers", marker = list(color = "blue")) %>%
            layout(
                xaxis = list(title = "Number of days in Global Top 100"),
                yaxis = list(title = "Track")
            )
    })
    
    output$singer_ts <- renderPlotly({
        singer_name = input$singer_ts_input
        
        if(singer_name == "Post Malone"){
            singer_daily_df <- global_daily_data[which(global_daily_data$Artist=="Post Malone"),] %>%
                arrange(Date)%>%
                group_by(Track.Name) %>%
                complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
                ungroup()
            
            
            a <- list(text = "Movie 'Spider-Man' is on!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2018-12-14"),
                      y = 4e6
            )
            b <- list(text = "3rd album is out!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-09-06"),
                      y = 7.3e6
            )
            plot_ly(singer_daily_df ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
                layout(title = "Popularity of Post Malone",
                       xaxis = list(title = "Date"),
                       yaxis = list (title = "Streams"),
                       annotations = list(a,b))
        }
        else if(singer_name == "Billie Eilish"){
            singer_daily_df2 <- global_daily_data[which(global_daily_data$Artist=="Billie Eilish"),] %>%
                arrange(Date)%>%
                group_by(Track.Name) %>%
                complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
                ungroup()
            
            a <- list(text = "New single is out!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-02-01"),
                      y = 5.56e6
            )
            b <- list(text = "New album is out!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-03-29"),
                      y = 7e6
            )
            c <- list(text = "A new concert at CA",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-07-11"),
                      y = 6.25e6
            )
            plot_ly(singer_daily_df2 ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
                layout(title = "Popularity of Billie Eilish",
                       xaxis = list(title = "Date"),
                       yaxis = list (title = "Streams"),
                       annotations = list(a,b,c))
        }
        else if(singer_name=="Ed Sheeran"){
            singer_daily_df3 <- global_daily_data[which(global_daily_data$Artist=="Ed Sheeran"),] %>%
                arrange(Date) %>%
                group_by(Track.Name) %>%
                complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
                ungroup()
            
            a <- list(text = "Collaboration with Justin Bieber \n after 'Love Yourself' 4 years ago",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-05-10"),
                      y = 11e6
            )
            b <- list(text = "New album is out!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-07-12"),
                      y = 6.3e6
            )
            
            plot_ly(singer_daily_df3 ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
                layout(title = "Popularity of Ed Sheeran",
                       xaxis = list(title = "Date"),
                       yaxis = list (title = "Streams"),
                       annotations = list(a,b))
        }
        else{
            singer_daily_df4 <- global_daily_data[which(global_daily_data$Artist=="XXXTENTACION"),] %>%
                arrange(Date) %>%
                group_by(Track.Name) %>%
                complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
                ungroup()
            
            a <- list(text = "New album is out!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2018-12-07"),
                      y = 3.56e6
            )
            
            plot_ly(singer_daily_df4 ,x = ~Date, y = ~ Streams, color = ~Track.Name, mode = 'lines') %>%
                layout(title = "Popularity of XXXTENTACION",
                       xaxis = list(title = "Date"),
                       yaxis = list (title = "Streams"),
                       annotations = a)
        }
        
    })
    
    output$feature_heat <- renderPlotly({
        feature_name = c("danceability", "energy", "loudness", "speechiness", "acousticness",
                         "instrumentalness", "liveness", "valence", "tempo")
        global_yearly_feature <- select(global_yearly_data, c(unlist(feature_name), "yearly_rank"))
        
        m <- cor(global_yearly_feature)
        plot_ly(x = c(unlist(feature_name), "yearly_rank"),
                y = c(unlist(feature_name), "yearly_rank"),
                z = m,
                zmin = -1,
                zmax = 1,
                type = "heatmap")
    })
    
    output$feature_ts <- renderPlotly({
        daily_average_feature <- global_daily_data %>%
            group_by(Date) %>%
            dplyr::summarise(danceability = mean(danceability),
                      energy = mean(energy),
                      loudness = mean(loudness),
                      speechiness = mean(speechiness),
                      acousticness = mean(acousticness),
                      liveness = mean(liveness),
                      valence = mean(valence),
                      tempo = mean(tempo)
            ) %>%
            ungroup()
        
        daily_average_feature <- daily_average_feature %>%
            gather(key = "feature", value = value, -Date) %>%
            group_by(feature) %>%
            dplyr::mutate(rescaled_value = 100* value/value[1])
        
        plot_ly(daily_average_feature, x = ~Date, y = ~ rescaled_value, color = ~feature, mode = 'lines') %>%
            layout(xaxis = list(title = "Date"),
                   yaxis = list (title = "Feature Value"))
    })
    
    output$streams_year_ts <- renderPlotly({
        global_total_daily_df <- global_daily_data %>%
            group_by(Date) %>%
            dplyr::summarize(total_listening = sum(Streams)) %>%
            ungroup()%>%
            arrange(Date)
        
        plot_ly(global_total_daily_df ,x = ~Date, y = ~total_listening, mode = 'lines') %>%
            layout(title = "Daily total listening",
                   xaxis = list(title = "Date"),
                   yaxis = list (title = "Streams"))
    })
    
    output$streams_weekday_ts <- renderPlot({
        global_total_daily_df <- global_daily_data %>%
            group_by(Date) %>%
            dplyr::summarize(total_listening = sum(Streams)) %>%
            ungroup()%>%
            arrange(Date)
        
        ggplot(global_total_daily_df, aes(Date, total_listening)) +
            geom_line() +
            geom_smooth(method = "loess", se = FALSE, lwd = 1.5) +
            facet_grid(.~wday(Date, label = TRUE))
    })
    
    
    get_filtered_df <- reactive({
        dan_low=input$dan[1]
        dan_high=input$dan[2] 
        ene_low=input$ene[1] 
        ene_high=input$ene[2] 
        lou_low=input$lou[1] 
        lou_high=input$lou[2] 

        subset(lyrics_df, danceability>=dan_low & danceability <= dan_high &
                   energy>=ene_low & energy <= ene_high &
                   loudness>=lou_low & loudness<=lou_high)
        
        })
    
    get_cloud_df <- reactive({
        
        lyrics_corpus = Corpus(DataframeSource(get_filtered_df()[,c("doc_id","text")]))
        
        lyrics_corpus = tm_map(lyrics_corpus, content_transformer(tolower))
        lyrics_corpus = tm_map(lyrics_corpus, removeNumbers)
        lyrics_corpus = tm_map(lyrics_corpus, removePunctuation)
        lyrics_corpus = tm_map(lyrics_corpus, removeWords, c(stop_words, stopwords("spanish")))
        lyrics_corpus =  tm_map(lyrics_corpus, stripWhitespace)
        
        lyrics_dtm <- DocumentTermMatrix(lyrics_corpus)
        
        lyrics_dtm = removeSparseTerms(lyrics_dtm, 0.95)
        
        get_freq_df <- data.frame(colSums(as.matrix(lyrics_dtm)))
        freq = data.frame(word = rownames(get_freq_df),freq = get_freq_df[,1])
        
        sorted <- freq[order(-freq$freq),]
        
        if(nrow(sorted)==0){
            temp = data.frame(cbind(name=c("No Data Selected"),value=c(1)))
            temp$"freq" <- as.numeric(temp$"freq")
            temp$"word" <- as.character(temp$"word")
            return(temp)
        }
        else if(nrow(sorted)>30){
            return(sorted[c(1:30),])
        }
        else{
            return(sorted)
        }
    })
    
    wordcloud_rep <- repeatable(wordcloud2)
    
    output$word_cloud <- renderWordcloud2({
        wordcloud_rep(data=get_cloud_df(),color = "random-dark",size=0.7)
    })
    
    
    output$graph <- renderForceNetwork({
        
        row.names(artist_df) <- artist_df$X
        artist_mat <- select(artist_df, -"X") %>%
            as.matrix()
        
        network <- graph_from_adjacency_matrix(artist_mat, weighted=T, mode="undirected", diag=F)
        wc <- cluster_walktrap(network)
        members <- membership(wc)
        netword_d3 <- igraph_to_networkD3(network, group = members)
        
        forceNetwork(Links =netword_d3$links, Nodes = netword_d3$nodes, 
                     Source = 'source', Target = 'target',
                     NodeID = 'name', Group = 'group',
                     linkDistance = 10, fontSize = 20,
                     opacity = 0.8, charge = -3)
    })
    
    output$type_ts <- renderPlotly({
        
        global_top_daily_df$Date <- as.Date(as.character(global_top_daily_df$Date),"%m/%d/%y")
        global_top_daily_df <-global_top_daily_df %>% arrange(Date)
        
        if(input$type_ts_input == "Falling"){
            track <- "thank u, next"
            p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "lines",name = ~"streams")
            p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
                layout(yaxis = list(autorange = "reversed"))
            subplot(p1,p2) %>%
                layout(title="Falling: thank u, next--Ariana Grande" )
        }
        
        else if(input$type_ts_input == "Rising before Falling"){
            track <- "Wow."
            p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "lines",name = ~"streams")
            p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
                layout(yaxis = list(autorange = "reversed"))
            subplot(p1,p2) %>%
                layout(title="Rise before Fall: Wow.--Post Malone" )
        }
        
        else{
            track <- "Dance Monkey"
            p1 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~Streams, type = "scatter", mode = "lines",name = ~"streams")
            p2 <- plot_ly(global_top_daily_df[which(global_top_daily_df$Track.Name==track),], x = ~Date, y = ~ Position, type = "scatter", mode = "lines", name = ~"rank")%>%
                layout(yaxis = list(autorange = "reversed"))
            subplot(p1,p2) %>%
                layout(title="Rising: Dance Monkey--Tones and I" )
        }
        

    })
    
})
