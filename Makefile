.PHONY: \
	crank \
	clean

BUILD=build
SOURCE=s

default: crank

clean:
	rm -fr $(BUILD)
	rm -fr $(SOURCE)/*.tt2

crank: clean
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	cp -R static/* $(BUILD)/

test: crank
	prove t/html.t

# This is only useful for Andy
rsync:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@huggy.petdance.com:/srv/bobby
