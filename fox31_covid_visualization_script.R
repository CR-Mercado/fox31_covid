#' This script generates an improved Fox31 COVID-19 Visual for LinkedIn

library(ggplot2) #pretty plot 
library(lubridate) # day of week 

#' Data Generation 
#'    Copying from the visual 

covid_dates <- seq.Date(from = as.Date("2020-03-18"),
                        to = as.Date("2020-04-01"),
                        by = "day")

day_of_week <- weekdays(covid_dates)

cases <- c(33, 61, 86, 112, 116, 129, 192,
           174, 344, 304, 327, 246, 320, 339, 376)

if(length(covid_dates) != length(cases)){ 
  stop("Each date should have exactly 1 case value")
}

fox31 <- data.frame("Date" = covid_dates, 
                    "Day" = day_of_week,
                    "New_Cases" = cases,
                    "Days_Since_Mar18" = 1:length(cases), 
                    "Weekend" = ifelse(test = day_of_week %in% 
                                         c("Saturday","Sunday"),
                                       yes = 1,
                                        no = 0 )
                    )


#' Create a background with light pink bars highlighting weekends 
background <- ggplot(data = fox31,
                     aes(x = Days_Since_Mar18, y = New_Cases)) +
  theme_light() + 
  geom_bar(data = fox31, aes(x = Days_Since_Mar18, 
                             y = ifelse(test = fox31$Weekend, 
                             yes = 400,
                             no = 0)),
          stat = "identity",
           fill = "pink",
           alpha = 0.25) + 
  labs(x = "Days Since March 18", 
       y = "Daily New Cases",
       caption =  "Weekends noted in Pink",
       title = "More New Cases Every Day Show Exponential Growth of Virus") 

# Add points to background 
  # legend won't be used
local_covid <- background +  
  geom_smooth(se = FALSE, method = "lm", linetype = "dashed") + 
  geom_point(data = fox31,
             mapping = aes(x = Days_Since_Mar18,
                           y = New_Cases, 
                           size = New_Cases)) + theme(legend.position = "none")

# generating a label for every other day 
# because everyday is too crowded. 

fox31$Date2 <- format(fox31$Date,"%m/%d")
fox31$Date2[(rep(c(FALSE,TRUE),nrow(fox31)/2))] <- ""

# add labels and print 
local_covid + geom_text(aes(label = New_Cases), nudge_y = -10) +
  geom_text(data = fox31, aes(label = Date2), nudge_y = 30)
 