#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Automatically start X, no display manager needed :)
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx &
    sleep 3
    logout
fi
eval $(ssh-agent)
