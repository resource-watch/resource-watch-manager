#!/bin/bash

case "$1" in
    develop)
        type docker-compose >/dev/null 2>&1 || { echo >&2 "docker-compose is required but it's not installed.  Aborting."; exit 1; }
        docker-compose -f docker-compose-develop.yml build && docker-compose -f docker-compose-develop.yml up
        ;;
    test)
        type docker-compose >/dev/null 2>&1 || { echo >&2 "docker-compose is required but it's not installed.  Aborting."; exit 1; }
        docker-compose -f docker-compose-test.yml build && docker-compose -f docker-compose-test.yml up --abort-on-container-exit
        ;;
    test-native)
        export CC_TEST_REPORTER_ID=a
        export CT_URL=http://localhost:9000
        export CT_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Im1pY3Jvc2VydmljZSIsImNyZWF0ZWRBdCI6IjIwMTYtMDktMTQifQ.IRCIRm1nfIQTfda_Wb6Pg-341zhV8soAgzw7dd5HxxQ
        export API_VERSION=v1
        export LOCAL_URL=http://localhost:4300
        export RAILS_ENV=test
        export SECRET_KEY_BASE=secret
        export RW_API_URL=https://api.resourcewatch.org
        export APIGATEWAY_URL=https://production-api.globalforestwatch.org
        RAILS_ENV=test bundle exec rake db:drop db:create db:schema:load
        bundle exec rspec spec --fail-fast
        ;;
    *)
        echo "Usage: resourceWatchManager.sh {develop|test}" >&2
        exit 1
        ;;
esac

exit 0
