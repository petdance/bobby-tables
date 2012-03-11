This project is the source code for <http://bobby-tables.com/>, plus the
Perl code that converts it from Markdown format into HTML and uploads
it to the server.

Repository layout
-----------------

* s/
    * page bodies in Markdown format
* tt/
    * templates in Template::Toolkit format
* static/
    * images and styles
* share/locale
    * translations in gettext format
* t/
    * tests
* build/ (Not stored)
    * output

Requirements
------------

GNU bash, make, gettext-runtime, gettext-tools.

Perl and additional CPAN modules.

For building:

* File::Slurp
* libintl-perl (for Locale::Messages, Locale::TextDomain)
* Locale::Maketext::Lexicon (for xgettext.pl)
* Template
* Text::Markdown

For testing:

* Test::HTML::Lint

Contributing page content
-------------------------

1. Modify templates or page bodies. New pages have to be registered in the file `crank`.
2. Run `make` to build the site and inspect the result in the `build` directory.
3. Run `make test` to check for HTML errors.
4. Commit/publish changes, see `s/index.md`.

Contributing translations
-------------------------

1. Run `make messages`.
2. Skip this step if you just amend a translation. If you need to start a new
language, copy `share/locale/com.bobby-tables.pot` to
`share/locale/xx_YY/LC_MESSAGES/com.bobby-tables.po`, but substitute `xx` for
the appropriate
[language code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
and `YY` for the
[territory code](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
(Alternatively to copying, use the command `msginit`.) Naming convention
examples:

        sv_SE.po    standard Swedish
        pt_BR.po    Brazilian Portuguese

3. Edit the PO file. [Lokalize (formerly KBabel)](http://l10n.kde.org/tools/)
is excellent, [Poedit](http://www.poedit.net/) is good. Any text editor
supporting UTF-8 can handle PO files, but it will not be as convenient.
4. Continue at step 2. of the previous section.
