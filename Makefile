atom.xml: feed.sh $(shell find archive -name *.org)
		./feed.sh $@
