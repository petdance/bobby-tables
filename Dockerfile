FROM perl

# Install necessary perl modules
RUN cpanm File::Slurp
RUN cpanm Locale::Messages
RUN cpanm Locale::TextDomain
RUN cpanm Locale::Maketext::Lexicon
RUN cpanm Template
RUN cpanm Text::Markdown
RUN cpanm URI
RUN cpanm Test::HTML::Lint --force

# Install cli tools used by makefile
RUN apt-get update && apt-get install -y \
    gettext \
    locales

# Uncomment any lines starting with our desired locales then generate them
RUN sed -i 's/^# \(de_DE\|es_AR\|ru_RU\)/\1/' /etc/locale.gen && locale-gen

WORKDIR /app
CMD ["make"]
