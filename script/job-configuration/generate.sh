#!/bin/sh -e

REMOTE=$(git config --get remote.origin.url)
jjm --locator "${REMOTE}" --build-command script/build.sh --checkstyle 'build/log/checkstyle-*.xml' --recipients funtimecoding@gmail.com >configuration/job.xml
