#!/bin/bash
PACKAGE=columnize

# FIXME put some of the below in a common routine
function finish {
  cd $owd
}

cd $(dirname ${BASH_SOURCE[0]})
owd=$(pwd)
trap finish EXIT

if ! source ./pyenv-versions ; then
    exit $?
fi

cd ..
source ./VERSION.py
echo $VERSION

for pyversion in $PYVERSIONS; do
    echo --- $pyversion ---
    if ! pyenv local $pyversion ; then
	exit $?
    fi
    # pip bdist_egg create too-general wheels. So
    # we narrow that by moving the generated wheel.

    # Pick out first two number of version, e.g. 3.5.1 -> 35
    first_two=$(echo $pyversion | cut -d'.' -f 1-2 | sed -e 's/\.//')
    rm -fr build
    if (( first_two >= 26 )) && (( first_two != 31 )); then
	python setup.py bdist_egg bdist_wheel
	mv -v dist/${PACKAGE}-$VERSION-{py2.py3,py$first_two}-none-any.whl
    else
	python setup.py bdist_egg
    fi

    echo === $pyversion ===
done

python ./setup.py sdist
