Repository layout
-----------------

    s               page bodies in Textile format
    tt              templates in Template::Toolkit format
    static          images and styles
    share/locale    translations in gettext format
    t               tests
    build           output

Requirements
------------

Perl and additional CPAN modules.

For building:

    File::Slurp
    Locale::Maketext::Lexicon
    Locale::Maketext
    Template
    Text::Textile

For testing:

    Test::HTML::Lint

Contributing page content
-------------------------

1. Modify templates or page bodies. New pages have to be registered in the file `crank`.
2. Run `make` to build the site and inspect the result in the `build` directory.
3. Run `make test` to check for HTML errors.
4. Commit/publish changes, see `s/index.textile`.

Contributing translations
-------------------------

1. Run `make messages`.
2. Skip this step if you just amend a translation. If you need to start a new
language, copy `share/locale/messages.pot` to `share/locale/xx_YY.po`, but
substitute `xx` for the appropriate
[language code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
and `YY` for the
[territory code](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
Naming convention examples:

        sv_SE.po    standard Swedish
        pt_BR.po    Brazilian Portuguese

3. Edit the PO file. [Lokalize (formerly KBabel)](http://l10n.kde.org/tools/)
is excellent, [Poedit](http://www.poedit.net/) is good. Any text editor
supporting UTF-8 can handle PO files, but it will not be convenient.
4. Run `LANG=xx_YY make` to build the site with a certain translation and
inspect the result in the `build` directory.
5. Continue at step 3. of the previous section.

Note to experienced translators: compiled gettext (MO) files are not used in
this project.
