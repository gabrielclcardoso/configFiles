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
function git_ahead() {
	git=$(git status 2> /dev/null | grep "Your branch is ahead")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf " >>"
	fi
}

function git_untracked() {
	git=$(git status 2> /dev/null | grep "git add")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf " X"
	fi
}

function git_staged() {
	git=$(git status 2> /dev/null | grep "Changes to be committed:")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf " -"
	fi
}

function git_clean() {
	git=$(git status 2> /dev/null | grep "nothing to commit")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ]
	then
		 [[ -n "$git" ]] && printf " O"
	fi
}

function git_branch() {
	branch=$(git branch 2> /dev/null | awk '/\*/{print $2}')
	dir=$(basename "$PWD")
	git status 2> /dev/null > /dev/null
    if [ $? -eq 0 ] && [ "$dir" != "$branch" ]
	then
		printf " ($branch)" ;
    fi
}

# Set the prompt.

PS1=${cyn}'(\A)'${grn}\
'$(git_clean)'${ylw}'$(git_staged)'${red}'$(git_untracked)'${wht}'$(git_ahead)'\
${pur}'$(git_branch)'${blu}' \W'${wht}' \$ '${clr}


################################################################################
