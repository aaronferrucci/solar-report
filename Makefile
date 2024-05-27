DATADIR := "../../solar/data"
OUTFILE := all.csv
all: header filter
# choose one file (arbitrary), extract the header
# -print -quit exits early, avoids a 'broken pipe' error from R
header:
	@find $(DATADIR) -name '*.csv' -print -quit | xargs grep 'date, time' > $(OUTFILE)

.PHONY: all header filter
filter:
	@find $(DATADIR) -name '*.csv' | \
	  sort -n | \
	  tail +2 | \
	  xargs sed '/serial number/d; /firmware version/d; /ip address/d; /date, time, power/d' >> \
	  $(OUTFILE)

clean:
	rm -f $(OUTFILE)
