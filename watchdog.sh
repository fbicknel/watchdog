#!/usr/bin/env bash
function dosomething {
    echo something done
    echo Activity was $1 %
}

while :; do
    date
    PCT=$(ps -axu | awk '/jackett/ { if ($3 > .1) {print $3}}')
    if [ -z "$PCT" ]; then
        echo Nothing yet
    else
        dosomething $PCT
    fi
    sleep 10
done
