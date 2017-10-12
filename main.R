library(ggplot2)
library(plyr)
library(grid)
library(gridExtra)
source("util.R")
source("getdata.R")
source("plot.R")

data <- getdata()
energy <- getenergybydate(data)

# Remove 0-kW points, to show the trend of start/end times.
data <- data[data$kW > 0,]
# p <- ggplot(data) + geom_point(size=4, shape=15, aes(x=date(datetime), y = minute, col=kW)) + scale_colour_gradient(low = "blue", high="red")
rect <- to_rect(data)

annotations <- data.frame(
  x=c(
    force_tz(ymd_hm("2017-09-01 12:01"), "America/Los_Angeles"),
    force_tz(ymd_hm("2017-09-03 12:01"), "America/Los_Angeles"),
    force_tz(ymd_hm("2017-09-17 12:01"), "America/Los_Angeles"),
    force_tz(ymd_hm("2017-10-11 12:01"), "America/Los_Angeles")
  ),
  y=c(20*60),
  label=c(
    "smoky", # I observed it
    "cleaned", # cleaned the panels
    "smoky", # according to nextdoor
    "smoky"  # I observed it
  )
)
plot(rect, power)
