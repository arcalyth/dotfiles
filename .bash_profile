#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

eval $(ssh-agent)

# Automatically start X, no display manager needed :)
[[ -z "$DISPLAY" && $(tty) = /dev/tty1 ]] && exec startx
