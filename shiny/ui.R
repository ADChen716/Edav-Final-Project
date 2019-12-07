header <- dashboardHeader(
    title = "HAHAHA Spotify",
    tags$li(a(href = '',
              img(src = 'edav_logoo.png',
                  title = "Refresh", height = "40px"),
              style = "padding-top:5px; padding-bottom:0px;"),
            class = "dropdown")
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        id = "sidebarmenu",
        menuItem("Intro & Data", icon = icon("music"),
                 menuSubItem("Background & Motivation", tabName = "tab_bg"),
                 menuSubItem("Data Sources", tabName = "tab_source"),
                 menuSubItem("Data Transformation", tabName = "tab_trans")
        ),
        menuItem("Missing Values", tabName = "tab_missing", icon = icon("search")),
        menuItem("Data Overview", tabName = "tab_overview", icon = icon("eye")),
        menuItem("Results & Analysis", icon = icon("chart-bar"),
                 menuSubItem("Singer", tabName = "tab_singer"),
                 menuSubItem("Song", tabName = "tab_song"),
                 menuSubItem("User", tabName = "tab_user")
        ),
        menuItem("Conclusion", tabName = "tab_conclusion", icon = icon("book-open"))
    )
)

body <- dashboardBody(
    shinyDashboardThemes(
        theme = "poor_mans_flatly"
    ),
    tabItems(
        
        #########################
        ## Tab 1: Intro & Data ##
        #########################
        
        ########################################
        ## Tab 1 - 1: Background & Motivation ##
        ########################################
        
        
        ############################
        ## Tab 2: Missing pattern ##
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
        ## Tab 3: Data Overview ##
        ##########################
        
        tabItem(tabName = "tab_overview",
                fluidRow(
                    column(width = 6,
                           h4("Welcome, hahaha")
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
        ## Tab 4: Results & Analysis ##
        ###############################
        
        #######################
        ## Tab 4 - 1: Singer ##
        #######################
        
        tabItem(tabName = "tab_singer",
                fluidRow(
                    column(width = 6,
                           h4("From Overview of the top singers, we identified the below four singers who have more than XX songs on yearly TOP100")
                    ),
                    column(width = 6)
                ),
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
        
        #####################
        ## Tab 4 - 2: Song ##
        #####################
        
        tabItem(tabName = "tab_song",
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
                    box(title = "How the features are changing by date",status="primary",solidHeader = TRUE,
                        h3("Zoom in to see details"),
                        width = 12,
                        column(width=12,plotlyOutput("feature_ts", width="100%")%>% withSpinner(color="#0dc5c1")),
                        collapsible = T
                    )
                )
        ),
        
        
        #######################
        ## Tab 4 - 3: User ##
        #######################
        
        tabItem(tabName = "tab_user",
                fluidRow(
                    column(width = 6,
                           h4("Welcome, hahaha")
                    ),
                    column(width = 6)
                ),
                fluidRow(
                    box(title = "Select a song feature:",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("choropleth_feature_1", label = "Select a feature:", 
                               choices = c("danceability","energy","loudness","speechiness",
                                           "acousticness","instrumentalness","liveness",
                                           "valence","tempo"), selected = "danceability")),
                        column(width=10,plotlyOutput("choropleth_1", width="100%")),
                        collapsible = T
                    ),
                    box(title = "Select another feature for comparison:",status="primary",solidHeader = TRUE,
                        width = 12,
                        column(width=2,
                               radioButtons("choropleth_feature_2",label = "",
                               choices = c("danceability"="danceability","energy","loudness","speechiness",
                                           "acousticness","instrumentalness","liveness",
                                           "valence","tempo"), selected = "valence")),
                        column(width=10,plotlyOutput("choropleth_2", width="100%")),
                        collapsible = T,
                        collapsed=T
                    )
                ),
                fluidRow(
                    box(title = "Trend of Total Daily Streams",status="primary",solidHeader = TRUE,
                        width = 12,
                        plotlyOutput("streams_year_ts", width="100%"),
                        collapsible = T
                    ),
                    box(title = "Weekly Total Streams Pattern",status="primary",solidHeader = TRUE,
                        width = 12,
                        plotOutput("streams_weekday_ts", width="100%"),
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
