right_0_pad <- function(num) {
  num <- paste0(ifelse(num < 10, "0", ""), num)
  return(num)
}

minutes_to_timestr <- function(mins) {
  ampm <- ifelse(mins > 12*60, "PM", "AM")
  hours <- as.integer(mins / 60)
  hours <- ifelse(hours > 12, hours - 12, hours)
  mins <- mins %% 60
  mins <- right_0_pad(mins)
  return(paste0(hours, ':', mins, ' ', ampm))
}