Perl
====

Perl's [DBI](http://search.cpan.org/dist/DBI), available on the [CPAN](http://search.cpan.org), supports parameterized SQL calls.  Both the <code class="inline">do</code> method and <code class="inline">prepare</code> method support parameters ("placeholders", as they call them) for most database drivers. For example:


    $sth = $dbh->prepare("SELECT * FROM users WHERE email = ?");
    foreach my $email (@emails) {
        $sth->execute($email);
        $row = $sth->fetchrow_hashref;
        [...]
    }

However, you can't use parameterization for identifiers (table names, column names) so you need to use DBI's <tt>quote\_identifier()</tt> method for that:

    # Make sure a table name we want to use is safe:
    my $quoted_table_name = $dbh->quote_identifier($table_name);

    # Assume @cols contains a list of column names you need to fetch:
    my $cols = join ',', map { $dbh->quote_identifier($_) } @cols;

    my $sth = $dbh->prepare("SELECT $cols FROM $quoted_table_name ...");

You could also avoid writing SQL by hand by using [DBIx::Class](http://p3rl.org/DBIx::Class), [SQL::Abstract](http://p3rl.org/SQL::Abstract) etc to generate your SQL for you programmatically.

What is Taint mode?
-------------------

Taint mode is a special set of security checks that Perl performs on data input into your program from external sources. The input data is marked as  tainted (untrusted) and may not be used in commands that would allow you to shoot yourself in the foot. See [the perlsec manpage](http://perldoc.perl.org/perlsec.html) for a detailed breakdown of what taint mode tracks.

To invoke taint mode:

    # From the command line
    perl -T program.pl

    # At the top of your script
    #!/usr/bin/perl -T

When your script trips one of the taint checks your application will issue a fatal error message. For testing purposes '-t' will issue warnings instead of fatal errors. '-t' is not a substitute for '-T'.

To do
-----

Explain how DBI supports taint mode, both inbound and outbound.
