FROM phusion/passenger-ruby23:latest
MAINTAINER Andrey Marchenko "anvmarchenko@gmail.com"

# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV production
ENV PASSENGER_MAX_POOL_SIZE 4
ENV PASSENGER_MIN_INSTANCES 2

# upgrade OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get install -y imagemagick libpq-dev

RUN gem install bundler

# Install bundle of gems
WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install

# Add the Rails app
COPY . /home/app/webapp
RUN chown -R app:app /home/app/webapp
WORKDIR /home/app/webapp
RUN rake assets:precompile

# Expose Nginx HTTP service
EXPOSE 80

# Start Nginx
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
COPY config/webapp.conf /etc/nginx/sites-enabled/webapp.conf
COPY config/rails-env.conf /etc/nginx/main.d/rails-env.conf

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/app/webapp/log/* /home/app/webapp/tmp/* /home/app/webapp/.git

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
