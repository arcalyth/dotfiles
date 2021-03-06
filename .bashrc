#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# == remap aliases ==
# - sudo convenience -
alias poweroff='systemctl poweroff'
alias reboot='systemctl reboot'

# - general remaps -
alias vi='vim'
alias view='vim -R'
alias ls='ls --color=auto'
alias irssi='irssi-notify & irssi'
alias n='ncmpcpp'
alias a='alsamixer'
alias cmatrix='cmatrix -axu5 -C cyan'
alias s='systemctl suspend'

# == convenience/extension aliases ==
# - awesome wm conf stuff -
alias awconf='vim ~/.config/awesome/rc.lua.test'
alias awclone='cp ~/.config/awesome/rc.lua ~/.config/awesome/rc.lua.test'
alias awmerge='cp ~/.config/awesome/rc.lua.test ~/.config/awesome/rc.lua'

# keyboard layout shit 
alias qwerty='setxkbmap us'
alias qwfpgj='setxkbmap us'
alias colemak='setxkbmap us -variant colemak'

# - quick navigation -
alias aur='cd /usr/local/aur/'
alias gawconf='cd ~/.config/awesome/'

# - not really programs -
alias fclear='clear; fortune -ao'
alias pacman-mirrors='sudo reflector -l 5 -c "United States" --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist'
alias life='vim ~/life/life-plan'

# = functions =

# rot13() - credit: portix
# http://bbs.archlinux.org/viewtopic.php?pid=564656#p564656
rot13() { echo "$@" | tr 'a-zA-Z' 'n-za-mN-ZA-M'; }

# inline shell math :)
calc() { echo "$@" | bc -l; }
alias math='calc';

# dictionary definition fetcher
define() { 
    if [ -n "$1" ]; then
        w3m -dump "http://freedictionary.org/?Query=$1" | grep -i3 "$1" |
	tail -n+8 | sed ':a;N;$!ba;s/\n\n/\n/g' | head
    else
	echo "usage: define <word>"
    fi
}

# down for everyone, or just me?
isup() {
    if [ -n "$1" ]; then
	w3m -dump "http://downforeveryoneorjustme.com/$1" | head -n1
    else
	echo "usage: isup <url>"
    fi
}

# == environment ==
eval $(dircolors -b ~/.dircolors)
export PS1='[\w]\$ '
export PATH=$PATH:"~/bin"
export EDITOR='vim'

# == final execution ==
fortune -ao
