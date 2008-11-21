#!/bin/bash -e

mode=%(mode)r
opts="-labelio yes -tasks_per_node %(ppn)s -nodes %(nodes)s -rmpool 1 -euilib us -euidevice sn_all"

cd %(rundir)r
if [ $( /bin/pwd | grep -v gpfs ) ]; then
    echo "Error: jobs must be run from /gpfs"
    exit
fi

echo "$( date ): %(name) started" >> log
%(pre)s
case "$mode${1:--i}" in
    s-i)  hpmcount -nao prof/hpm %(bin)s ;;
    s-g)  pdx %(bin)s ;;
    s-tv) totalview %(bin)s ;;
    m-i)  poe hpmcount -nao prof/hpm %(bin)s $opts ;;
    m-tv) tvpoe %(bin)s $opts ;;
esac
%(post)s
echo "$( date ): %(name) finished" >> log

