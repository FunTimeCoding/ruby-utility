#!/bin/sh -e

usage()
{
    echo "Usage: ${0} TARGET_PROJECT"
}

TARGET_PROJECT="${1}"

if [ "${TARGET_PROJECT}" = "" ]; then
    usage

    exit 1
fi

if [ ! -d "${TARGET_PROJECT}" ]; then
    echo "Target directory does not exist."

    exit 1
fi

CAMEL=$(head -n1 "${TARGET_PROJECT}/README.md" | awk '{ print $2 }' | grep -E '^([A-Z][a-z0-9]+){2,}$') || CAMEL=""

if [ "${CAMEL}" = "" ]; then
    echo "Could not determine project name."

    exit 1
fi

OPERATING_SYSTEM=$(uname)

if [ "${OPERATING_SYSTEM}" = "Linux" ]; then
    SED="sed"
    FIND="find"
else
    SED="gsed"
    FIND="gfind"
fi

cp ./*.md "${TARGET_PROJECT}"
cp ./*.sh "${TARGET_PROJECT}"
cp sonar-project.properties "${TARGET_PROJECT}"
cp ruby_skeleton.gemspec "${TARGET_PROJECT}"
cp .gitignore "${TARGET_PROJECT}"
cp .rubocop.yml "${TARGET_PROJECT}"
rm "${TARGET_PROJECT}/init-project.sh"
rm "${TARGET_PROJECT}/sync-project.sh"
DASH=$(echo "${CAMEL}" | ${SED} -E 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
INITIALS=$(echo "${CAMEL}" | ${SED} 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | ${SED} -E 's/-/_/g')
echo "DASH: ${DASH}"
echo "INITIALS: ${INITIALS}"
echo "UNDERSCORE: ${UNDERSCORE}"
cd "${TARGET_PROJECT}" || exit 1
# shellcheck disable=SC2016
${FIND} . -type f -regextype posix-extended ! -regex '^.*/(build|\.git|\.idea)/.*$' -exec sh -c '${1} -i -e "s/RubySkeleton/${2}/g" -e "s/ruby-skeleton/${3}/g" -e "s/ruby_skeleton/${4}/g" -e "s/bin\/rs/bin\/${5}/g" ${6}' '_' "${SED}" "${CAMEL}" "${DASH}" "${UNDERSCORE}" "${INITIALS}" '{}' \;
echo "Done. Files were copied to ${TARGET_PROJECT} and modified. Review those changes."
