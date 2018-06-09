#!/bin/sh -e

rm -rf build
bundle install --path vendor/bundle
script/check.sh --ci-mode
script/measure.sh --ci-mode
script/test.sh --ci-mode
