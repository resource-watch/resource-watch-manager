FROM ruby:2.4.1-alpine

ARG apiGatewayUrl=https://production-api.globalforestwatch.org

ENV RW_API_URL https://api.resourcewatch.org/v1
ENV APIGATEWAY_URL $apiGatewayUrl

ARG secretKey
ENV SECRET_KEY_BASE $secretKey
ENV BUNDLER_VERSION 2.0.2

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
    && rm -rf /var/cache/apk/*

RUN bundle config build.nokogiri --use-system-libraries
RUN gem install bundler --no-document
RUN mkdir -p /usr/src/app

# Set app directory
WORKDIR /usr/src/app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5
ADD . /usr/src/app

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]

