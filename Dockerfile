FROM ruby:2.4.1-alpine
MAINTAINER David Inga <david.inga@vizzuality.com>

ENV RAILS_ENV production
ENV RACK_ENV production

# Install dependencies
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
      build-base \
      bash \
      git \
      nodejs \
      tzdata \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev \
      imagemagick-dev \
    && rm -rf /var/cache/apk/* \
    && bundle config build.nokogiri --use-system-libraries \
    && gem install bundler --no-ri --no-rdoc \
    && mkdir -p /usr/src/app

# Set app directory
WORKDIR /usr/src/app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 --without development test
ADD . /usr/src/app
ENTRYPOINT ["./entrypoint.sh"]

