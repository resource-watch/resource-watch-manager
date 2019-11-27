#!/bin/bash
set -e

case "$1" in
    start)
        echo "Running Start"
        rake db:migrate
        whenever --update-crontab
        sleep 15 && bundle exec rake ct_register_microservice:register &
        exec bundle exec puma -C config/puma.rb
        ;;
    test)
        echo "Running Test"
        /wait
        RAILS_ENV=test bundle exec rake db:drop db:create db:schema:load
        exec bundle exec rspec spec
        ;;

    *)
        exec "$@"
esac
