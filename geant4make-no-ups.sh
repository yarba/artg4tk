#!/bin/sh

#-----------------------------------------------------------------------
# Bourne shell environment setup script for Geant4 10.3.0
#
# This script will configure your environment to provide a setup which 
# can be used to build user applications using the old Geant4 GNUmakefile 
# build system, but with a CMake build or install of Geant4.
#
# This script is autogenerated by CMake DO NOT EDIT
#

#-----------------------------------------------------------------------
# Locate directory of self
#
# Self locate script when sourced
#if [ -z "$BASH_VERSION" ]; then
  # Not bash, so rely on sourcing from correct location
#  if [ ! -f geant4make.sh ]; then
#    echo 'ERROR: geant4make.sh could NOT self-locate Geant4 installation'
#    echo 'This is most likely because you are using ksh, zsh or similar'
#    echo 'To fix this issue, cd to the directory containing this script'
#    echo 'and source it in that directory.'
#    return 1
#  fi
#  geant4make_root=$(pwd)
#else
#  g4sls_sourced_dir=$(dirname ${BASH_ARGV[0]})
#  geant4make_root=$(cd $g4sls_sourced_dir > /dev/null ; pwd)
#fi
      

#-----------------------------------------------------------------------
# Cleanup any existing known environment variables
# NB: It won't help with resetting paths!!
#
# - Core Variables
unset  G4INSTALL
unset  G4SYSTEM
unset  G4INCLUDE
unset  G4LIB
unset  G4DEBUG

# - Library build options
unset  G4LIB_BUILD_SHARED
unset  G4LIB_BUILD_STATIC
unset  G4LIB_USE_DLL
unset  G4LIB_USE_GRANULAR
unset  G4MULTITHREADED

# - Optional component build
#
# - CLHEP options
#unset  CLHEP_BASE_DIR
#unset  CLHEP_INCLUDE_DIR
#unset  CLHEP_LIB
#unset  CLHEP_LIB_DIR

# - EXPAT options
unset  G4LIB_BUILD_EXPAT
unset  G4LIB_USE_EXPAT

# - ZLIB options
unset  G4LIB_BUILD_ZLIB
unset  G4LIB_USE_ZLIB

# - GDML Options
unset  G4LIB_BUILD_GDML
unset  G4LIB_USE_GDML
# ---> unset  XERCESCROOT

# - G3ToG4
unset  G4LIB_BUILD_G3TOG4
unset  G4LIB_USE_G3TOG4

# - UI Build and Use options
# USE options only for applications.
unset  G4UI_NONE
unset  G4UI_BUILD_WT_SESSION
unset  G4UI_BUILD_QT_SESSION
unset  G4UI_BUILD_WIN32_SESSION
unset  G4UI_BUILD_XAW_SESSION
unset  G4UI_BUILD_XM_SESSION

unset  G4UI_USE_TCSH
unset  G4UI_USE_WIN32
unset  G4UI_USE_XAW
unset  G4UI_USE_XM
unset  G4UI_USE_QT
unset  G4UI_USE_WT

#- VIS Build and Use options
# Only USE options matter for applications.
unset  G4VIS_NONE

# - Network DAWN driver
unset  G4VIS_BUILD_DAWN_DRIVER
unset  G4VIS_USE_DAWN

# - Network VRML driver
unset  G4VIS_BUILD_VRML_DRIVER
unset  G4VIS_USE_VRML

# - OpenInventor driver
unset  G4VIS_BUILD_OIWIN32_DRIVER
unset  G4VIS_USE_OIWIN32
unset  G4VIS_BUILD_OIX_DRIVER
unset  G4VIS_USE_OIX

# - OpenGL drivers
unset  G4VIS_BUILD_OPENGLWT_DRIVER
unset  G4VIS_USE_OPENGLWT

unset  QTHOME
unset  QTLIBPATH
unset  QTLIBS
unset  GLQTLIBS
unset  G4VIS_BUILD_OPENGLQT_DRIVER
unset  G4VIS_USE_OPENGLQT

unset  G4VIS_BUILD_OPENGLWIN32_DRIVER
unset  G4VIS_USE_OPENGLWIN32

unset  G4VIS_BUILD_OPENGLXM_DRIVER
unset  G4VIS_USE_OPENGLXM

unset  G4VIS_BUILD_OPENGLX_DRIVER
unset  G4VIS_USE_OPENGLX

# - Raytracer X11
unset  G4VIS_BUILD_RAYTRACERX_DRIVER
unset  G4VIS_USE_RAYTRACERX


#-----------------------------------------------------------------------
# System description and standard install paths
#
export G4SYSTEM=Linux-g++

#export G4RELEASE=geant4-10-03-beta-01
if [ "x" == "x${1}" ]; then
echo "Geant4 release is NOT provided "
echo "Example usage: "
echo "   source geant4make-no-ups.sh geant4-10-03-beta-01 "
echo "exit"
return 1
fi 

G4RELEASE=${1}

GeneralPath2G4=/g4/yarba_j/geant4-local-builds

if [ "x" == "x${2}" ]; then
echo "DEFAULT GeneralPath2G4=${GeneralPath2G4} will be used" 
else
echo "GeneralPath2G4=${2} is provided and will be used"
GeneralPath2G4=${2}
fi

# export G4INSTALL=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01
export G4INSTALL=${GeneralPath2G4}/${G4RELEASE}
# export G4INCLUDE=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/this_is_a_deliberate_dummy_path
export G4INCLUDE=${G4INSTALL}/include

if test "x$PATH" = "x" ; then
#  export PATH=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01-build
  export PATH=${G4INSTALL}
