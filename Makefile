.PHONY: \
	crank \
	clean \
	prereq

BUILD=build
SOURCE=s
LOCALE=share/locale
TEXTDOMAIN=com.bobby-tables
POTEMPLATE=$(LOCALE)/$(TEXTDOMAIN).pot

default: crank

prereq:
	perl ./modules.pl

clean:
	rm -fr $(BUILD)
	rm -fr $(SOURCE)/*.tt2
	rm -fr $(POTEMPLATE)
	rm -fr $(LOCALE)/*/LC_MESSAGES/$(TEXTDOMAIN).mo

crank: prereq clean messages
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	# force English for top directory
	LANG=C perl crank.pl --sourcepath=$(SOURCE) --buildpath=$(BUILD)
	# other languages in subdirectories
	# that substr is ugly, but nested evals of basename/dirname are worse
	for pofile in $(LOCALE)/*/LC_MESSAGES/$(TEXTDOMAIN).po ; do \
	    language=`perl -e'print substr(shift,13,5)' $$pofile` ; \
	    mkdir -p $(BUILD)/$$language || true > /dev/null 2>&1 ; \
	    LANG=$$language perl crank.pl --sourcepath=$(SOURCE) --buildpath=$(BUILD)/$$language ; \
	    done
	cp -R static/* $(BUILD)/

test: crank
	prove t/*.t

messages:
	# wrap markdown paragraphs into TT loc fragments
	for markdownfile in $(SOURCE)/*.md; do \
	    perl -lne'BEGIN {$$/ = "\n\n";}; print "[% |loc %]$${_}[% END %]\n" if $${_}' \
	    < $$markdownfile > $$markdownfile.tt2 ; done
	# extract string literals to po template
	xgettext.pl -u -g -P tt2 -P perl -o $(POTEMPLATE) tt/* $(SOURCE)/*.tt2 crank.pl
	# update po/mo files
	for pofile in $(LOCALE)/*/LC_MESSAGES/$(TEXTDOMAIN).po ; do \
	    msgmerge -U -F -q $$pofile $(POTEMPLATE) ; \
	    msgfmt $$pofile -o `dirname $$pofile`/$(TEXTDOMAIN).mo ; done

l10n-stats: messages
	for pofile in $(LOCALE)/*/LC_MESSAGES/$(TEXTDOMAIN).po ; do \
	    echo -n "`perl -e'print substr(shift,13,5)' $$pofile`: " ; \
	    LANG=C msgfmt --statistics $$pofile -o /dev/null ; done

# This is only useful for Andy
rsync:
	rsync -azu -e ssh --delete --verbose \
	    $(BUILD)/ andy@huggy.petdance.com:/srv/bobby
