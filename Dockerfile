FROM ruby:2.4.1
MAINTAINER Andrey Marchenko "anvmarchenko@gmail.com"

ENV RAILS_ENV production

RUN apt-get update && apt-get install -y nodejs

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 5 --retry 3 --deployment --without development test
RUN passenger-config install-standalone-runtime && passenger-config build-native-support

COPY . /app

RUN chown -R www-data /app
USER www-data

RUN rake assets:precompile

EXPOSE 3000
ENTRYPOINT ["bundle"]
CMD ["exec", "passenger", "start", "--max-pool-size=2"]
