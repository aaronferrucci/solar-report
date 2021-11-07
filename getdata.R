library(lubridate)
getdata_day <- function(dir, csv) {
  lines <- readLines(file.path(dir, csv))

  # Remove firmware rev, etc.
  lines <- lines[-(1:3)]

  # Read into data.frame, convert datetime
  thisdata <- read.csv(text=lines, stringsAsFactors=F)
  thisdata$datetime <- with_tz(mdy_hms(paste(thisdata$date, thisdata$time)), "America/Los_Angeles")

  # convert to a more R-friendly name
  names(thisdata)[names(thisdata) == "power..kW."] <- "kW"

  # for plotting, I think I want a "minutes in this day" field
  thisdata$minute <- 60 * hour(thisdata$datetime) + minute(thisdata$datetime)

  return(thisdata)
}

getdata <- function(dropfirst) {
  if (missing(dropfirst)) {
    dropfirst = FALSE
  }
  dir <- "../../solar/data"
  days <- list.files(dir, pattern='*.csv', recursive=T)

  if (dropfirst) {
    # Drop the first (incomplete) day)
    days <- days[2:length(days)]
  }

  data <- data.frame()

  for (day in days) {
    thisdata <- getdata_day(dir, day)

    # add this day's data to the aggregate
    data <- rbind(data, thisdata)
  }
  return(data)
}

to_rect <- function(data) {
  rect <- data.frame(datetime = data$datetime, kW = data$kW)
  rect$hmin <- force_tz(ymd_hm(paste(date(rect$datetime), 0, 0)), "America/Los_Angeles")
  # A bit of overlap avoids vertical gaps in the displayed data
  rect$hmax <- force_tz(ymd_hm(paste(date(data$datetime), 24, 01)), "America/Los_Angeles")
  rect$vmin <- data$minute
  rect$vmax <- data$minute + 5

  return(rect)
}

getenergybydate <- function(data) {
  mx <- data %>% group_by(date) %>% summarize(val = max(raw, na.rm=T))
  mx$date <- mdy_hm(paste(mx$date, " 12:00"))
  mx <- mx[order(mx$date),]

  mn <- data %>% group_by(date) %>% summarize(val = min(raw, na.rm=T))
  mn$date <- mdy_hm(paste(mn$date, " 12:00"))
  mn <- mn[order(mn$date),]

  energy <- data.frame(date=mx$date, energy=mx$val - mn$val)

  return(energy)
}

startendmaxpbydate <- function(data, annotations) {
  start <- ddply(data, "date", summarize, start = min(time))
  start$start <- with_tz(mdy_hms(paste(start$date, start$start)), "America/Los_Angeles")
  start$start <- 60*hour(start$start) + minute(start$start)
  start$date <- mdy_hm(paste(start$date, "12:00"))
  start <- start[order(start$date),]

  end <- ddply(data, "date", summarize, end=max(time))
  end$end <- with_tz(mdy_hms(paste(end$date, end$end)), "America/Los_Angeles")
  end$end <- 60*hour(end$end) + minute(end$end)
  end$date <- mdy_hm(paste(end$date, "12:00"))
  end <- end[order(end$date),]

  maxp <- ddply(data, "date", summarize, maxp=max(kW))
  maxp$date <- mdy_hm(paste(maxp$date, "12:00"))
  maxp <- maxp[order(maxp$date),]

  startendmaxp <- merge(start, end, by="date")
  startendmaxp <- merge(startendmaxp, maxp, by="date")
  startendmaxp <- merge(startendmaxp, annotations, by="date", all=T)

  return(startendmaxp)
}
