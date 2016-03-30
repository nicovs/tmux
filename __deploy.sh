#!/bin/bash

P=$1
DIR=$(dirname $(readlink -f $0))

if [ -z $P ]; then
    echo copy files to homedir
    mv ~/.tmux ~/.tmux.ori
    mv ~/.tmux.conf ~/.tmux.conf.ori
    ln -s $DIR/tmux ~/.tmux
    ln -s $DIR/tmux.conf ~/.tmux.conf
    exit $?
fi

if [ "$(expr match "$P" '.*\(:\)')" = ":" ]; then
    echo "Usage:"
    echo "$0               to deploy local"
    echo "$0 user@host     to deploy remote"
    exit 1
fi

rsync -rptvz --delete --exclude ".git" $DIR/tmux/ $P:~/.tmux
rsync -rptvz --delete --exclude ".git" $DIR/tmux.conf $P:~/.tmux.conf


#echo '
#PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
#export TERM=xterm-256color
#'

ssh "$P" '[[ "$(tmux -V)" == "tmux 1.6" ]] && cp ~/.tmux/tmux.conf_1_6 ~/.tmux.conf'



