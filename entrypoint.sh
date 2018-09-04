#!/bin/bash
set -e

case "$1" in
    start)
        echo "Running Start"
        rake db:migrate
        whenever --update-crontab
        exec bundle exec puma -C config/puma.rb & (sleep 30; bundle exec rake ct_register_microservice:register)
        ;;
    *)
        exec "$@"
esac
