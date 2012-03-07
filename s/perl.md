Perl
====

Perl hat mit[DBI](http://search.cpan.org/dist/DBI), das über [CPAN](http://search.cpan.org) verfügbar ist, eine Möglichkeit um parametrisierte SQL Anweisungen zu unterstützen. Die Methoden <code class="inline">do</code> und <code class="inline">prepare</code> unterstützen Platzhalter für die meisten Datenbanktreiber. Zum Beispiel:


    $sth = $dbh->prepare("SELECT * FROM users WHERE email = ?");
    foreach my $email (@emails) {
        $sth->execute($email);
        $row = $sth->fetchrow_hashref;
        [...]
    }

Für die Parametrisierung kannst Du keine Bezeichner verwenden (Tabellen- oder Spaltennamen), weshalb Du dafür die Methode <tt>quote\_identifier()</tt> von DBI verwenden musst:

    # Stelle sicher, das der von uns verwendete Tabellenname sicher ist:
    my $quoted_table_name = $dbh->quote_identifier($table_name);

    # Nimm an, das @cols eine Liste von Spaltennamen enthält, die Du holen willst:
    my $cols = join ',', map { $dbh->quote_identifier($_) } @cols;

    my $sth = $dbh->prepare("SELECT $cols FROM $quoted_table_name ...");

Du kannst aber auch mit Hilfe von [DBIx::Class](http://p3rl.org/DBIx::Class) und [SQL::Abstract](http://p3rl.org/SQL::Abstract) sowie weiteren Modulen deine benötigten SQL-Anweisungen generieren lassen.

Was ist der Taint mode?
-----------------------

Der Taint-Modus ist ein Set von speziellen Sicherheitsprüfungen, die Perl mit Eingabedaten deines Programmes aus externen Quellen durchführt. Die Eingabedaten sind als tainted (nicht vertrauenswürdig) markiert und können nicht in Befehlen, mit denen Du dir selbst ins Knie schießen kannst, verwendet werden. Eine detailiertere Erklärung zum Taint-Modus findest Du unter [the perlsec manpage](http://perldoc.perl.org/perlsec.html).

Aufruf des Taint-Modus:

    # von der Kommandozeile
    perl -T program.pl

    # am Beginn deines Skripts
    #!/usr/bin/perl -T

Wenn Deine Anwendung eine oder mehrere Taint-Überprüfungen auslöst, wird sie mit einer Fatal Error Meldung abbrechen. Zu Testzwecken wird '-t' Warnungen anstatt von Fatal Errors anzeigen. '-t' ist kein Ersatz für '-T'.

To do
-----

Erkläre, wie DBI den taint mode, eingehend und ausgehend, unterstützt.
