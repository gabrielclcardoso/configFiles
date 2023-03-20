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

HISTCONTROL=ignoredups

################################################################################


################################### PROMPT #####################################

function git_ahead() {
    if [ -d .git ] || [ -f .git ]
	then
		 [[ $(git status 2> /dev/null | grep "Your branch is ahead") ]] && \
			printf " >>"
	fi
}

function git_untracked() {
    if [ -d .git ] || [ -f .git ]
	then
		 [[ $(git status 2> /dev/null | grep '"git add"') ]] && \
			printf " X"
	fi
}

function git_staged() {
    if [ -d .git ] || [ -f .git ]
	then
		 [[ $(git status 2> /dev/null | grep "Changes to be committed:") ]] && \
			printf " -"
	fi
}

function git_clean() {
    if [ -d .git ] || [ -f .git ]
	then
		 [[ $(git status 2> /dev/null | grep "nothing to commit") ]] && \
			printf " O"
	fi
}

function git_branch() {
    if [ -d .git ] ; then
        printf "%s" "($(git branch 2> /dev/null | awk '/\*/{print $2}'))";
    fi
}

# Set the prompt.

#PS1=${cyn}'(\A) '${grn}'$(git_clean)'${ylw}'$(git_staged)'${red}'$(git_untracked)'${pur}'$(git_branch)'${blu}' \W'${grn}' \$ '${clr}
PS1=${cyn}'(\A)'${grn}\
'$(git_clean)'${ylw}'$(git_staged)'${red}'$(git_untracked)'${wht}'$(git_ahead)'\
${pur}'$(git_branch)'${blu}' \W'${wht}' \$ '${clr}


################################################################################
