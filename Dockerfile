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
RUN bundle install --jobs 20 --retry 5
ADD . $APP_PATH

# Setting port
EXPOSE 3000

# Run application
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
