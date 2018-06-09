#!/bin/sh -e

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    WC='gwc'
    FIND='gfind'
else
    WC='wc'
    FIND='find'
fi

EXCLUDE_FILTER='^.*\/(build|vendor|tmp|\.git|\.vagrant|\.bundle|\.idea)\/.*$'
FILES=$(${FIND} . -regextype posix-extended -type f -and ! -regex "${EXCLUDE_FILTER}" | ${WC} --lines)
DIRECTORIES_EXCLUDE='^.*\/(build|tmp|\.git|\.vagrant|\.idea)(\/.*)?$'
DIRECTORIES=$(${FIND} . -regextype posix-extended -type d -and ! -regex "${DIRECTORIES_EXCLUDE}" | ${WC} --lines)
INCLUDE='^.*\.rb$'
CODE=$(${FIND} . -regextype posix-extended -type f -and -regex "${INCLUDE}" -and ! -regex "${EXCLUDE_FILTER}" | xargs cat)
LINES=$(echo "${CODE}" | ${WC} --lines)
NON_BLANK_LINES=$(echo "${CODE}" | grep --invert-match --regexp '^$' | ${WC} --lines)
echo "FILES: ${FILES}"
echo "DIRECTORIES: ${DIRECTORIES}"
echo "LINES: ${LINES}"
echo "NON_BLANK_LINES: ${NON_BLANK_LINES}"

if [ "${1}" = --ci-mode ]; then
    shift
    SYSTEM=$(uname)

    if [ "${SYSTEM}" = Darwin ]; then
        TEE='gtee'
    else
        TEE='tee'
    fi

    mkdir -p build/log
    sonar-runner | "${TEE}" build/log/sonar-runner.log
    rm -rf .sonar
fi

# TODO: Resolve Gemfile dependency problem.
#metric_fu
