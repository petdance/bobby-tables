Wer ist Bobby Tables?
======================

<p>
<a href="http://xkcd.com/327/"><img src="img/xkcd.png" alt="xkcd Bobby Tables Cartoon" height="205" width="666" /></a>
<a href="http://xkcd.com/327/">From the comic strip xkcd</a><br />
<b>School</b>: "Hallo, hier ist die Schule Ihres Sohnes. Wir haben im Moment Computerprobleme."<br />
<b>Mom</b>: "Oh! Hat er etwas kaputt gemacht?"<br />
<b>School</b>: "Irgendwie. Haben Sie Ihren Sohn wirklich Robert'); DROP TABLE Students;-- genannt ?"<br />
<b>Mom</b>: "Oh. Ja. Wir rufen ihn Bobby Tables"<br />
<b>School</b>: "Nun, wir haben die Schülerdaten des ganzen Jahres verloren. Ich hoffe, Sie sind jetzt glücklich."<br />
<b>Mom</b>: "Und ich hoffe, Sie haben dabei gelernt, das Sie ihre Datenbankeingaben bereinigen sollten."<br />
(titel text: "Ihre Tochter heißt: Hilfe, ich bin in ainer Führerscheinfabrik gefangen.")
</p>

Wie kann man Bobby Tables verhindern?
=====================================

Es gibt nur einen Weg um Bobby Table Angriffe zu verhindern

* Erstelle keine SQL-Anweisungen, die externe Daten verwenden
* Benutze parametrisierte SQL Aufrufe

Das ist alles. Versuche nicht, ungültige Zeichen zu escapen. Versuche es nicht selbst. Lerne, wie man parametrisierte Anweisungen benutzt. Immer. Wirklich immer!

Der Comic enthält einen schwerwiegenden Fehler. Die Antwort ist nicht "bereinige deine Datenbankeingaben", denn das ist fehleranfällig.

Beispiele
=========

In der linken Seitenleiste findest Du Beispiele für deine Sprache.

weitere Verweise
================

* [SQL Injection Myths and Fallacies](http://www.slideshare.net/billkarwin/sql-injection-myths-and-fallacies)
* [http://www.schneier.com/blog/archives/2008/10/how_to_write_in.html](http://www.schneier.com/blog/archives/2008/10/how_to_write_in.html)
* [http://st-curriculum.oracle.com/tutorial/SQLInjection/](http://st-curriculum.oracle.com/tutorial/SQLInjection/)

Patches wilkommen
=================

Fehlt eine Sprache, die Du hier gerne sehen würdest? Lass es mich wissen, wenn Du Updates oder Ergänzungen zu einer der Methoden hast.

* Forke  [bobby-tables repository at github](http://github.com/petdance/bobby-tables), mach deine Änderungen und sende mir einen Pull-Request.
* Wenn Du einen Fehler findest, kannst Du ihn über den Issue tracker [issue tracker](http://github.com/petdance/bobby-tables/issues) melden.
* Sende eine E-Mail an mich, Andy Lester, via andy at petdance.com.

Übersetzungen sind ebenfalls gerne gesehen
==========================================

Hilf mit diese Seite zu übersetzen. Es gibt nur 100 Sätz. Programmieren ist nicht notwendig.

Weitere Informationen findest Du im [bobby-tables repository bei github](http://github.com/petdance/bobby-tables#readme).

To do
=====

* Erkläre, warum man keinen Code mit externen Daten verwenden sollte.
* Beschreibe den potentiellen Geschwindigkeitsgewinn bei der Verwendung von prepared statements.

Dank
======

Danke an die folgenden Leute für ihre Unterstützung:

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
