###############################################################
# Global file for Sentiment Analytics Project ShinyApp
# Contains Global Var, Libraries, Self-defined Functions
# Updated on 21 Jan 2019, 3 pm, By Liu Yichi
###############################################################

# import libraries

# check and install any package, run: 
# if ("data.table" %in% rownames(installed.packages()) == FALSE) {install.packages("data.table")}
library(data.table)
library(shinydashboard)
library(shiny)
library(plotly)
library(zoo)
library(tm)
library(ECharts2Shiny)
library(plyr)

library(shinycssloaders)
library(dashboardthemes)

library(fmsb)
library(colourpicker)
library(formattable)
library(shinyWidgets)
library(tidyverse)
library(extracat)
library(dplyr)
library(lubridate)

# Overwrite the busyIndicator function in ShinySky
# busyIndicator <- function(text = "Loading in Progress...",img = "loading.gif", wait=1000) {
#   tagList(
#     singleton(tags$head(
#       tags$link(rel="stylesheet", type="text/css",href="busyIndicator.css"))
#     ), 
#     div(class="shinysky-busy-indicator",p(text),img(src=img)),
#     tags$script(sprintf(
#       "setInterval(function(){
#       if ($('html').hasClass('shiny-busy')) {
#       setTimeout(function() {
#       if ($('html').hasClass('shiny-busy')) {
#       $('div.shinysky-busy-indicator').show()
#       }
#       }, %d)  		    
#       } else {
#       $('div.shinysky-busy-indicator').hide()
#       }
# },100)",
#       wait)
#     )
#   )
# }

busyIndicator <- function(text = "Calculation in progress..",img = "shinysky/busyIndicator/ajaxloaderq.gif", wait=1000) {
  shiny::tagList(
    shiny::singleton(shiny::tags$head(
      shiny::tags$link(rel="stylesheet", type="text/css",href="shinysky/busyIndicator/busyIndicator.css")
    ))
    ,shiny::div(class="shinysky-busy-indicator",p(text),img(src=img))
    ,shiny::tags$script(sprintf(
      "	setInterval(function(){
  		 	 if ($('html').hasClass('shiny-busy')) {
  		    setTimeout(function() {
  		      if ($('html').hasClass('shiny-busy')) {
  		        $('div.shinysky-busy-indicator').show()
  		      }
  		    }, %d)  		    
  		  } else {
  		    $('div.shinysky-busy-indicator').hide()
  		  }
  		},100)
  		",wait)
    )
  )	
}

add_line_breaks <- function(a,n){
  a <-  str_wrap(a, width = n, indent = 0, exdent = 0)
  a <- c(paste(a, "\n"))
  return(a)
}
