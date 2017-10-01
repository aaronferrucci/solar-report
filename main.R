library(ggplot2)
source("getdata.R")

data <- getdata()

oneday <- data[month(data$datetime) == 9 & day(data$datetime) == 27,]
p <- ggplot(oneday) + geom_line(aes(x=datetime, y=kW))
print(p)