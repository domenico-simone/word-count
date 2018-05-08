SRCDIR := data
TMPDIR := processed_data
RESDIR := results

SRCS = $(wildcard $(SRCDIR)/*.txt)

OBJS = $(patsubst $(SRCDIR)/%.txt,$(TMPDIR)/%.dat,$(SRCS))
OBJS += $(patsubst $(SRCDIR)/%.txt,$(RESDIR)/%.png,$(SRCS))
OBJS += $(RESDIR)/results.txt
DATA = $(patsubst $(SRCDIR)/%.txt,$(TMPDIR)/%.dat,$(SRCS))

all: $(OBJS)

.PRECIOUS: $(TMPDIR)/%.dat

$(TMPDIR)/%.dat: $(SRCDIR)/%.txt
	./source/wordcount.py $<  $@

$(RESDIR)/%.png: $(TMPDIR)/%.dat
	./source/plotcount.py $<  $@

$(RESDIR)/results.txt: $(DATA)
	./source/zipf_test.py $^ > $@

#Make the Directories
directories:
	@mkdir -p $(TMPDIR)
	@mkdir -p $(RESDIR)

#Clean only Objecst
clean:
	@$(RM) -rf $(TMPDIR)
	@$(RM) -rf $(RESDIR)

.PHONY: clean directories