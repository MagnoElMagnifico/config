#### PROFILE ####
set -gx TERM xterm-256color
set -gx HISTSIZE 1000
set -gx HISTFILESIZE 3000

# Programs
set -gx BROWSER brave-browser
set -gx EDITOR nvim
set -gx MANPAGER less
set -gx PAGER less

# PATH
if test -d $HOME/.local/bin
    fish_add_path $HOME/.local/bin
end

if test -d $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end

if test -d $HOME/Downloads/emsdk
    fish_add_path --path $HOME/Downloads/emsdk $HOME/Downloads/emsdk/upstream/emscripten
end

# if test -d $HOME/.opam/default/bin
#     fish_add_path --path $HOME/.opam/default/bin
# end

if test -d /opt/bin
    fish_add_path --append /opt/bin
end

# Set XDG basedirs.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
set -q XDG_CONFIG_HOME; or set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -Ux XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -Ux XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME; or set -Ux XDG_CACHE_HOME $HOME/.cache

#### INTERACTIVE ####

if status is-interactive
    # NOTE: when the list is big enough, move to conf.d/ directory

    #### ALIASES ####
    # Navigation
    alias ..='cd ..'
    alias ...='cd ../..'
    alias .3='cd ../../..'
    alias .4='cd ../../../..'
    alias .5='cd ../../../../..'

    # Activate colors and flags
    alias ip='ip --color=auto'
    alias diff='diff --color=auto -u'
    alias df='df -h'

    alias rm='rm -iv'
    alias mv='mv -iv'
    alias cp='cp -iv'

    alias cat='bat --theme="Visual Studio Dark+"'
    alias icat='wezterm imgcat'

    # Recurrently used commands
    abbr --add up 'sudo dnf update && flatpak update'
end

