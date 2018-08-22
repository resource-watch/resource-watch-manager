# Resource Watch Manager

Content API for Resource Watch
Stores information on dashboards, profiles, etc.

If you are looking for the RW dataset API, you can find it [here](https://github.com/resource-watch/dataset)

# Setup

## Requirements:

* [Ruby 2.4.1+](https://www.ruby-lang.org/en/)
* [Bundler](https://bundler.io/)

## Installation process:

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


Install the ruby dependencies:

```bash
bundle install
```

To start the development application server, run:

```bash
bundle exec rails server
```
