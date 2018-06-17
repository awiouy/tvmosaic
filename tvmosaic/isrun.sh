#!/bin/sh

. $(dirname $0)/incl

RES=1

PROCESS=`ps aux | grep ${SERVER_NAME} | grep -v grep`
if [ -n "${PROCESS}" ] ; then
    RES=0
    echo "${SERVER_NAME} is working"
else
    echo "${SERVER_NAME} stopped"
fi

exit $RES