else
#  export PATH=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01-build:${PATH}
  export PATH=${G4INSTALL}:${PATH}
fi

# export G4LIB=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01-build/BuildProducts/lib64
export G4LIB=${G4INSTALL}/lib64

if test "x$LD_LIBRARY_PATH" = "x" ; then
#  export LD_LIBRARY_PATH=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01-build/BuildProducts/lib64
  export LD_LIBRARY_PATH=${G4LIB}
else
#  export LD_LIBRARY_PATH=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01-build/BuildProducts/lib64:${LD_LIBRARY_PATH}
  export LD_LIBRARY_PATH=${G4LIB}:${LD_LIBRARY_PATH}
fi


#-----------------------------------------------------------------------
# User's G4WORKDIR
#

if test "x$G4WORKDIR" = "x" ; then
  export G4WORKDIR=$HOME/geant4_workdir
fi


if test "x$PATH" = "x" ; then
  export PATH=${G4WORKDIR}/bin/${G4SYSTEM}
else
  export PATH=${G4WORKDIR}/bin/${G4SYSTEM}:${PATH}
fi


#-----------------------------------------------------------------------
# Library build setup
#
export G4LIB_BUILD_SHARED=1




#-----------------------------------------------------------------------
# Resource file paths
# - Datasets
#export G4NEUTRONHPDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4NDL4.5
#export G4LEDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4EMLOW6.48
#export G4LEVELGAMMADATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/PhotonEvaporation3.2
#export G4RADIOACTIVEDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/RadioactiveDecay4.4.1
#export G4NEUTRONXSDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4NEUTRONXS1.4
#export G4PIIDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4PII1.3
#export G4REALSURFACEDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/RealSurface1.0
#export G4SAIDXSDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4SAIDDATA1.1
#export G4ABLADATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4ABLA3.0
#export G4ENSDFSTATEDATA=/g4/yarba_j/geant4-local-builds/geant4-10-03-beta-01/share/Geant4-10.3.0/data/G4ENSDFSTATE1.3.1

# older explicit env_setup from earlier work on Wilson cluster
#
# --> source /g4/g4p/pbs/g4-had-validation/env-setup/g4-datasets-setup-${G4RELEASE}.sh
#
# more flexible approach that will (hopefullY) allow to work transparently
# on either LQ1.fnal.gov or Wilson cluster
#
node_name=`uname -n`
env_setup=/g4/g4p/pbs/g4-had-validation/env-setup/g4-datasets-setup-${G4RELEASE}.sh
# --> if [ "$node_name" == "lq.fnal.gov" ]; then
if [[ $node_name =~ "lq" ]]; then
env_setup=/lustre1/g4/yarba_j/local-products/g4data/g4-datasets-setup-${G4RELEASE}.sh
fi
source ${env_setup}

# - Fonts for Freetype
# FREETYPE SUPPORT NOT AVAILABLE

#-----------------------------------------------------------------------
# Optional components.
#
#-----------------------------------------------------------------------
# CLHEP setup
#
# USING INTERNAL CLHEP

#unset CLHEP_LIB_DIR
#unset CLHEP_DIR
#unset CLHEP_BASE
#unset CLHEP_FQ
#unset SETUP_CLHEP
#unset CLHEP_BASE_DIR
#unset CLHEP_INCLUDE_DIR
#unset CLHEP_INC
#unset CLHEP_VERSION
#unset CLHEP_LIB


#export CLHEP_INC=${G4INCLUDE}/Geant4
#export CLHEP_INCLUDE_DIR=${CLHEP_INC}
#export CLHEP_LIB_DIR=${G4LIB}
#export CLHEP_LIB=G4clhep



#-----------------------------------------------------------------------
# EXPAT setup
# USING SYSTEM EXPAT

#-----------------------------------------------------------------------
# ZLIB Setup
#
export G4LIB_USE_ZLIB=1


#-----------------------------------------------------------------------
# GDML Setup
#
export G4LIB_USE_GDML=1
# ---> export XERCESCROOT=/g4/yarba_j/scisoft-installs/externals/xerces_c/v3_1_1c/Linux64bit+2.6-2.12-e7-prof

#-----------------------------------------------------------------------
# G3ToG4 Setup
#
# NOT BUILT WITH G3TOG4 SUPPORT

#-----------------------------------------------------------------------
# USER INTERFACE AND VISUALIZATION MODULES
#
#-----------------------------------------------------------------------
# Terminal UI
export G4UI_USE_TCSH=1
# WIN32 TERMINAL UI NOT AVAILABLE ON Linux

#-----------------------------------------------------------------------
# Qt UI/Vis
#




# NOT BUILT WITH QT INTERFACE


#-----------------------------------------------------------------------
# Wt UI/Vis
#



#-----------------------------------------------------------------------
# Xm UI/Vis
#
# NOT BUILT WITH XM INTERFACE


#-----------------------------------------------------------------------
# Network DAWN driver
#
# NOT BUILT WITH NETWORK DAWN SUPPORT

#-----------------------------------------------------------------------
# Network VRML driver
#
# NOT BUILT WITH NETWORK VRML SUPPORT

#-----------------------------------------------------------------------
# OpenInventor
#
# NOT BUILT WITH INVENTOR SUPPORT

#-----------------------------------------------------------------------
# X11 OpenGL
#
# NOT BUILT WITH OPENGL(X11) SUPPORT

#-----------------------------------------------------------------------
# Win32 OpenGL
#
# NOT BUILT WITH OPENGL(WIN32) SUPPORT

#-----------------------------------------------------------------------
# X11 Raytracer 
#
# NOT BUILT WITH RAYTRACER(X11) SUPPORT

#-----------------------------------------------------------------------

