#!/bin/bash
PYTHON_VERSION=3.1.5

if [[ $0 == $${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi

git checkout python-3.1-to-3.5  && git pull && pyenv local $PYTHON_VERSION
