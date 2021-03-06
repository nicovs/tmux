#!/bin/bash

case "$OSTYPE" in
    linux-gnu)
        if which sensors > /dev/null; then
            sensors | grep Core | awk '{print $3;}' | grep -oEi '[0-9]+.[0-9]+' | awk '{total+=$1; count+=1} END {printf "%d%s", total/count, "°C ⡇ "}'
        else
            ""
        fi
        ;;
esac
