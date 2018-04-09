FROM ruby:2.4.1-alpine

ARG apiGatewayUrl=https://production-api.globalforestwatch.org

ENV RAILS_ENV production
ENV RACK_ENV production
ENV RW_API_URL https://api.resourcewatch.org/v1
ENV APIGATEWAY_URL $apiGatewayUrl

ARG secretKey
ENV SECRET_KEY_BASE $secretKey

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
EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]

