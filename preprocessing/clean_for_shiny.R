# clean the existing data for shiny app to solve the memory problem

library(countrycode) 


# with 2 id
daily_df_cleaned <- daily_df[,c(1:7,10:11,13,15:21,23)]
global_daily_df_cleaned <- daily_df_cleaned[which(daily_df_cleaned$Region=="global"),]
write.csv(global_daily_df_cleaned,"/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/shiny/www/daily_global.csv")

yearly_df_cleaned <- yearly_df[,c(1:6,9,10,12,14:20,22)]
global_yearly_df_cleaned <- yearly_df_cleaned[which(yearly_df_cleaned$Region=="global"),]
write.csv(global_daily_df_cleaned,"/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/shiny/www/yearly_global.csv")



# without 2 id
daily_df_cleaned <- daily_df[,c(2:7,10:11,13,15:21)]
global_daily_df_cleaned <- daily_df_cleaned[which(daily_df_cleaned$Region=="global"),]
write.csv(global_daily_df_cleaned,"/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/shiny/www/daily_global_no_id.csv")

yearly_df_cleaned <- yearly_df[,c(1:5,9,10,12,14:20)]
global_yearly_df_cleaned <- yearly_df_cleaned[which(yearly_df_cleaned$Region=="global"),]
write.csv(global_daily_df_cleaned,"/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/shiny/www/yearly_global_no_id.csv")

# map

yearly_map_df <- subset(yearly_df, Region!="global")
yearly_map_df$country_code <- countrycode(toupper(yearly_map_df$Region),origin = 'iso2c',destination = 'iso3c')

plot_df <- aggregate(yearly_map_df[, c("danceability","energy","loudness","speechiness",
                                       "acousticness","instrumentalness","liveness" ,
                                       "valence","tempo")], 
                     list(yearly_map_df$country_code), mean)
plot_df$country_name <- countrycode(plot_df$Group.1,origin = 'iso3c',destination = 'country.name')
write.csv(plot_df,"/Users/ruibai/Documents/study/STAT5702EDAV/finalPJ/Edav-Final-Project/shiny/www/choropleth_cleaned.csv")


