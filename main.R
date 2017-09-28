dir <- "../../solar/data"
years <- Sys.glob(file.path(dir, "*"))
months <- lapply(years, FUN=function(y) Sys.glob(file.path(y, "*")))
days <- lapply(months[[1]], FUN=function(m) Sys.glob(file.path(m, "*")))