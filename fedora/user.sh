#!/bin/bash

# Install cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Install other tools
pipx install mdformat mdformat-gfm mdformat-frontmatter sembr zubanls

# Fonts
mkdir -p ~/.local/share/fonts
pushd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Mononoki.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
fd -e zip -x unzip -fo {}
fc-cache -f -v
rm -f *.zip *.txt *.md LICENCE
popd

# Change default shell to fish
chsh --shell /bin/fish $USER

# Allow docker usage without sudo
sudo usermod -aG docker $USER

# TODO:
# odin ols [manual]
# godot [manual]
# typst [manual]
