library(gtable)
library(ggrepel)
plot <- function(rect, power, startendmaxp) {
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
    xlim(c(xmin, xmax))
  p2 <- ggplot(energy) +
    ggtitle("Energy per Day (kWh)") +
    theme(plot.title = element_text(hjust = 0.5), axis.title.x = element_blank(), axis.text.x = element_blank()) +
    # geom_point(aes(x=date, y=energy)) +
    geom_line(aes(x=date, y=energy)) +
    # ylim(0, max(energy$energy) * 1.05) +
    xlim(c(xmin, xmax))

  p3 <- ggplot(startendmaxp) +
    ggtitle("Max Power (kW)") +
    theme(plot.title = element_text(hjust = 0.5), axis.title.x = element_blank(), axis.text.x = element_blank()) +
    # geom_point(aes(x=date, y=maxp)) +
    geom_line(aes(x=date, y=maxp)) +
    # still covers the line, and I don't know how to do arrows
    # consider annotate("segment") and a rotated text label.
    # geom_label_repel(aes(x=date, y=maxp, label=startendmaxp$label), na.rm=T) +
    xlim(c(xmin, xmax))

  p1 <- ggplot_gtable(ggplot_build(p1))
  p2 <- ggplot_gtable(ggplot_build(p2))
  p3 <- ggplot_gtable(ggplot_build(p3))

  p2 <- gtable_add_cols(p2, p1$widths[8])
  p2 <- gtable_add_cols(p2, p1$widths[9])

  maxWidth <- unit.pmax(p1$widths, p2$widths, p3$widths)
  p1$widths <- maxWidth
  p2$widths <- maxWidth
  p3$widths <- maxWidth
  grid.arrange(p3, p2, p1, heights=c(1, 1, 3))
}

plotstart <- function(startend) {
  y_min <- floor(min(startend$start) / 5) * 5
  y_max <- ceiling(max(startend$start) / 5) * 5

  y_ticks <- seq(y_min, y_max, 10)
  p <- ggplot(startend) + geom_line(aes(x=date, y=start)) + scale_y_continuous(breaks=y_ticks, labels=minutes_to_timestr(y_ticks))
  print(p)
}

plotend <- function(startend) {
  y_min <- floor(min(startend$end) / 5) * 5
  y_max <- ceiling(max(startend$end) / 5) * 5

  y_ticks <- seq(y_min, y_max, 10)
  p <- ggplot(startend) + geom_line(aes(x=date, y=end)) + scale_y_continuous(breaks=y_ticks, labels=minutes_to_timestr(y_ticks))
  print(p)
}
