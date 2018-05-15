#!/bin/bash
#
# MindForger knowledge management tool
#
# Copyright (C) 2016-2018 Martin Dvorak <martin.dvorak@mindforger.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# Method:
#   create tarball (tarball + tests - makefiles)
#

if [ -e "../.git" ]
then
  echo "This script must NOT be run from Git repository - run it e.g. from ~/p/mindforger/release instead"
  exit 1
fi

if ! grep -q "//#ifdef DO_M8R_DEBUG" "../../lib/src/debug.h"
then
    echo "This script must NOT be run if debug code is enable - disable DO_M8R_DEBUG first"
    exit 1
fi

# ############################################################################
# # Create upstream tarball #
# ############################################################################

function createTarball() {
  cd ..
  mkdir work
  cd work
  cp -vrf ../${MF} .
  tar zcf ../${MF}.tgz ${MF}
  cd ../${MF}
}

# ############################################################################
# # Build source and binary deb packages #
# ############################################################################

function buildGitHubTarball() {
    export SCRIPTHOME=`pwd`
    export MFVERSION=$1
    export MFBZRMSG=$2
    #export MFFULLVERSION=${MFVERSION}-1.0 # NMU upload
    export MFFULLVERSION=${MFVERSION}-1    # mantainer upload
    export MF=mindforger_${MFVERSION}
    export MFRELEASE=mindforger-${MFFULLVERSION}
    export MFSRC=/home/dvorka/p/mindforger/git/mindforger
    export NOW=`date +%Y-%m-%d--%H-%M-%S`
    export MFBUILD=mindforger-${NOW}
    export UBUNTUVERSION=unstable

    #
    # 1) create tarball
    #
    # 1.1) get copy of project source
    echo -e "\n# Get MF project files ############################"
    mkdir -p ${MFBUILD}/${MF}
    cd ${MFBUILD}/${MF}
    # copy  project files to current directory
    cp -rvf ${MFSRC}/* ${MFSRC}/*.*  .
    
    # 1.2) prune MindForger project source: tests, *.o/... build files, ...
    echo -e "\n# MF project cleanup ########################################"
    rm -vrf ./.git ./app/mindforger ./build
    find . -type f \( -name "*moc_*.cpp" -or -name "*.a" -or -name "*.o" -or -name "*.*~" -or -name ".gitignore" -or -name ".git" \) | while read F; do rm -vf $F; done
        
    # 1.4) create tar archive
    createTarball
}

# ############################################################################
# # Main #
# ############################################################################

export ARG_BAZAAR_MSG="Experimental Debian package."
export ARG_VERSION="0.7.1"

buildGitHubTarball ${ARG_VERSION} ${ARG_BAZAAR_MSG}

# eof
