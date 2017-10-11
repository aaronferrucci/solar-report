p1 <- ggplot_gtable(ggplot_build(p1))
p2 <- ggplot_gtable(ggplot_build(p2))

p2 <- gtable_add_cols(p2, p1$widths[8])
p2 <- gtable_add_cols(p2, p1$widths[9])

maxWidth <- unit.pmax(p1$widths, p2$widths)
p1$widths <- maxWidth
p2$widths <- maxWidth
grid.arrange(p2, p1)