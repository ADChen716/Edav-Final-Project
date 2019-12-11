header <- dashboardHeader(
    title = "Happy Spotify",
    tags$li(a(href = '',
              img(src = 'edav_logoo.png',
                  title = "Refresh", height = "40px"),
              style = "padding-top:5px; padding-bottom:0px;"),
            class = "dropdown")
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        id = "sidebarmenu",
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
        
        tabItem(tabName = "tab_missing",
                fluidRow(
                   box(title = "Missing Pattern of daily ranking data: ", status="primary",solidHeader = TRUE,
                       side = "right",
                       img(src = 'daily_missing.png', width="100%")
                       )
                )
        ),
        
        ##########################
        ## Tab 2: Data Overview ##
        ##########################
        
        tabItem(tabName = "tab_overview",
                fluidRow(
                    column(width = 6,
                           h4("Welcome!")
                    ),
                    column(width = 6)
                ),
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
                    box(width = 12, status="primary",solidHeader = TRUE,
                        title = "How do the features look like",
                        plotlyOutput("feature_boxplot", width="100%")%>% withSpinner(color="#0dc5c1"),
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
                    box(title = "4 Major Popularity Trends",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("type_ts_input", label = "Select a Trend:", 
                                            choices = c("1","2","3","4"),
                                            selected = "1")),
                        column(width=10,plotlyOutput("type_ts", width="100%")),
                        collapsible = T
                    )
                ),
                
                fluidRow(
                    box(title = "Their popularity as time goes by",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("singer_ts_input", label = "Select a Singer:", 
                                            choices = c("Post Malone","Ed Sheeran","Billie Eilish","XXXTENTACION"),
                                            selected = "Post Malone")),
                        column(width=10,plotlyOutput("singer_ts", width="100%")),
                        collapsible = T
                    )
                )
        ),
        
        ########################
        ## Tab 3 - 2: Feature ##
        ########################
        
        tabItem(tabName = "tab_feature",
                fluidRow(
                    column(width = 6,
                           h4("We want to explore..... NEED TO change z name?")
                    ),
                    column(width = 6)
                ),
                fluidRow(
                    box(title = "How song feaures are correlated",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=12,plotlyOutput("feature_heat", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "Select a song feature:",status="primary",solidHeader = TRUE,
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
                    box(title = "How the features are changing by date",status="primary",solidHeader = TRUE,
                        h3("Zoom in to see details"),
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
                    box(title = "How his/her hottest songs sound like",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("singer_radar_input", label = "Select a Singer:", 
                                            choices = c("Post Malone","Ed Sheeran","Billie Eilish","XXXTENTACION"),
                                            selected = "Post Malone")),
                        column(width=10,plotlyOutput("singer_radar", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                ),
                fluidRow(
                    box(title = "Connection of Singers",status="primary",solidHeader = TRUE,
                        width = 12,
                        forceNetworkOutput(outputId = "graph")%>% withSpinner(color="#0dc5c1"),
                        collapsible = T
                    )
                )
                
        ),
        
        
        #######################
        ## Tab 4 - 4: User   ##
        #######################
        
        
        tabItem(tabName = "tab_lyrics",
                fluidRow(
                    box(width=12, title="word cloud",status="primary", solidHeader = TRUE, 
                        column(width = 4,
                               
                            div(style="height: 80px;",
                                sliderInput("dan", label = "danceability", 
                                            min = 0.24, max = 0.975, value = c(0.24, 0.975))),
                            div(style="height: 80px;",
                                sliderInput("ene", label = "energy", 
                                            min = 0.0983, max = 0.992, value = c(0.0983, 0.992))),
                            
                            div(style="height: 80px;",
                                sliderInput("lou", label = "loudness", 
                                            min = -18.064, max = -0.787, value = c(-18.064, -0.787)))
                        ),
                        column(width = 4,
                               div(style="height: 80px;",
                                   sliderInput("spe", label = "speechiness", 
                                               min = 0.0232, max = 0.556, value = c(0.0232, 0.556))),
                               div(style="height: 80px;",
                                   sliderInput("aco", label = "acousticness", 
                                               min = 0, max = 0.981, value = c(0, 0.981))),
                               div(style="height: 80px;",
                                   sliderInput("ins", label = "instrumentalness", 
                                               min = 0, max = 0.745, value = c(0, 0.745))),
                        ),
                        column(width = 4,
                               div(style="height: 80px;",
                                   sliderInput("liv", label = "liveness", 
                                               min = 0.0161, max = 0.989, value = c(0.0161, 0.989))),
                               div(style="height: 80px;",
                                   sliderInput("val", label = "valence", 
                                               min = 0.0605, max = 0.972, value = c(0.0605, 0.972))),
                               div(style="height: 80px;",
                                   sliderInput("tem", label = "tempo", 
                                               min = 62.484, max = 215.219, value = c(62.484, 215.219)))
                        ),
                         
                        collapsible = T
                    )
                ),
                fluidRow(
                    box( width=6, title="word cloud",status="primary", solidHeader = TRUE,
                         plotOutput("word_cloud"),
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
