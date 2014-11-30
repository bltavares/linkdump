archive = $(shell find archive -name *.org)

all: archive/index.html atom.xml

archive/index.html: archive.sh $(archive)
		./archive.sh $@

atom.xml: feed.sh $(archive)
		./feed.sh $@
.PHONY: all
