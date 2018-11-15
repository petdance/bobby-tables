FROM debian:buster-slim

## Install perl, tooling, and dependencies for perl modules
RUN apt-get update && apt-get install -y \
    cpanminus \
    gcc \
    libtidy-dev \
    make \
    perl \
  && rm -fr /var/lib/apt/lists/*

# Install necessary perl modules
RUN cpanm File::Slurp
RUN cpanm Markdent
RUN cpanm Template
RUN cpanm Test::HTML::Tidy5

WORKDIR /app
CMD ["make"]
