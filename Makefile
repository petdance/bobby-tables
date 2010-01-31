.PHONY: \
	crank \

BUILD=build
SOURCE=s

default: crank

crank:
	rm -fr $(BUILD)
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	cp -R static/* $(BUILD)/

# This is only useful for Andy
rsync:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@huggy.petdance.com:/srv/bobby
