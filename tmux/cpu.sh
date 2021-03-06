#!/bin/bash

#COL=$(tmux list-windows | head -1 | cut -d" " -f 5 | tr -d "[|]" | cut -d"x" -f1)
COL=$(tmux list-windows | head -1 | sed 's/.*\[\([0-9]\{1,4\}\)x[0-9]\{1,4\}\].*/\1/g')


#        CPU=`eval $(awk '/^cpu /{print "previdle=" $5 "; prevtotal=" $2+$3+$4+$5 }' /proc/stat); sleep 0.4; eval $(awk '/^cpu /{print "idle=" $5 "; total=" $2+$3+$4+$5 }' /proc/stat); intervaltotal=$((total-${prevtotal:-0})); echo "$((100*( (intervaltotal) - ($idle-${previdle:-0}) ) / (intervaltotal) ))" | tr '.' ','`


function ver { 
    printf "%1d%03d%03d" $(echo "$1" | tr '.' ' ') 
}

FREE=$(free -V | cut -d" " -f4)
if [[ $(ver "$FREE") -ge $(ver "3.3.10") ]]; then
    USED_MEM=$(free | awk '/Mem:/ {print (100 - ($7 / $2 * 100.0));}')
else
    USED_MEM=$(free | awk '/buffers\/cache/{print (100 - ($4/($3+$4) * 100.0));}')
fi

CPU=$(cat /proc/loadavg | cut -d' ' -f1)
# NUMCPU=$(cat /proc/cpuinfo | grep proc | wc -l)
NUMCPU=$(nproc)
LC_NUMERIC="en_US.UTF-8"

if [ $COL -gt 74 ]; then
    # USERS=$(users | wc -w)    # logged on users
    USERS=$(users | tr " " "\n" | uniq | wc -l)     # uniq logged on users
    [[ $USERS -ne 1 ]] && printf "U:%d ⡇ " $USERS
    if (( $(bc <<< "$CPU > $NUMCPU") )); then
        printf "L:"; printf "#[default]#[fg=red]"; printf "%.2f" $CPU; printf "#[default]#[fg=colour136]"
    else
        printf "L:%.2f" $CPU
    fi

    if (( $(bc <<< "$USED_MEM > 80") )); then
        printf " M:"; printf "#[default]#[fg=red]"; printf "%.f%%" $USED_MEM; printf "#[default]#[fg=colour136]"; printf " ⡇ "
    else
        printf " M:%.f%% ⡇ " $USED_MEM
    fi

else
    if (( $(bc <<< "$CPU > $NUMCPU") )); then
        printf "L:"; printf "#[default]#[fg=red]"; printf "%.2f" $CPU; printf "#[default]#[fg=colour136]"; printf " ⡇ "
    else
        printf "L:%.2f ⡇ " $CPU
    fi
fi
