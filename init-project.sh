#!/bin/sh -e
# This tool can be used to initialise the template after making a fresh copy to get started quickly.
# The goal is to make it as easy as possible to create scripts that allow easy testing and continuous integration.

CAMEL=$(echo "${1}" | grep -E '^([A-Z][a-z0-9]+){2,}$') || CAMEL=""

if [ "${CAMEL}" = "" ]; then
    echo "Usage: ${0} MyUpperCamelCaseProjectName"

    exit 1
fi

DASH=$(echo "${CAMEL}" | sed -E 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | sed -E 's/-/_/g')
INITIALS=$(echo "${CAMEL}" | sed 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
echo "Camel: ${CAMEL}"
echo "Underscore: ${UNDERSCORE}"
echo "Dash: ${DASH}"
echo "Initials: ${INITIALS}"
OS=$(uname)

if [ "${OS}" = "Darwin" ]; then
    alias sed='gsed'
fi

sed -i -e "s/ep/${INITIALS}/g" bin/rs spec/example_project_spec.rb
sed -i -e "s/example_project/${UNDERSCORE}/g" bin/rs spec/example_project_spec.rb example_project.gemspec
sed -i -e "s/ExampleProject/${CAMEL}/g" bin/rs spec/example_project_spec.rb lib/example_project.rb
sed -i -e "s/example-project/${DASH}/g" example_project.gemspec
git mv lib/example_project "lib/${UNDERSCORE}"
git mv spec/example_project_spec.rb "spec/${UNDERSCORE}_spec.rb"
git mv lib/example_project.rb "lib/${UNDERSCORE}.rb"
git mv example_project.gemspec "${UNDERSCORE}.gemspec"
git mv bin/rs "bin/${INITIALS}"
echo "Done. Files were edited and moved using git. Review those changes. You may also delete this script now."
