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
