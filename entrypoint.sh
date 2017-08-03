#!/bin/bash
set -e

case "$1" in
    start)
        echo "Running Start"
        exec bash -c ''bundle exec puma -C config/puma.rb''
        ;;
    *)
        exec "$@"
esac
