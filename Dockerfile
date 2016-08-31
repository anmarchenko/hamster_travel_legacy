FROM phusion/passenger-ruby22:0.9.18
MAINTAINER Andrey Marchenko "anvmarchenko@gmail.com"

# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV production

# upgrade OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get install -y imagemagick libpq-dev

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Expose Nginx HTTP service
EXPOSE 80

# Start Nginx
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
ADD config/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD config/rails-env.conf /etc/nginx/main.d/rails-env.conf

RUN gem install bundler

# Install bundle of gems
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install --jobs 5 --retry 3 --deployment --without tests

# Add the Rails app
ADD . /home/app/webapp
RUN chown -R app:app /home/app/webapp
WORKDIR /home/app/webapp
RUN rake assets:precompile

# Add cron file in the cron directory
ADD ./crontabs/exchange_rates.crontab /etc/cron.d/exchange_rates
RUN chmod 0644 /etc/cron.d/exchange_rates
RUN touch /var/log/cron.log

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/app/webapp/log/* /home/app/webapp/tmp/* /home/app/webapp/.git
