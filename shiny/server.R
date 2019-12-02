library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # daily_data <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/daily_data_final.csv", header = T)
    # daily_data <- select(daily_df,-"X")
    
    yearly_data <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
    # yearly_data <- select(yearly_df,-"X")
    
    output$top_singer <- renderPlotly({
        global_yearly_data <- subset(yearly_data, Region == "global")

        # singers who have more than one songs on the ranking
        singers <- global_yearly_data %>%
            group_by(Artist) %>%
            dplyr::summarise(Count = n())
        top_singers <- subset(singers, Count > input$song_lowbound)

        # draw a barchart to have an overview of top singers
        plot_ly(top_singers, x=~reorder(Artist, -Count), y=~Count, type="bar") %>%
            layout(xaxis = list(title = "Artist"),
                   yaxis = list(title = "Count of songs on the ranking"))
    })
    
    output$selected_song_lowbound <- renderText({ 
        paste("Artists with more than",input$song_lowbound,"songs on Global Top 100 from Nov.01 2018 to Oct.31 2019")
    })
    
    # output$daily_missing <- renderPlot({
    #     
    #     # Yearly missing pattern
    #     visna(daily_df, sort = "b")
    #     
    # })

})
