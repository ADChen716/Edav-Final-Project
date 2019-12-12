library(tidyverse)
library(plotly)
library(countrycode)

yearly_df <- read.csv("/Users/nessyliu/Documents/GitHub/Edav-Final-Project/data/clean/yearly_data.csv", header = T)
yearly_df <- select(yearly_df,-"X")

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

l <- list(color = toRGB("grey"), width = 0.5)

p <- plot_geo(plot_df) %>%
  add_trace(
    z = plot_df$instrumentalness, color = plot_df$instrumentalness, colors = 'Blues',
    text = ~country_name, locations = ~Group.1, marker = list(line = l)
  ) %>%
  colorbar(title = '', tickprefix = '') %>%
  layout(
    title = 'Average song features by country',
    geo = g,
    margin = list(l=30)
    )



