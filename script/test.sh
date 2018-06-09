#!/bin/sh -e

if [ "${1}" = "--ci-mode" ]; then
    shift
    mkdir -p build/log
    export COVERAGE="on"
    rspec --format RspecJunitFormatter --out build/log/rspec.xml "$@"
else
    rspec "$@"
fi
