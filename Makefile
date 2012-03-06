.PHONY: \
	crank \
	clean

BUILD=build
SOURCE=s
LOCALE=share/locale
POTEMPLATE=$(LOCALE)/messages.pot

default: crank

clean:
	rm -fr $(BUILD)
	rm -fr $(SOURCE)/*.tt2
	rm -fr $(POTEMPLATE)

crank: clean messages
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	# force English for top directory
	LANG=C perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	# other languages in subdirectories
	for pofile in $(LOCALE)/*.po ; do \
	    language=`basename $$pofile .po` ; \
	    mkdir -p $(BUILD)/$$language || true > /dev/null 2>&1 ; \
	    LANG=$$language perl crank --sourcepath=$(SOURCE) --buildpath=$(BUILD)/$$language ; \
	    done
	cp -R static/* $(BUILD)/

test: crank
	prove t/html.t

messages:
	# wrap textile paragraphs into TT loc fragments
#	for textilefile in $(SOURCE)/*.textile ; do \
#	    perl -lne'BEGIN {$$/ = "\n\n";}; print "[% |loc %]$${_}[% END %]\n"' \
#	    < $$textilefile > $$textilefile.tt2 ; done
        # extract string literals to po template
#	xgettext.pl -g -u -P tt2 -o $(POTEMPLATE) tt/* $(SOURCE)/*
	# update po files
#	for pofile in $(LOCALE)/*.po ; do \
#	    msgmerge -U $$pofile $(POTEMPLATE) ; done

# This is only useful for Andy
rsync:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@huggy.petdance.com:/srv/bobby
