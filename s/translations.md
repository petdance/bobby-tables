# Translations

The following natural languages are supported on bobby-tables.com:

* [English](http://bobby-tables.com/) (native)
* [German](http://bobby-tables.com/de_DE/) (fairly current)
* [Russian](http://bobby-tables.com/ru_RU/) (just starting)

We'd love to have translations into other languages as well.  Please
contact the
[bobby-tables mailing list](https://groups.google.com/forum/#!forum/bobby-tables)
and ask a team member about how you can help.

# Contributing translations

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

4. Run the normal `make` step.

# Guidelines for translations

* Become familiar with the source mark-up language "Markdown" used for
 producing the rendered HTML. The backtick (\`) is an important piece
 of syntax pertaining to translation, it indicates code, e.g. a
 variable name, and code is not translated, i.e. copy the source text
 into the target language as-is. Indented paragraphs are also code.
 Translate only comments in such code blocks.

* To find out where a piece of English is from to see the context,
run `ack -a 'source text goes here'`. Most of the source text is
in directory `s/`. Run `make clean` first to avoid duplicates in
build files. (If you don't have [ack](http://betterthangrep.com)
you can use `grep -R`.

* You can check your progress by running `make l10n-status`.

Apart from that, the normal rules for any translation apply:

* Don't translate literally or word-by-word, instead capture the
essence of each sentence/paragraph and reformulate it so it reads
naturally. If you have to merge or rearrange sentence parts, do it.

* Avoid keeping key words/technical jargon in English, consult the
standard literature for existing translations of key words. (Software
vendors such as Microsoft and KDE publish shared translation tables,
import those into your PO editor, too.) In case you find no good
translation, use your imagination and put yourself into the position
of a member of your potential audience: is the sentence still
understandable? If not, add a parenthetical remark to the key word.

* It can happen that source text is wrong in some way (typos, factual
errors). This should be improved first in a separate patch, independent
from your translation. Fix it yourself, and if not possible (e.g.
because the English text is ambiguous), use `git annotate` to find
out who wrote it and ask for clarification.
