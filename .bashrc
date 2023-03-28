OS=$(uname)

################################### COLORS #####################################

blk='\[\033[01;30m\]'	# Black
red='\[\033[01;31m\]'	# Red
grn='\[\033[01;32m\]'	# Green
ylw='\[\033[01;33m\]'	# Yellow
blu='\[\033[01;34m\]'	# Blue
pur='\[\033[01;35m\]'	# Purple
cyn='\[\033[01;36m\]'	# Cyan
wht='\[\033[01;37m\]'	# White
clr='\[\033[00m\]'		# Reset

################################################################################


################################### ALIASES ####################################

alias vim="nvim"


## Colorfull ls ##
if [[ "$OS" -eq "Linux" ]]
then
	alias ls="ls -G"
else
	alias ls="ls --color"
fi

################################################################################


################################### HISTORY ####################################

HISTCONTROL="ignoredups:ignorespace"

################################################################################


################################### PROMPT #####################################

## Git info ##

function in_git() {
	git status 2> /dev/null > /dev/null
    [ $? -eq 0 ] && printf " \ue702["
}

function end_git() {
	git status 2> /dev/null > /dev/null
    [ $? -eq 0 ] && printf "]"
}

function git_ahead() {
	git=$(git status 2> /dev/null | grep "Your branch is ahead")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "\uf403 "
	fi
}

function git_mod() {
	git=$(git status 2> /dev/null | grep "git add")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "\ueabd "
	fi
}

function git_staged() {
	git=$(git status 2> /dev/null | grep "Changes to be committed:")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "\ueabc "
	fi
}

function git_clean() {
	git=$(git status 2> /dev/null | grep "nothing to commit")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "\ueab2 "
	fi
}

function git_branch() {
	branch=$(git branch 2> /dev/null | awk '/\*/{print $2}')
	dir=$(basename "$PWD")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ] && [ "$dir" != "$branch" ]
	then
		printf "($branch)" ;
    fi
}

## Environment info ##

function put_arrow() {
	printf "\uf178 "
}

# Set the prompt.

PS1='\[$(tput bold setaf 152)\](\A)'\
'\[$(tput bold setaf 208)\]$(in_git)'\
'\[$(tput bold setaf 76)\]$(git_clean)'\
'\[$(tput bold setaf 190)\]$(git_staged)'\
'\[$(tput bold setaf 196)\]$(git_mod)'\
'\[$(tput bold setaf 33)\]$(git_ahead)'\
'\[$(tput bold setaf 165)\]$(git_branch)'\
'\[$(tput bold setaf 208)\]$(end_git)'\
' \[$(tput bold setaf 51)\]\W '\
'\[$(tput bold setaf 40)\]$(put_arrow)'${clr}

################################################################################
