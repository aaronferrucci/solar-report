library(ggplot2)
library(plyr)
library(grid)
library(gridExtra)
source("util.R")
source("getdata.R")

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
    force_tz(ymd_hm("2017-09-17 12:01"), "America/Los_Angeles")
  ),
  y=c(20*60),
  label=c(
    "smoky", # I observed it
    "cleaned", # cleaned the panels
    "smoky" # according to nextdoor
  )
)
xmin <- min(rect$hmin) - 24*60*60
xmax <- max(rect$hmax) + 24*60*60
y_ticks <- seq(7*60, 20*60, 90)
p1 <- ggplot(rect) +
  ggtitle("Inverter Power (kW)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_rect(aes(xmin=hmin, xmax=hmax, ymin=vmin, ymax=vmax, fill=kW)) +
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
  scale_fill_gradient(low="blue", high="red") +
  scale_y_continuous(breaks = y_ticks, labels = minutes_to_timestr(y_ticks)) +
  xlim(c(xmin, xmax)) +
  annotate("text", x=annotations$x, y=annotations$y, label=annotations$label, angle=90)
p2 <- ggplot(energy) +
  ggtitle("Energy per Day (kWh)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_point(aes(x=date, y=energy)) +
  geom_line(aes(x=date, y=energy)) +
  xlim(c(xmin, xmax)) +
  ylim(0, max(energy$energy) * 1.05)
grid.arrange(p2, p1)
