#!/bin/ksh
#############################################################################
# Source name: my_script.sh
# Author : BKO
# Date : 11/04/2019
# Description : This script removes package from a flattening TOS package
#############################################################################

# Common display functions
function fDisplayINFO {
    #echo -e "[INFO] $1"
    echo -e "\033[32m [INFO] $*\033[00m"
}

function fDisplayWARNING {
    #echo -e "[ERROR] $1"
    echo -e "\033[33m [WARNING] $*\033[00m"
}

function fDisplayERROR {
    #echo -e "[ERROR] $1"
    echo -e "\033[31m [ERROR] $*\033[00m"
}

function fManageReturnCode {
  rc=$1
  command=$2
  if [[ $rc -eq 0 ]]; then
      fDisplayINFO    "$command   OK"
    else
      fDisplayERROR "$command  FAILURE"
      exit 1
  fi
}

#Global variables
homeDir=/tmp/bko/tos_with_MBNEXP/test

for file in *.zip; 
  do 
    #echo "unzip ${file#tos.}"; 
    fDisplayINFO "unzip $file 1> /dev/null"
    unzip $file 1> /dev/null
    value=$?
    command="unzip $file 1"
    fManageReturnCode $value $command

    
    dirName1=${file#tos.}
    dirName=${dirName1%.zip}
    fDisplayINFO "$dirName1"
    fDisplayINFO "$dirName"
    #for file in *; do echo "${file%.zip}"; done
    if [ -d "$dirName" ]; then
       fDisplayINFO "It's a directory $dirName"
       cd $dirName/FLT
       value=$?
       fManageReturnCode $value "cd $dirName/FLT"
       fDisplayINFO "rm -rf MBNEXP"
       rm -rf MBNEXP
       value=$?
       fManageReturnCode $value "rm -rf MBNEXP"
       cd $homeDir
       value=$?
       fManageReturnCode $value "cd $homeDir"
       mkdir -p backup_MBNEXP
       value=$?
       fManageReturnCode $value "mkdir -p backup_MBNEXP"
       mv $file backup_MBNEXP/$file.with.MBNEXP
       zip -r $file $dirName 1> /dev/null
       value=$?
       fManageReturnCode $value "zip -r $file $dirName"
       rm -rf $dirName
       value=$?
       fManageReturnCode $value "rm -rf $dirName"
       fDisplayINFO "PWD: $homeDir ( new file $file --> created!"
       fDisplayINFO "----------------------------------------------"
    fi
done
