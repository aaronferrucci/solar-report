library(ggplot2)
library(plyr)
library(grid)
library(gridExtra)
library(lubridate)
source("util.R")
source("getdata.R")
source("plot.R")

start <- proc.time();

data <- getdata(dropfirst=TRUE)
stopifnot(nrow(data) > 0)

energy <- getenergybydate(data)
annotations <- data.frame(
  date=c(
    with_tz(ymd_hm("2017-09-01 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-09-03 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-09-17 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-10-11 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-11-29 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2018-08-25 12:00"), "America/Los_Angeles")
  ),
  label=c(
    "smoky",   # I observed it
    "cleaned", # cleaned the panels
    "smoky",   # according to nextdoor
    "smoky",   # I observed it
    "outage",  # pg&e fail: power back on around 8:30AM
    "outage"   # pg&e work: power back on around 11:15AM
  ),
  stringsAsFactors=F
)

startendmaxp <- startendmaxpbydate(data, annotations)

# Remove 0-kW points, to show the trend of start/end times.
data <- data[data$kW > 0,]
rect <- to_rect(data)

plot(rect, startendmaxp)

duration <- proc.time() - start
writeLines("\nrun time:")
print(duration)
