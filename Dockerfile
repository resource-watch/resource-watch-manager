FROM ruby:2.3.3-alpine
MAINTAINER David Inga <david.inga@vizzuality.com>

ENV NAME resourcewatch-manager

# Install dependencies
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
      build-base \
      git \
      nodejs \
      tzdata \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev \
    && rm -rf /var/cache/apk/*
RUN bundle config build.nokogiri --use-system-libraries
RUN gem install bundler --no-ri --no-rdoc

# Create app directory
ENV APP_PATH /usr/src/$NAME
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test
ADD . $APP_PATH

# Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production

# Precompile Rails assets
RUN bundle exec rake assets:precompile

# Setting port
EXPOSE 3000

# Start puma
CMD bundle exec puma -C config/puma.rb
