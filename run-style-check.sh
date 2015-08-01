#!/bin/sh -e

CI_MODE=0

if [ "${1}" = "--ci-mode" ]; then
    shift
    CI_MODE=1
    mkdir -p build/log
fi

echo "================================================================================"
echo
echo "Running RuboCop."

if [ "${CI_MODE}" = "1" ]; then
    rubocop | tee build/log/rubocop.txt || true
else
    rubocop || true
fi

echo
echo "================================================================================"

if [ "${CI_MODE}" = "1" ]; then
    roodi "**/*.rb" | tee build/log/roodi.txt
else
    roodi "**/*.rb"
fi

echo
echo "================================================================================"
echo
echo "Running flog."
echo

if [ "${CI_MODE}" = "1" ]; then
    find . -name '*.rb' -exec sh -c 'flog ${1}' '_' '{}' \; | tee build/log/flog.txt
else
    find . -name '*.rb' -exec sh -c 'echo ${1}; flog ${1}' '_' '{}' \;
fi

echo
echo "================================================================================"
echo
echo "Running ShellCheck."
find . -name '*.sh' -exec sh -c 'shellcheck ${1} || true' '_' '{}' \;
echo
echo "================================================================================"
