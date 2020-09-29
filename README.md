# Resource Watch site manager microservice for the RW API

[![Build Status](https://travis-ci.org/resource-watch/resource-watch-manager.svg?branch=dev)](https://travis-ci.org/resource-watch/resource-watch-manager)
[![Test Coverage](https://api.codeclimate.com/v1/badges/cc3b209e57a896fe6d7c/test_coverage)](https://codeclimate.com/github/resource-watch/resource-watch-manager/test_coverage)

Content API microservice for Resource Watch website
Stores information on dashboards, profiles, etc.

If you are looking for the RW dataset API, you can find it [here](https://github.com/resource-watch/dataset)

# Setup

## Requirements

### Native execution 

* [Control Tower](https://github.com/control-tower)
* [Ruby 2.4.1+](https://www.ruby-lang.org/en/)
* [Bundler](https://bundler.io/)
* [Postgres](https://www.postgresql.org/)

### Docker 

* [Docker](https://www.docker.com/)
* [Docker compose](https://docs.docker.com/compose/)

Dependencies on other Microservices:

- [Widget](https://github.com/resource-watch/widget)
- [Control Tower](https://github.com/resource-watch/control-tower)

## Installation process:

### Native execution 
Copy `.env.sample` to `.env` and fill in the necessary values:
- RAILS_ENV: `development`|`production`
- SECRET_KEY_BASE: rails secret. [read more](https://medium.com/@michaeljcoyne/understanding-the-secret-key-base-in-ruby-on-rails-ce2f6f9968a1)
- RW_API_URL: URL of the RW API. Usually you want `https://api.resourcewatch.org` here
- APIGATEWAY_URL: URL of the RW API gateway. Usually you want `https://api.resourcewatch.org` here
- POSTGRES_PORT_5432_TCP_ADDR: Network address of your Postgres database server
- POSTGRES_PORT_5432_TCP_PORT: Network port of your Postgres database server
- POSTGRES_USER: Username of your Postgres database server
- POSTGRES_PASS: Password of your Postgres database server
- POSTGRES_DATABASE: Name of your database
- BULLET
- CT_URL: Control Tower URL (microservice mode only)
- LOCAL_URL: Local URL  (microservice mode only)
- CT_TOKEN: Control Tower token (microservice mode only)


Install the ruby dependencies:

```bash
bundle install
```

To start the development application server, run:

```bash
bundle exec rails server
```

And use the following command once the rails server is up to register the microservice in Control Tower:

```bash
bundle exec rake ct_register_microservice:register
```

### Docker

TODO: add more detailed docker installation instructions

```bash
./entrypoint.sh start
```



# Tests

```bash
RAILS_ENV=test bundle exec rake db:drop db:create db:schema:load
bundle exec rspec spec
```
