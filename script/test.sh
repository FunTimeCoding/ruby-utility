#!/bin/sh -e

if [ "${1}" = --ci-mode ]; then
    shift
    mkdir -p build/log
    export COVERAGE='on'
    bundle exec rspec --format RspecJunitFormatter --out build/log/rspec.xml "$@"
else
    bundle exec rspec "$@"
fi
