getdata <- function() {
  dir <- "../../solar/data"
  days <- list.files(dir, pattern='*.csv', recursive=T)

  data <- data.frame(date=character(0), time=character(0), kW=numeric(0), raw=integer(0))
  
  for (day in days) {
    lines <- readLines(file.path(dir, day))
    lines <- lines[-(1:3)]
    thisdata <- read.csv(text=lines)
    names(thisdata)[names(thisdata) == "power..kW."] <- "kW"
    data <- rbind(data, thisdata)
  }
  return(data)
}