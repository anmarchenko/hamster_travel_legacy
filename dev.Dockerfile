FROM ruby:2.4-slim
RUN apt-get update \
 && apt-get install -qq -y --no-install-recommends \
    libgmp3-dev \
    git-core \
    bison \
    build-essential \
    curl \
    wget \
    zlib1g-dev \
    libreadline-dev \
    libcurl4-openssl-dev \
    build-essential \
    git \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    ssh \
    imagemagick \
    chrpath \
    libxft-dev \
    libfreetype6 \
    libfreetype6-dev \
    libfontconfig1 \
    libfontconfig1-dev \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

ENV APP_HOME /opt/hamster-travel
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_PATH /box
ENV BUNDLE_BIN $BUNDLE_PATH/bin
