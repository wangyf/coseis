#!/bin/bash -e

# install location
prefix="${1:-${HOME}/local}"

# Bazaar version control
easy_install bzr

# SORD
cd "${prefix}"
bzr get http://earth.usc.edu/~gely/sord
mkdir -p bin
cd bin
ln -s ../sord/util/swab.py .
ln -s ../sord/util/stats.py .

# SCEC CVM4
cd "${prefix}"
bzr get http://earth.usc.edu/~gely/cvm
cd cvm
curl -O http://earth.usc.edu/~gely/cvm/cvm3-data.tgz
curl -O http://earth.usc.edu/~gely/cvm/cvm4-data.tgz
