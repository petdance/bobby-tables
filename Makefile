.PHONY: \
	crank \
	clean

BUILD=build
SOURCE=s

BUILDSYNC=rsync -azu --delete --exclude=.git --exclude='*~'

default: crank

crank:
	rm -fr $(BUILD)
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	cp -R static/* $(BUILD)/
	find $(BUILD)/ -type f

clean:
	rm -fr $(BUILD)

# This is only useful for Andy
rsync:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@huggy.petdance.com:/srv/bobby
