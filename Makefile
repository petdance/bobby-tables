.PHONY: \
	crank \
	clean \
	prereq

BUILD=build
SOURCE=s

default: crank

prereq:
	perl ./modules.pl

clean:
	rm -fr $(BUILD)
	rm -fr $(SOURCE)/*.tt2

crank: prereq clean
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	LANG=C perl crank.pl --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	cp -R static/* $(BUILD)/

test: crank
	prove t/*.t

# This is only useful for Andy
install:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@alex.petdance.com:/srv/bobby
