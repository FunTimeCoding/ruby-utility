#!/bin/sh -e

if [ "${GEM_HOME}" = '' ]; then
    echo "GEM_HOME must be set. Suggested value: ${HOME}/.gem"

    exit 1
fi

bundle install
