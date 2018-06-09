#!/bin/sh -e

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

EXCLUDE_FILTER='^.*\/(build|vendor|tmp|\.git|\.vagrant|\.bundle|\.idea)\/.*$'
MARKDOWN_FILES=$(${FIND} . -regextype posix-extended -name '*.md' -and ! -regex "${EXCLUDE_FILTER}")
BLACKLIST=""
DICTIONARY=en_US
mkdir -p tmp
cat documentation/dictionary/*.dic > tmp/combined.dic

for FILE in ${MARKDOWN_FILES}; do
    WORDS=$(hunspell -d "${DICTIONARY}" -p tmp/combined.dic -l "${FILE}" | sort | uniq)

    if [ ! "${WORDS}" = "" ]; then
        echo "${FILE}"

        for WORD in ${WORDS}; do
            BLACKLISTED=$(echo "${BLACKLIST}" | grep "${WORD}") || BLACKLISTED=false

            if [ "${BLACKLISTED}" = false ]; then
                if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
                    grep --line-number "${WORD}" "${FILE}"
                else
                    # The equals character is required.
                    grep --line-number --color=always "${WORD}" "${FILE}"
                fi
            else
                echo "Blacklisted word: ${WORD}"
            fi
        done

        echo
    fi
done

TEX_FILES=$(${FIND} . -regextype posix-extended -name '*.tex' -and ! -regex "${EXCLUDE_FILTER}")

for FILE in ${TEX_FILES}; do
    WORDS=$(hunspell -d "${DICTIONARY}" -p tmp/combined.dic -l -t "${FILE}")

    if [ ! "${WORDS}" = "" ]; then
        echo "${FILE}"

        for WORD in ${WORDS}; do
            STARTS_WITH_DASH=$(echo "${WORD}" | grep -q '^-') || STARTS_WITH_DASH=false

            if [ "${STARTS_WITH_DASH}" = false ]; then
                BLACKLISTED=$(echo "${BLACKLIST}" | grep "${WORD}") || BLACKLISTED=false

                if [ "${BLACKLISTED}" = false ]; then
                    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
                        grep --line-number "${WORD}" "${FILE}"
                    else
                        # The equals character is required.
                        grep --line-number --color=always "${WORD}" "${FILE}"
                    fi
                else
                    echo "Skip blacklisted: ${WORD}"
                fi
            else
                echo "Skip invalid: ${WORD}"
            fi
        done

        echo
    fi
done

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    FILES=$(${FIND} . -regextype posix-extended -name '*.sh' -and ! -regex "${EXCLUDE_FILTER}" -printf '%P\n')

    for FILE in ${FILES}; do
        FILE_REPLACED=$(echo "${FILE}" | sed 's/\//-/g')
        shellcheck --format checkstyle "${FILE}" > "build/log/checkstyle-${FILE_REPLACED}.xml" || true
    done
else
    # shellcheck disable=SC2016
    SHELL_SCRIPT_CONCERNS=$(${FIND} . -regextype posix-extended -name '*.sh' -and ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'shellcheck ${1} || true' '_' '{}' \;)

    if [ ! "${SHELL_SCRIPT_CONCERNS}" = "" ]; then
        CONCERN_FOUND=true
        echo "(WARNING) Shell script concerns:"
        echo "${SHELL_SCRIPT_CONCERNS}"
    fi
fi

EXCLUDE_FILTER_WITH_INIT='^.*\/((build|tmp|\.git|\.vagrant|\.idea)\/.*|__init__\.py)$'
# shellcheck disable=SC2016
EMPTY_FILES=$(${FIND} . -regextype posix-extended -empty -and ! -regex "${EXCLUDE_FILTER_WITH_INIT}")

if [ ! "${EMPTY_FILES}" = "" ]; then
    CONCERN_FOUND=true

    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
        echo "${EMPTY_FILES}" > build/log/empty-files.txt
    else
        echo
        echo "(WARNING) Empty files:"
        echo
        echo "${EMPTY_FILES}"
    fi
fi

# shellcheck disable=SC2016
TO_DOS=$(${FIND} . -regextype posix-extended -type f -and ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'grep -Hrn TODO "${1}" | grep -v "${2}"' '_' '{}' '${0}' \;)

if [ ! "${TO_DOS}" = "" ]; then
    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
        echo "${TO_DOS}" > build/log/to-dos.txt
    else
        echo
        echo "(NOTICE) To dos:"
        echo
        echo "${TO_DOS}"
    fi
fi

# shellcheck disable=SC2016
SHELLCHECK_IGNORES=$(${FIND} . -regextype posix-extended -type f -and ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'grep -Hrn "# shellcheck" "${1}" | grep -v "${2}"' '_' '{}' '${0}' \;)

if [ ! "${SHELLCHECK_IGNORES}" = "" ]; then
    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
        echo "${SHELLCHECK_IGNORES}" > build/log/shellcheck-ignores.txt
    else
        echo
        echo "(NOTICE) Shellcheck ignores:"
        echo
        echo "${SHELLCHECK_IGNORES}"
    fi
fi

RETURN_CODE=0
RUBOCOP_CONCERNS=$(bundle exec rubocop) || RETURN_CODE=$?

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    echo "${RUBOCOP_CONCERNS}" > build/log/rubocop.txt
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
    echo "${ROODI_CONCERNS}" > build/log/roodi.txt
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
    echo "${FLOG_CONCERNS}" > build/log/flog.txt
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
    echo "Concern(s) of category WARNING found." >&2

    exit 2
fi
