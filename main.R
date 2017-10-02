library(ggplot2)
source("getdata.R")

data <- getdata()
# Remove 0-kW points, to show the trend of start/end times.
data <- data[data$kW > 0,]
# p <- ggplot(data) + geom_point(size=4, shape=15, aes(x=date(datetime), y = minute, col=kW)) + scale_colour_gradient(low = "blue", high="red")
rect <- to_rect(data)
p <- ggplot(rect) + geom_rect(aes(xmin=hmin, xmax=hmax, ymin=vmin, ymax=vmax, fill=kW)) + scale_fill_gradient(low="blue", high="red")
print(p)