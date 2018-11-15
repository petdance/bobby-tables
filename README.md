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

GNU bash, make, gettext-runtime, gettext-tools.

Perl and additional CPAN modules.

For building:

* File::Slurp
* Markdent
* Template

For testing:

* Test::HTML::Tidy5

Alternatively a Dockerfile is provided which can run the necessary make tasks
in a container.

    docker build -t bobby-tables .                      # Builds the container
    docker run --rm -v $PWD:/app bobby-tables           # Builds the site to the build/ directory
    docker run --rm -v $PWD:/app bobby-tables make test # Runs the tests

Contributing page content
-------------------------

1. Modify templates or page bodies. New pages have to be registered in the file `crank`.
2. Run `make` to build the site and inspect the result in the `build` directory.
3. Run `make test` to check for HTML errors.
4. Commit/publish changes, see `s/index.md`.
