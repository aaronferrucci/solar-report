library(ggplot2)
library(plyr)
library(grid)
library(gridExtra)
source("util.R")
source("getdata.R")
source("plot.R")

data <- getdata()
stopifnot(nrow(data) > 0)

energy <- getenergybydate(data)
annotations <- data.frame(
  date=c(
    with_tz(ymd_hm("2017-09-01 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-09-03 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-09-17 12:00"), "America/Los_Angeles"),
    with_tz(ymd_hm("2017-10-11 12:00"), "America/Los_Angeles")
  ),
  label=c(
    "smoky",   # I observed it
    "cleaned", # cleaned the panels
    "smoky",   # according to nextdoor
    "smoky"    # I observed it
  ),
  stringsAsFactors=F
)

startendmaxp <- startendmaxpbydate(data, annotations)

# Remove 0-kW points, to show the trend of start/end times.
data <- data[data$kW > 0,]
rect <- to_rect(data)

plot(rect, power, startendmaxp)
