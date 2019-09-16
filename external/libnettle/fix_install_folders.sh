#! /bin/bash
PRJDIR=$1
if [ -d ${PRJDIR} ]; then
  if [ -d ${PRJDIR}/lib64 ]; then
    ln --symbolic lib64 ${PRJDIR}/lib
  fi
fi
