
# After source("main.R"), source this script for a recent view.
datestr <- function(dt) {
  d <- day(dt)
  m <- month(dt)
  y <- year(dt) %% 100
  dstr <- sprintf("%s/%2d", m, d)
  return(dstr)
}
rect2 <- rect[rect$datetime > as.POSIXct("2018-07-31"),]

xmin <- min(rect2$hmin) - 24*60*60
xmax <- max(rect2$hmax) + 24*60*60
y_ticks <- seq(7*60, 20*60, 90)
x_ticks <- seq(ceiling_date(min(rect2$hmin), "day"), max(rect2$hmin), "1 days")

p1 <- ggplot(rect2) +
   ggtitle("Inverter Power (kW)") +
    theme(plot.title = element_text(hjust = 0.5)) +
    geom_rect(aes(xmin=hmin, xmax=hmax, ymin=vmin, ymax=vmax, fill=kW)) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
    scale_fill_gradient(low="blue", high="red") +
    scale_y_continuous(breaks = y_ticks, labels = minutes_to_timestr(y_ticks)) +
    scale_x_datetime(breaks = x_ticks, labels = datestr(x_ticks))
print(p1)

data <- getdata(dropfirst=TRUE)
data$date <- mdy(data$date)
data <- data[data$date > now() - ddays(8),]
p2_x_ticks <- seq(ceiling_date(min(rect2$hmin), "day"), max(rect2$hmin) + ddays(1), "1 days")
p2 <- ggplot(data) +
  ggtitle("Energy (kW)") +
  geom_line(aes(x=datetime, y=kW)) +
  theme(plot.title = element_text(hjust = 0.5)) + labs(x = "date") +
  scale_x_datetime(breaks = p2_x_ticks, labels = datestr(p2_x_ticks))
print(p2)
