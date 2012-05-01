Who is Bobby Tables?
====================

[From the webcomic _xkcd_](http://xkcd.com/327/)

<a href="http://xkcd.com/327/"><img src="/img/xkcd.png" alt="xkcd Bobby Tables Cartoon" height="205" width="666" /></a>

<br clear="right">

**School**: Hi, this is your son's school. We're having some computer trouble.

**Mom**: Oh, dear -- Did he break something?

**School**: In a way. Did you really name your son `Robert'); DROP TABLE Students;--`?

**Mom**: Oh. Yes. Little Bobby Tables we call him.

**School**: Well, we've lost this year's student records. I hope you're happy.

**Mom**: And I hope you've learned to sanitize your database inputs.


Why did Bobby's school lose their records?
==========================================

The school apparently stores the names of their students in a table called Students. When a new student arrives, the school inserts his/her name into this table. The code doing the insertion might look as follows:

    $sql = "INSERT INTO Students (Name) VALUES ('" . $studentName . "');";
    execute_sql($sql);

The first line creates a string containing an SQL INSERT statement. The content of the `$studentName` variable is glued into the SQL statement. The second line sends the resulting SQL statement to the database. The pitfall of this code is that outside data, in this case the content of `$studentName`, becomes part of the SQL statement.

First let's see what the SQL statement looks like if we insert a student named John:

    INSERT INTO Students (Name) VALUES ('John');

This does exactly what we want: it inserts John into the Students table.

Now we insert little Bobby Tables, by setting `$studentName` to `Robert'); DROP TABLE Students;--`. The SQL statement becomes:

    INSERT INTO Students (Name) VALUES ('Robert'); DROP TABLE Students;--');

This inserts Robert into the Students table. However, the INSERT statement is now followed by a DROP TABLE statement which removes the entire Students table. Ouch!


How to avoid Bobby Tables
=========================

There is only one way to avoid Bobby Tables attacks

* Do not create SQL statements that include outside data.
* Use parameterized SQL calls.

That's it. Don't try to escape invalid characters. Don't try to do it yourself. Learn how to use parameterized statements. Always, every single time.

The strip gets one thing crucially wrong. The answer is not to "sanitize your database inputs" yourself. It is prone to error.

Examples
========

See the sidebar to the left for your specific language.

Other random resources
======================

* [SQL Injection Myths and Fallacies](http://www.slideshare.net/billkarwin/sql-injection-myths-and-fallacies)
* [How to Write Injection-Proof SQL](http://www.schneier.com/blog/archives/2008/10/how_to_write_in.html)
* [Defending Against SQL Injection Attacks](http://download.oracle.com/oll/tutorials/SQLInjection/index.htm)

Patches welcome
===============

Don't see a language that you'd like to see represented? Please let me know if you have updates or additions through one of these methods, in decreasing order of preference.

* Fork the [bobby-tables repository at github](http://github.com/petdance/bobby-tables), make your changes, and send me a pull request.
* Add an issue in the [issue tracker](http://github.com/petdance/bobby-tables/issues).
* Email me, Andy Lester, at andy at petdance.com.

Translations also welcome
=========================

Help translate this site! There are less than 200 phrases. No programming necessary.

See the instructions at the [bobby-tables repository at github](http://github.com/petdance/bobby-tables#readme).

To do
=====

* Explain why creating code from outside data is bad.
* Potential speed win when reusing prepared statements.

Thanks
======

Thanks to the following folks for their contributions:

* [Kim Christensen](http://www.smukkekim.dk)
* Kirk Kimmel
* Nathan Mahdavi
* [Hannes Hofmann](http://www5.informatik.uni-erlangen.de/en/our-team/hofmann-hannes)
* [Mike Angstadt](http://www.mangst.com)
* [Peter Ward](http://identi.ca/flowblok/)
* [David Wheeler](http://justatheory.com)
* Scott Rose
* Erik Osheim
* Russ Sivak
* [Iain Collins](http://iaincollins.com)
* Kristoffer Sall Hansen
* Jeff Emminger
* [Travis Swicegood](http://www.travisswicegood.com/)
* [Will Coleda](http://www.coleda.com/users/coke/)
* Kai Baesler
* Mike Markley
* [Michael Schwern](http://schwern.net/)
* [Jeana Clark](http://jeanaclark.org/)
* [Lars Dɪᴇᴄᴋᴏᴡ](http://search.cpan.org/~daxim/)
* [Jani Hur](http://www.jani-hur.net)
* [Sven van Haastregt](http://www.liacs.nl/home/svhaastr/)
