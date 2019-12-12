# import libraries

# check and install any package, run: 
# if ("data.table" %in% rownames(installed.packages()) == FALSE) {install.packages("data.table")}
library(shinydashboard)
library(shiny)
library(plotly)
library(tm)
library(wordcloud2)
library(plyr)
library(shinycssloaders)
library(dashboardthemes)
library(fmsb)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(lubridate)
library(countrycode)
library(igraph)
library(networkD3)

stop_words <- read.csv("www/stop_words.csv")
stop_words <- as.character(stop_words$stop_word)

add_line_breaks <- function(a,n){
  a <-  str_wrap(a, width = n, indent = 0, exdent = 0)
  a <- c(paste(a, "\n"))
  return(a)
}



