.PHONY: \
	crank \
	clean

BUILD=build
SOURCE=s

BUILDSYNC=rsync -azu --delete --exclude=.git --exclude='*~'

default: crank

crank:
	rm -fr $(BUILD)/*.html
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	perl crank --podpath=$(SOURCE) --buildpath=$(BUILD)
	$(BUILDSYNC) static/ $(BUILD)/static/
	cp $(SOURCE)/*.ico $(BUILD)/

clean:
	rm -fr $(BUILD)

# This is only useful for Andy
rsync:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@huggy.petdance.com:/srv/bobby
