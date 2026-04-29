OS=$(uname)

if [ -f ~/.bash_secrets ]; then
    source ~/.bash_secrets
fi

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
alias ls="ls --color"

################################################################################

################################## FUNCTIONS ###################################

unlock-git() {
	eval $(ssh-agent) && ssh-add ~/.ssh/id_ed25519
}

unlock-nym() {
	eval $(ssh-agent) && ssh-add ~/.ssh/nym-nodes-key
}

################################################################################

#################################### PATH(42) ##################################

export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.local/bin"

################################################################################

# Se o diretório não existir, confirme o caminho dentro do Android Studio em:
# Settings > Languages & Frameworks > Android SDK
export ANDROID_HOME=$HOME/Android/Sdk

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

################################### HISTORY ####################################

HISTCONTROL="ignoredups:ignorespace"

################################################################################


################################### PROMPT #####################################

## Git info ##

function in_git() {
	git status 2> /dev/null > /dev/null
	if [ $? -eq 0 ]
	then
		return 0
	fi
	return 1
}

function git_ahead() {
	git=$(git status 2> /dev/null | grep "Your branch is ahead")
	[[ -n "$git" ]] && printf "󱧳"
}

function git_mod() {
	git=$(git status 2> /dev/null | grep "git add")
	[[ -n "$git" ]] && printf "⨯"
}

function git_staged() {
	git=$(git status 2> /dev/null | grep "Changes to be committed:")
	[[ -n "$git" ]] && printf ""
}

function git_clean() {
	git=$(git status 2> /dev/null | grep "nothing to commit")
	[[ -n "$git" ]] && printf "󰡕"
}

function git_branch() {
	branch=$(git branch 2> /dev/null | awk '/\*/{print $2}')
	dir=$(basename "$PWD")
    if [ "$dir" != "$branch" ]
	then
		printf "($branch)" ;
    fi
}

## Environment info ##

function put_arrow() {
	printf ""
}

# Set the prompt.

function set_prompt() {
if $(in_git)
then
PS1='\
\[$(tput setaf 172)\]{\
\[$(tput setaf 76)\]$(git_clean)\
\[$(tput setaf 190)\]$(git_staged)\
\[$(tput setaf 196)\]$(git_mod)\
\[$(tput setaf 33)\]$(git_ahead)\
\[$(tput setaf 201)\]$(git_branch)\
\[$(tput setaf 172)\]} \
\[$(tput setaf 51)\]\W\
\[$(tput sgr0)\]\[$(tput setaf 40)\]  '${clr}
else
PS1='\
\[$(tput setaf 51)\]\W\
\[$(tput sgr0)\]\[$(tput setaf 40)\]  '${clr}
fi
}

PROMPT_COMMAND='set_prompt'

################################################################################
