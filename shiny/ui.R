header <- dashboardHeader(
    title = tags$b("Happy Spotify"),
    tags$li(a(href = '',
              img(src = 'edav_logoo.png',
                  title = "Refresh", height = "40px"),
              style = "padding-top:5px; padding-bottom:0px;"),
            class = "dropdown")
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        id = "sidebarmenu",
        menuItem("Welcome", tabName = "tab_welcome", icon = icon("star")),
        menuItem("Missing Values", tabName = "tab_missing", icon = icon("search")),
        menuItem("Data Overview", tabName = "tab_overview", icon = icon("eye")),
        menuItem("Results & Analysis", icon = icon("chart-bar"),
                 menuSubItem("Streams Trend", tabName = "tab_streams"),
                 menuSubItem("Feature Analysis", tabName = "tab_feature"),
                 menuSubItem("Singers Deep Dive", tabName = "tab_singer"),
                 menuSubItem("Hey lyrics", tabName = "tab_lyrics")
        )
    )
)

body <- dashboardBody(
    shinyDashboardThemes(
        theme = "poor_mans_flatly"
    ),
    
    tabItems(
        
        ############################
        ## Tab 1: Missing pattern ##
        ############################
        
        tabItem(tabName = "tab_welcome",
                fluidRow(
                    box(width = 12, solidHeader = FALSE,
                        h1("Welcome to Happy Spotify!"),
                        h3("This Shiny App visualizes our Spotify data analysis."),
                        h3(""),
                        h4("We want to explore the following four aspects:"),
                        h4("- Are there any trends of songs' steams over time?"),
                        h4("- Do people show special preference to some audio features?"),
                        h4("- Is there anything thought-provoking for singers? For example, do they have some genres? Or do they share some similarties with other singers?"),
                        h4("- What about the lyrics? Are there any interesting common words for different songs?"),
                        h3(""),
                        img(src = 'spotify_logo.jpg', width="70%")
                    )
                ),
                fluidRow(
                    box(width = 12, solidHeader = FALSE,
                        align="right",
                        
                        h4("By:"),
                        h4("Rui Bai (rb3454)"),
                        h4("Yichi Liu (yl4327)"),
                        h4("Yuchen Pei (yp2533)"),
                    )
                )
        ),
        
        tabItem(tabName = "tab_missing",
                fluidRow(
                   box(width = 8,
                       title = "Missing Pattern of daily ranking data: ", status="primary",solidHeader = TRUE,
                       side = "right",
                       img(src = 'missing.png', width="100%")
                       )
                )
        ),
        
        ##########################
        ## Tab 2: Data Overview ##
        ##########################
        
        tabItem(tabName = "tab_overview",
                fluidRow(
                    box(width = 12, status="primary",solidHeader = TRUE,
                        title = textOutput("selected_song_lowbound"),
                        sliderInput("song_lowbound", label = "Set lowerbound for # of songs", min = 0, 
                                    max = 5, value = 1),
                        plotlyOutput("top_singer", width="100%")%>% withSpinner(color="#0dc5c1"),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "How long are the singers staying in Global TOP 100",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=12,plotlyOutput("singer_cleveland", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "How long are the songs staying in Global TOP 100",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=12,plotlyOutput("song_cleveland", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                )
        ),
        
        
        ###############################
        ## Tab 3: Results & Analysis ##
        ###############################
        
        ##############################
        ## Tab 3 - 1: Streams Trend ##
        ##############################
        
        tabItem(tabName = "tab_streams",
                fluidRow(
                    box(title = "Trend of Total Daily Streams",status="primary",solidHeader = TRUE,
                        width = 12,
                        plotlyOutput("streams_year_ts", width="100%")%>% withSpinner(color="#0dc5c1"),
                        collapsible = T
                    ),
                    box(title = "Weekly Total Streams Pattern",status="primary",solidHeader = TRUE,
                        width = 12,
                        plotOutput("streams_weekday_ts", width="100%")%>% withSpinner(color="#0dc5c1"),
                        collapsible = T
                    )
                ),
                
                fluidRow(
                    box(title = "Major Popularity Trends",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("type_ts_input", label = "Select a Trend:", 
                                            choices = c("Falling","Rising before Falling","Rising"),
                                            selected = "Falling")),
                        column(width=10,plotlyOutput("type_ts", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                )
                
        ),
        
        ########################
        ## Tab 3 - 2: Feature ##
        ########################
        
        tabItem(tabName = "tab_feature",
                fluidRow(
                    box(width = 12, status="primary",solidHeader = TRUE,
                        title = "How do the features look like",
                        plotlyOutput("feature_boxplot", width="100%")%>% withSpinner(color="#0dc5c1"),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "How song feaures are correlated",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=12,plotlyOutput("feature_heat", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "How song features are prefered in different contries",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("choropleth_feature_1", label = "Select a feature:", 
                                            choices = c("danceability","energy","loudness","speechiness",
                                                        "acousticness","instrumentalness","liveness",
                                                        "valence","tempo"), selected = "danceability")),
                        column(width=10,plotlyOutput("choropleth_1", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "How song features change by date",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=12,plotlyOutput("feature_ts", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                )
        ),
        
        #########################
        ## Tab 4 - 3: Singer   ##
        #########################
        
        tabItem(tabName = "tab_singer",
                fluidRow(
                    box(title = "Their popularity as time goes by",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("singer_ts_input", label = "Select a Singer:", 
                                            choices = c("Post Malone","Billie Eilish","Ed Sheeran","XXXTENTACION"),
                                            selected = "Post Malone")),
                        column(width=10,plotlyOutput("singer_ts", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "How his/her hottest songs sound like",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("singer_radar_input", label = "Select a Singer:", 
                                            choices = c("Post Malone","Billie Eilish","Ed Sheeran","XXXTENTACION"),
                                            selected = "Post Malone")),
                        column(width=10,plotlyOutput("singer_radar", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "Connection of Singers",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2, 
                               h5("Each node represents a singer. Hover over each node to see his/her name."),
                               h5("Singers in same clusters (attracting similar groups of Spoftify users) are in the same color."),
                               h5("Drag each node to see its relationship with others."),
                               ),
                        column(width=10, forceNetworkOutput(outputId = "graph")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                )
                
        ),
        
        
        #######################
        ## Tab 4 - 4: User   ##
        #######################
        
        
        tabItem(tabName = "tab_lyrics",
                fluidRow(
                    box(width=12, title="What are they singing about with your feature selection",status="primary", solidHeader = TRUE, 
                        column(width = 4,
                               
                            div(style="height: 100px;",
                                sliderInput("dan", label = "danceability", 
                                            min = 0.351, max = 0.95, value = c(0.351, 0.95))),
                            div(style="height: 100px;",
                                sliderInput("ene", label = "energy", 
                                            min = 0.104, max = 0.904, value = c(0.104, 0.904))),
                            
                            div(style="height: 100px;",
                                sliderInput("lou", label = "loudness", 
                                            min = -14.505, max = -2.729, value = c(-14.505, -2.729)))
                        ),
                        column(width = 8, wordcloud2Output('word_cloud') %>% withSpinner(color="#0dc5c1")),
                         
                        collapsible = T
                    )
                ),
                
                fluidRow(
                    box( width=6, 
                         title="Christmas",status="primary", solidHeader = TRUE,
                         img(src = 'christmas.png', width="100%"),
                         collapsible = T
                    ),
                    box( width=6, 
                         title="Halloween",status="primary", solidHeader = TRUE,
                         img(src = 'halloween.png', width="100%"),
                         collapsible = T
                    )
                ),
                fluidRow(
                    box( width=6, 
                         title="Romance",status="primary", solidHeader = TRUE,
                         img(src = 'romance.png', width="100%"),
                         collapsible = T
                    ),
                    box( width=6, 
                         title="Hiphop",status="primary", solidHeader = TRUE,
                         img(src = 'hiphop.png', width="100%"),
                         collapsible = T
                    )
                )
        )
    )
)


shinyUI(
    dashboardPage(
        header, 
        sidebar, 
        body)
)
