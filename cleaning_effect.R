cleaning_effect <- energy[energy$date >= as.Date("2025-11-26 12:00:00") & energy$date <= as.Date("2025-12-17 12:00:00"),]
cleaning_effect$clean <- "dirty"
cleaning_effect[cleaning_effect$date > as.Date("2025-12-07 12:00:00"), ]$clean <- "clean"
p <- ggplot(cleaning_effect, aes(x=date, y=energy, stat="identity", fill=clean)) +
  geom_col() +
  ylab("energy (Wh)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) +
  scale_x_continuous(breaks=seq(from=as_datetime("2025-11-26 12:00:00"), to=as_datetime("2025-12-16 12:00:00"), by="2 days"))
p