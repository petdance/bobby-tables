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
* t/
    * tests
* build/ (Not stored)
    * output

Requirements
------------

Perl and additional CPAN modules.

For building:

* File::Slurp
* Template
* Text::Markdown

For testing:

* Test::HTML::Lint

Contributing page content
-------------------------

# Modify templates or page bodies. New pages have to be registered in the file `crank`.
# Run `make` to build the site and inspect the result in the `build` directory.
# Run `make test` to check for HTML errors.
# Commit/publish changes, see `s/index.md`.

Translations
------------

bobby-tables.com used to have a German translation, but that's been
removed.  The translation was too out of date, and caused maintenance
problems.  The source is available under a Creative Commons license and
can be translated.
