# Load secret environment variables
if [ -f ~/.bash_secrets ]; then
    source ~/.bash_secrets
fi

# SSH Key helpers
unlock-git() {
    eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
}

unlock-nym() {
    eval "$(ssh-agent -s)" && ssh-add ~/.ssh/nym-nodes-key
}

# Development Paths
export PATH="$PATH:$HOME/.bin"

# Java SDK
if [ -d "/usr/lib/jvm/java-17-openjdk" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
    export PATH="$JAVA_HOME/bin:$PATH"
fi

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
if [ -d "$ANDROID_HOME" ]; then
    export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/cmdline-tools/latest/bin"
fi

# Neovim
alias vim="nvim"
