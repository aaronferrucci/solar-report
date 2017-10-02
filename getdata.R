library(lubridate)
getdata <- function() {
  dir <- "../../solar/data"
  days <- list.files(dir, pattern='*.csv', recursive=T)

  data <- data.frame()
  
  for (day in days) {
    lines <- readLines(file.path(dir, day))
    
    # Remove firmware rev, etc.
    lines <- lines[-(1:3)]
    
    # Read into data.frame, convert datetime
    thisdata <- read.csv(text=lines, stringsAsFactors=F)
    thisdata$datetime <- with_tz(mdy_hms(paste(thisdata$date, thisdata$time)), "America/Los_Angeles")
    
    # convert to a more R-friendly name
    names(thisdata)[names(thisdata) == "power..kW."] <- "kW"

    # for plotting, I think I want a "minutes in this day" field
    thisdata$minute <- 60 * hour(thisdata$datetime) + minute(thisdata$datetime)
    # add this day's data to the aggregate
    data <- rbind(data, thisdata)
  }
  return(data)
}

to_rect <- function(data) {
  rect <- data.frame(datetime = data$datetime, kW = data$kW)
  rect$hmin <- force_tz(ymd_hm(paste(date(rect$datetime), 0, 0)), "America/Los_Angeles")
  rect$hmax <- force_tz(ymd_hm(paste(date(data$datetime), 23, 59)), "America/Los_Angeles")
  rect$vmin <- data$minute
  rect$vmax <- data$minute + 5

  return(rect)
}