FROM ruby:2.4.1
MAINTAINER Andrey Marchenko "anvmarchenko@gmail.com"

ENV VERSION=2017-06-16

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_CTYPE C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Add yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install yarn, inotify-tools (for hot realoading), imagemagick
RUN apt-get update && apt-get install -y yarn imagemagick inotify-tools libnotify-bin

# foreman
RUN gem install foreman

ENV APP_HOME /opt/hamster-travel
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_PATH /box
ENV BUNDLE_BIN $BUNDLE_PATH/bin
