FROM ruby:2.4.1
MAINTAINER Andrey Marchenko "anvmarchenko@gmail.com"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_CTYPE C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

ENV APP_HOME /opt/hamster-travel
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_PATH /box
ENV BUNDLE_BIN $BUNDLE_PATH/bin
