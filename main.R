library(ggplot2)
library("plyr")
source("util.R")
source("getdata.R")

data <- getdata()
power <- getpowerbydate(data)

# Remove 0-kW points, to show the trend of start/end times.
data <- data[data$kW > 0,]
# p <- ggplot(data) + geom_point(size=4, shape=15, aes(x=date(datetime), y = minute, col=kW)) + scale_colour_gradient(low = "blue", high="red")
rect <- to_rect(data)

annotations <- data.frame(
  x=c(
    force_tz(ymd_hm("2017-09-01 12:01"), "America/Los_Angeles"),
    force_tz(ymd_hm("2017-09-03 12:01"), "America/Los_Angeles"),
    force_tz(ymd_hm("2017-09-17 12:01"), "America/Los_Angeles")
  ),
  y=c(20*60),
  label=c(
    "smoky", # I observed it
    "cleaned", # cleaned the panels
    "smoky" # according to nextdoor
  )
)

y_ticks <- seq(7*60, 20*60, 90)
p <- ggplot(rect) +
  ggtitle("Inverter Power (kW)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_rect(aes(xmin=hmin, xmax=hmax, ymin=vmin, ymax=vmax, fill=kW)) +
  scale_fill_gradient(low="blue", high="red") +
  scale_y_continuous(breaks = y_ticks, labels = minutes_to_timestr(y_ticks)) +
  annotate("text", x=annotations$x, y=annotations$y, label=annotations$label, angle=90)
print(p)