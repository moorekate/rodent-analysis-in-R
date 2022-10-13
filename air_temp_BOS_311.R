#OBJECTIVE
#Determine if average outside air temperature is significantly correlated with rodent-related BOS 311 submissions.

#Datasets
  #BOS 311: https://data.boston.gov/dataset/311-service-requests/resource/81a7b022-f8fc-4da5-80e4-b160058ca207
  #NOAA Boston Logan (Avg Daily Air Temp): https://www.ncdc.noaa.gov/cdo-web/search

#Required libraries: readr, dplyr, lubridate
#Source 1: https://www.tutorialkart.com/r-tutorial/import-excel-data-into-r-dataframe/#:~:text=To%20read%20Excel%20Data%20into,frame()%20function.&text=In%20the%20above%20example%2C%20when,is%20read%20into%20a%20tibble.
#Source 2: https://sparkbyexamples.com/r-programming/remove-column-in-r/#remove-columns-by-using-dplyr-functions
#Source 3: https://stackoverflow.com/questions/23089895/how-to-remove-time-field-string-from-a-date-as-character-variable
#Source 4: https://statisticsglobe.com/convert-data-frame-column-to-a-vector-in-r
#Source 5: https://statisticsglobe.com/replace-entire-data-frame-column-r
#Source 6: https://www.infoworld.com/article/3454356/how-to-merge-data-in-r-using-r-merge-dplyr-or-datatable.html
#Source 7: https://stackoverflow.com/questions/44445910/summarize-weekly-average-using-daily-data-in-r
#Source 8: https://statisticsglobe.com/mean-by-group-in-r
#Source 9: https://stackoverflow.com/questions/14441729/read-a-csv-from-github-into-r

#NOTES
#Save > Stage > Commit > $ git push
#Create a branch in RStudio: https://r-bio.github.io/intro-git-rstudio/#:~:text=RStudio%20can't%20create%20branches,git%20checkout%20%2Db%20new%2Dbranch

#DATA PREPARATION#
#Download CSV from web page --> Data Frame
download <- read.csv("https://data.boston.gov/dataset/8048697b-ad64-4bfc-b090-ee00169f2323/resource/81a7b022-f8fc-4da5-80e4-b160058ca207/download/tmpfgyy0wmu.csv")
#Rename variable 
BOS311_2022 <- download
#View data frame in new window 
View(BOS311_2022)
#Excel/Tibble --> R Data Frame using data.frame(Excel_import_name)
create_df <- BOS311_2022
#View Data Frame in new window
View(create_df)
#Remove columns using select()
new_df <- create_df %>% select(-c(submittedphoto, closedphoto))
View(new_df)
#Join Avg air temp per day to rodent sighting data using open_dt
AirTemp <- read_csv("https://raw.githubusercontent.com/moorekate/rodent-analysis-in-R/main/AirTemp_10-5_2022.csv")
View(AirTemp)
#Convert open_dt from BOS 311 column to vector  ; new_vec <- df$column_name
open_dt_vec <- new_df$open_dt
View(open_dt_vec)
#Format content of vector as.Date type
strip_time <- as.Date(open_dt_vec)
View(strip_time)
#Convert vector back to data frame
as.data.frame(strip_time)
View(strip_time)
#Overwrite column with formatted data 
new_df$open_dt <- strip_time
#Join avg. daily air temp to each BOS 311 record, using open_dt field
join_dt = left_join(new_df,AirTemp, by = c("open_dt"="DATE"))
View(join_dt)
#Add weekly average temp
new_df$week_num <- isoweek(open_dt)
View(new_df)
#NOTE: For the ISOWEEK function, the week starts on Monday. 
#NOTE: January 1 was a Saturday in 2022, so it will show 52 as the result. 
#NOTE: January 3-January 10 will be the first week of 2022.
