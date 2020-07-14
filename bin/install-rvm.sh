#!/bin/sh -e

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    brew install apple-gcc42
else
    echo "TODO: See which packages are really required."
    #sudo apt-get install --quiet 2 build-essential git-core libyaml-dev mercurial
fi

gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s latest

. "$HOME/.rvm/scripts/rvm"
rvm install 2.2
