#!/bin/sh -e
# This tool can be used to initialise the template after making a fresh copy to get started quickly.
# The goal is to make it as easy as possible to create scripts that allow easy testing and continuous integration.

CAMEL=$(echo "${1}" | grep -E '^([A-Z][a-z0-9]+){2,}$') || CAMEL=""

if [ "${CAMEL}" = "" ]; then
    echo "Usage: ${0} UpperCamelCaseProject"

    exit 1
fi

OS=$(uname)

if [ "${OS}" = "Darwin" ]; then
    SED="gsed"
else
    SED="sed"
fi

DASH=$(echo "${CAMEL}" | sed -E 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | sed -E 's/-/_/g')
INITIALS=$(echo "${CAMEL}" | sed 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
echo "UNDERSCORE: ${UNDERSCORE}"
echo "DASH: ${DASH}"
echo "INITIALS: ${INITIALS}"
find -E . -type f ! -regex '^.*/(build|\.git|\.idea)/.*$' -exec sh -c '${1} -i -e "s/RubySkeleton/${2}/g" -e "s/ruby-skeleton/${3}/g" -e "s/ruby_skeleton/${4}/g" -e "s/bin\/rs/bin\/${5}/g" ${6}' '_' "${SED}" "${CAMEL}" "${DASH}" "${UNDERSCORE}" "${INITIALS}" '{}' \;
git mv lib/ruby_skeleton "lib/${UNDERSCORE}"
git mv spec/ruby_skeleton_spec.rb "spec/${UNDERSCORE}_spec.rb"
git mv lib/ruby_skeleton.rb "lib/${UNDERSCORE}.rb"
git mv ruby_skeleton.gemspec "${UNDERSCORE}.gemspec"
git mv bin/rs "bin/${INITIALS}"
echo "Done. Files were edited and moved using git. Review those changes."
