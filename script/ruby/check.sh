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

CONCERN_FOUND=false
CONTINUOUS_INTEGRATION_MODE=false

if [ "${1}" = --ci-mode ]; then
    shift
    mkdir -p build/log
    CONTINUOUS_INTEGRATION_MODE=true
fi

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    FIND='gfind'
else
    FIND='find'
fi

RETURN_CODE=0
RUBOCOP_CONCERNS=$(bundle exec rubocop) || RETURN_CODE=$?

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    echo "${RUBOCOP_CONCERNS}" >build/log/rubocop.txt
else
    if [ ! "${RETURN_CODE}" = 0 ]; then
        CONCERN_FOUND=true
        echo
        echo "(WARNING) RuboCop concerns:"
        echo
        echo "${RUBOCOP_CONCERNS}"
    fi
fi

echo
RETURN_CODE=0
ROODI_CONCERNS=$(bundle exec roodi "lib/**/*.rb") || RETURN_CODE=$?

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    echo "${ROODI_CONCERNS}" >build/log/roodi.txt
else
    if [ ! "${RETURN_CODE}" = 0 ]; then
        CONCERN_FOUND=true
        echo
        echo "(WARNING) Roodi concerns:"
        echo
        echo "${ROODI_CONCERNS}"
    fi
fi

echo
RETURN_CODE=0
# shellcheck disable=SC2016
FLOG_CONCERNS=$(${FIND} . -regextype posix-extended -name '*.rb' -and ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'echo ${1}; bundle exec flog ${1}' '_' '{}' \;) || RETURN_CODE=$?

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    echo "${FLOG_CONCERNS}" >build/log/flog.txt
else
    if [ ! "${RETURN_CODE}" = 0 ]; then
        CONCERN_FOUND=true
        echo
        echo "(WARNING) Flog concerns:"
        echo
        echo "${FLOG_CONCERNS}"
    fi
fi

if [ "${CONCERN_FOUND}" = true ]; then
    echo
    echo "Warning level concern(s) found." >&2

    exit 2
fi
