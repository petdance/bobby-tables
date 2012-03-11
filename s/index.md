Who is Bobby Tables?
====================

[From the webcomic _xkcd_](http://xkcd.com/327/)

<a href="http://xkcd.com/327/"><img src="img/xkcd.png" alt="xkcd Bobby Tables Cartoon" height="205" width="666" /></a>

<br clear="right">

**School**: Hi, this is your son's school. We're having some computer trouble.

**Mom**: Oh, dear -- Did he break something?

**School**: In a way. Did you really name your son `Robert'); DROP TABLE Students;--`?

**Mom**: Oh. Yes. Little Bobby Tables we call him.

**School**: Well, we've lost this year's student records. I hope you're happy.

**Mom**: And I hope you've learned to sanitize your database inputs.


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

To do
=====

* Explain why creating code from outside data is bad.
* Potential speed win when reusing prepared statements.

Thanks
======

Thanks to the following folks for their contributions:

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
* [Michael Schwern](http://schwern.dreamhosters.com/)
* [Jeana Clark](http://jeanaclark.org/)
* [Lars Dɪᴇᴄᴋᴏᴡ](http://search.cpan.org/~daxim/)
* [Jani Hur](http://www.jani-hur.net)
