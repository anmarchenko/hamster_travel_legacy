FROM ruby:2.4.1
MAINTAINER Andrey Marchenko "anvmarchenko@gmail.com"

ENV RAILS_ENV production

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Add yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install yarn
RUN apt-get update && apt-get install -y yarn

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 5 --retry 3 --deployment --without development test
RUN passenger-config install-standalone-runtime && passenger-config build-native-support

COPY . /app

RUN yarn install
RUN rake assets:precompile
RUN rm -rf node_modules

EXPOSE 3000
ENTRYPOINT ["bundle"]
CMD ["exec", "passenger", "start", "--max-pool-size=2"]
