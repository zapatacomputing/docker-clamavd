#!/bin/bash
set -m

# we need to get a set of files to work with
freshclam 

# this will monitor and update
freshclam -d &

# the scanner
clamd &

pids=`jobs -p`

exitcode=0

function terminate() {
    trap "" CHLD

    for pid in $pids; do
        if ! kill -0 $pid 2>/dev/null; then
            wait $pid
            exitcode=$?
        fi
    done

    kill $pids 2>/dev/null
}

trap terminate CHLD
wait

exit $exitcode
