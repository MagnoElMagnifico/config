#!/bin/bash

cat << EOF
      _       _    __ _ _
     | |     | |  / _(_) |
   __| | ___ | |_| |_ _| | ___  ___
  / _  |/ _ \| __|  _| | |/ _ \/ __|
 | (_| | (_) | |_| | | | |  __/\__ \\
(_)__,_|\___/ \__|_| |_|_|\___||___/

By Magno El Magnífico

EOF

SCRIPT=$(realpath "$0")
DOTDIR=$(dirname "$SCRIPT")
ASSUME_YES=false
while getopts "y" opt; do
    case $opt in
        y) ASSUME_YES=true ;;
        *) echo "Uso: $0 [-y]"; exit 1 ;;
    esac
done

# $1 Program name
# $2 src: file/directory
# $3 dst: file (if source is a file)
#         parent directory (if the source is a directory)
function create_link {
    local name="$1"
    local src="$2"
    local dst="$3"

    # Create parent directory if it does not exist
    mkdir -p "$(dirname "$dst")"

    # Ask the user to continue
    if [ "$ASSUME_YES" = false ]; then
        printf     "[+] $name: $src -> $dst\n"
        read -e -p "    Create link? [y/N] "
        if ! [[ "$REPLY" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi

    # Check if a file/directory (not link) already exists 
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        # Ask the user to overwrite
	read -e -p "    $dst already exists, want to overwrite? (data will be lost!) [y/N] "
        if ! [[ "$REPLY" =~ ^[Yy]$ ]]; then
	    return 1
        fi
	rm -rf "$dst"
    fi
    ln -sfn "$src" "$dst"
    return 0
}

create_link "Environment variables" \
    $DOTDIR/env/10-variables.conf \
    $HOME/.config/environment.d/10-variables.conf && \
    echo "Log into new session to apply changes"

create_link "User dirs" \
    $DOTDIR/env/user-dirs.dirs \
    $HOME/.config/user-dirs.dirs && \
    xdg-user-dirs-update

create_link "bashrc"       "$DOTDIR/bash/bashrc"  "$HOME/.bashrc"
create_link "bash_profile" "$DOTDIR/bash/profile" "$HOME/.bash_profile"
create_link "fish"         "$DOTDIR/fish"         "$HOME/.config/fish"
create_link "Neovim"       "$DOTDIR/nvim"         "$HOME/.config/nvim"
create_link "Git"          "$DOTDIR/git"          "$HOME/.config/git"
create_link "Yazi"         "$DOTDIR/yazi"         "$HOME/.config/yazi"
create_link "tmux"         "$DOTDIR/tmux"         "$HOME/.config/tmux"
create_link "Wezterm"      "$DOTDIR/wezterm"      "$HOME/.config/wezterm"
# create_link "Helix"        "$DOTDIR/helix"        "$HOME/.config/helix"
