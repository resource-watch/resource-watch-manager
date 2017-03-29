FROM ruby:2.3.3-alpine
MAINTAINER David Inga <david.inga@vizzuality.com>

ENV APP_PATH /usr/src/resourcewatch-manager
ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

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
      libjpeg-turbo-dev \
      imagemagick-dev \
      cairo-dev \
    && rm -rf /var/cache/apk/* \
    && bundle config build.nokogiri --use-system-libraries \
    && gem install bundler --no-ri --no-rdoc \
    && npm install -g node-gyp yarn

# Create app directory
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY package.json package.json
RUN bundle install --jobs 20 --retry 5 --without development test && yarn install --peer
ADD . $APP_PATH

# Precompile assets
RUN bundle exec rake assets:precompile

# Setting port
EXPOSE 3000

# Start puma
CMD bundle exec rails server -b 0.0.0.0
