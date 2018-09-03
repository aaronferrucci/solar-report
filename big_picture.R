library(ggplot2)
library(plyr)
library(grid)
library(gridExtra)
source("util.R")
source("getdata.R")

facet_label_fn <- function(m_b_0) {
  return(sprintf("%s", m_b_0))
}

data <- getdata(dropfirst=TRUE)
data$date <- mdy(data$date)
data$year <- year(data$date)
data$month <- month(data$date, label=T, abbr=T)
data$day <- day(data$date)
data$minute_in_month <- 3600*data$day + 60*hour(data$datetime) + minute(data$datetime)
# data$month_base_0 <- 12*data$year + data$month - 12*year(min(data$date)) - month(min(data$date))
# data$month_base_0 <- sprintf("%02d/%d", data$month, data$year)
data$month_year <- sprintf("%s\n%d", data$month, data$year)
start_year <- year(min(data$date))
start_month <- month(min(data$date))

data$months <- 12*data$year + month(data$date) - 12*start_year - start_month

facet_labels <- data.frame(months = unique(data$months))
facet_labels$month_num <- month((start_month - 1 + facet_labels$months) %% 12 + 1, label=F)
facet_labels$month_name <- month(facet_labels$month_num, label=T, abbr=T)
facet_labels$year <- start_year + as.integer((-1 + start_month + facet_labels$months) / 12)
facet_labels$label <- as.factor(sprintf("%s\n%d", facet_labels$month_name, facet_labels$year))
facet_labels$label <- reorder(facet_labels$label, facet_labels$months)
data$facet_label <- facet_labels$label[data$months + 1]

p3_x_ticks <- seq(1, 31, 5)

p3 <- ggplot(data) +
  ggtitle("Energy (kW) by day, per month") +
  geom_line(aes(x=minute_in_month, y=kW)) +
  facet_grid(facet_label ~ ., as.table=T) +
  theme(plot.title = element_text(hjust = 0.5)) + labs(x = "day") +
  scale_x_continuous(breaks = p3_x_ticks * 3600, labels=p3_x_ticks)

print(p3)
