################################### ALIASES ####################################

alias vim="nvim"

################################################################################

################################## FUNCTIONS ###################################

unlock-git() {
	eval $(ssh-agent) && ssh-add ~/.ssh/id_ed25519
}

unlock-nym() {
	eval $(ssh-agent) && ssh-add ~/.ssh/nym-nodes-key
}

################################################################################

################################## FUNCTIONS ###################################

export ANDROID_HOME=$HOME/Android/Sdk

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

################################################################################
