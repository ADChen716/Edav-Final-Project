library(shiny)


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
    tabItems(
        
        #########################
        ## Tab 1: Intro & Data ##
        #########################
        
        ########################################
        ## Tab 1 - 1: Background & Motivation ##
        ########################################
        
        tabItem(tabName = "tab_overview",
                fluidRow(
                    column(width = 6,
                           h4("Welcome, hahaha")
                    ),
                    column(width = 6)
                ),
                fluidRow(
                    box( width = 10,
                         title = textOutput("selected_song_lowbound"),
                         sliderInput("song_lowbound", label = "", min = 0, 
                                     max = 5, value = 1),
                         # busyIndicator(),
                         plotlyOutput("top_singer", width="100%"),
                         collapsible = T
                    )
                ),
                br(),
                
                h3("hahahaha"),
                fluidRow(
                )
        ),
        
        tabItem(tabName = "tab_missing",
                fluidRow(
                    tabBox(
                        # busyIndicator(),
                        selected = "Daily Data",
                        title = "Missing Pattern of: ", side = "right",
                        # height = 10,
                        width = 10,
                        tabPanel("Yearly Data", img(src = 'yearly_missing.png', height=600), height = 600),
                        tabPanel("Daily Data", img(src = 'daily_missing.png', height=600),height = 600)
                    )
                )
        )
        
        
    )
    
    
)


shinyUI(
    dashboardPage(
        # skin = "black",
        header, 
        sidebar, 
        body)
)
