# Set history size and file location
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias tn='tmux new -s $(pwd | sed "s/.*\///g")'

# Default Apps
export BROWSER=/usr/bin/brave
export EDITOR=/usr/bin/nvim
export TERMINAL=/usr/bin/alacritty

# Chrome executable
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

# Default XDG base directories
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Application XDG base
# export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"               # Android
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME"/bash-completion/bash_completion # Bash Completion
export CARGO_HOME="$XDG_DATA_HOME"/cargo                                            # Rust Cargo
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker                                      # Docker
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export ELM_HOME="$XDG_CONFIG_HOME"/elm                                              # Elm
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg                                     # FFmpeg
export GOPATH="$XDG_DATA_HOME"/go                                                   # Golang
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle                                     # Gradle
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc                                # GTK 1
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc                               # GTK 2
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java             # Java
export KDEHOME="$XDG_CONFIG_HOME"/kde                                               # KDE
export TERMINFO="$XDG_DATA_HOME"/terminfo                                           # NCurses
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history                         # Node
# I use nvm, so this is should be commented
# export npm_config_prefix="$HOME"/.local/npm                                         # NPM
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export WGETRC="$XDG_CONFIG_HOME"/wget/wgetrc                                        # WGet
export DELTA_FEATURES='+side-by-side'
# export ANDROID_HOME="~/Android/Sdk"
export ANDROID_HOME="$HOME"/Android/Sdk

# less command have colors
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

export SSH_AUTH_SOCK="/tmp/ssh-agent/ssh"

# # Java Application on tiling window manager
# export _JAVA_AWT_WM_NONREPARENTING=1
# export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
# export AWT_TOOLKIT=MToolkit
# Register Path
export PATH="$PATH:\
$XDG_DATA_HOME/cargo/bin:\
$HOME/.local/npm/bin:\
$XDG_CONFIG_HOME/composer/vendor/bin:\
$HOME/Downloads/Programs/flutter/bin:\
$HOME/.local/share/go/bin:\
$GEM_HOME/bin:\
$HOME/.local/bin:\
${$(find $HOME/.local/bin -type d -printf %p:)%%:}"

export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
