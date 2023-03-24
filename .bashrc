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

################################################################################


################################### HISTORY ####################################

HISTCONTROL="ignoredups:ignorespace"

################################################################################


################################### PROMPT #####################################

## Git info ##

function in_git() {
	git status 2> /dev/null > /dev/null
    [ $? -eq 0 ] && printf " $(tput bold setaf 208)\ue702["
}

function end_git() {
	git status 2> /dev/null > /dev/null
    [ $? -eq 0 ] && printf "$(tput bold setaf 208)]"
}

function git_ahead() {
	git=$(git status 2> /dev/null | grep "Your branch is ahead")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "$(tput bold setaf 33)\uf403 "
	fi
}

function git_mod() {
	git=$(git status 2> /dev/null | grep "git add")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "$(tput bold setaf 196)\ueabd "
	fi
}

function git_staged() {
	git=$(git status 2> /dev/null | grep "Changes to be committed:")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "$(tput bold setaf 190)\ueabc "
	fi
}

function git_clean() {
	git=$(git status 2> /dev/null | grep "nothing to commit")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf "$(tput bold setaf 76)\ueab2 "
	fi
}

function git_branch() {
	branch=$(git branch 2> /dev/null | awk '/\*/{print $2}')
	dir=$(basename "$PWD")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ] && [ "$dir" != "$branch" ]
	then
		printf "$(tput bold setaf 165)($branch)" ;
    fi
}

function put_git() {
	in_git
	git_clean
	git_staged
	git_mod
	git_ahead
	git_branch
	end_git
}

## Environment info ##

function put_arrow() {
	printf "$(tput bold setaf 40)\uf178 "
}

# Set the prompt.

PS1='$(tput bold setaf 152)(\A)'\
'$(put_git)'\
' $(tput bold setaf 51)\W '\
'$(put_arrow)'${clr}

################################################################################
