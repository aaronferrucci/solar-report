library(lubridate)
getdata <- function() {
  dir <- "../../solar/data"
  days <- list.files(dir, pattern='*.csv', recursive=T)

  data <- data.frame()
  
  for (day in days) {
    lines <- readLines(file.path(dir, day))
    lines <- lines[-(1:3)]
    thisdata <- read.csv(text=lines, stringsAsFactors=F)
    thisdata$datetime <- with_tz(mdy_hms(paste(thisdata$date, thisdata$time)), "America/Los_Angeles")
    names(thisdata)[names(thisdata) == "power..kW."] <- "kW"
    data <- rbind(data, thisdata)
  }
  return(data)
}