shinyServer(function(input, output, session) {
    
    daily_data <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
    global_daily_data <- daily_data[daily_data$Region=="global",]
    global_daily_data$Date<-  as.Date(global_daily_data$Date)
    
    yearly_data <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
    yearly_data$Track.Name <- add_line_breaks(yearly_data$Track.Name, 20)
    global_yearly_data <- subset(yearly_data, Region == "global")
    
    
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
                         "instrumentalness", "liveness", "valence", "tempo", "duration_ms")
        standardized_feature <- data.frame(scale(global_yearly_data[, feature_name]))
        
        features <- gather(standardized_feature, "feature", "value")
        plot_ly(features, y = ~value, color = ~feature, type = "box") %>%
            layout(xaxis = list(title = "Song Feature"),
                   yaxis = list(title = "Standardized Value"))
    })
    
    output$choropleth_1 <- renderPlotly({
        yearly_map_df <- subset(yearly_df, Region!="global")
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
    
    output$choropleth_2 <- renderPlotly({
        yearly_map_df <- subset(yearly_df, Region!="global")
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
        
        plot_geo(plot_df) %>%
            add_trace(
                z = plot_df[,c(input$choropleth_feature_2)], color = plot_df[,c(input$choropleth_feature_2)], colors = 'Blues',
                text = ~country_name, locations = ~Group.1, marker = list(line = l)
            ) %>%
            colorbar(title = '', tickprefix = '') %>%
            layout(
                title = 'Average song features by country',
                geo = g,
                margin = list(l=0, pad=0)
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
            summarise(Freq = n()) %>%
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
            summarise(Freq = n()) %>%
            arrange(-Freq) %>%
            subset(Freq > 100)
        
        plot_ly(days_of_songs, x = ~Freq, y = ~reorder(Track,Freq), type = 'scatter',
                mode = "markers", marker = list(color = "blue")) %>%
            layout(
                title = "How long are these songs staying in Global Top 100?",
                xaxis = list(title = "Number of days in Global Top 100"),
                yaxis = list(title = "Track")
            )
    })
    
    output$singer_ts <- renderPlotly({
        singer_name = input$singer_ts_input
        
        if(singer_name == "Post Malone"){
            singer_daily_df <- global_daily_df[which(global_daily_df$Artist=="Post Malone"),] %>%
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
            singer_daily_df2 <- global_daily_df[which(global_daily_df$Artist=="Billie Eilish"),] %>%
                arrange(Date)%>%
                group_by(Track.Name) %>%
                complete(Date = seq.Date(min(Date), max(Date), by="day"))%>%
                ungroup()
            
            a <- list(text = "New album is out!",
                      showarrow = TRUE,
                      arrowhead = 1,
                      x = as.Date("2019-02-01"),
                      y = 5.56e6
            )
            b <- list(text = "Another album is out!",
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
            singer_daily_df3 <- global_daily_df[which(global_daily_df$Artist=="Ed Sheeran"),] %>%
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
            singer_daily_df4 <- global_daily_df[which(global_daily_df$Artist=="XXXTENTACION"),] %>%
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
                type = "heatmap",
                colors = colorRamp(c("navyblue", "white", "pink")))
    })
    
    output$feature_ts <- renderPlotly({
        daily_average_feature <- global_daily_data %>%
            group_by(Date) %>%
            summarise(danceability = mean(danceability),
                      energy = mean(energy),
                      loudness = mean(loudness),
                      speechiness = mean(speechiness),
                      acousticness = mean(acousticness),
                      instrumentalness = mean(instrumentalness),
                      liveness = mean(liveness),
                      valence = mean(valence),
                      tempo = mean(tempo)
                      #duration_ms = mean(duration_ms)
            ) %>%
            ungroup()
        
        daily_average_feature <- daily_average_feature %>%
            gather(key = "feature", value = value, -Date) %>%
            group_by(feature) %>%
            mutate(rescaled_value = 100* value/value[1])
        
        plot_ly(daily_average_feature, x = ~Date, y = ~ rescaled_value, color = ~feature, mode = 'lines') %>%
            layout(title = "Trend of tastes",
                   xaxis = list(title = "Date"),
                   yaxis = list (title = "Feature Value"))
    })
    
    output$streams_year_ts <- renderPlotly({
        global_total_daily_df <- global_daily_data %>%
            group_by(Date) %>%
            summarize(total_listening = sum(Streams)) %>%
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
            summarize(total_listening = sum(Streams)) %>%
            ungroup()%>%
            arrange(Date)
        
        ggplot(global_total_daily_df, aes(Date, total_listening)) +
            geom_line() +
            geom_smooth(method = "loess", se = FALSE, lwd = 1.5) +
            facet_grid(.~wday(Date, label = TRUE))
    })
    
})
