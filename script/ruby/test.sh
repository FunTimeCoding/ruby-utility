#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../configuration/project.sh"

if [ "${1}" = --help ]; then
    echo "Usage: ${0} [--ci-mode]"

    exit 0
fi

if [ "${1}" = --ci-mode ]; then
    shift
    mkdir -p build/log
    export COVERAGE='on'
    bundle exec rspec --format RspecJunitFormatter --out build/log/rspec.xml "$@"
else
    bundle exec rspec "$@"
fi
