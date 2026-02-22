#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit 1
fi

set -e

#### SYSTEM INSTALL ###########################################################

# Base system + KDE desktop
dnf install -y \
	@standard \
	@hardware-support \
	@multimedia \
	@fonts \
	@base-x \
	\
	sddm \
	sddm-kcm \
	sddm-breeze \
	\
	plasma-desktop \
	plasma-workspace-wayland \
	plasma-nm \
	kwallet \
	pam-kwallet \
	kscreen \
	kinfocenter \
	\
	bluedevil \
	cups \
	plasma-print-manager \
	xdg-desktop-portal-kde \
	glibc-all-langpacks \
	\
	konsole \
	firefox \
	flatpak \
	plasma-systemmonitor \
	dolphin \
	kwrite \
	spectacle \
	mpv \
	ark \
	okular \
	gwenview \
	filelight \
	elisa-player \
	skanpage \
	kamoso

#### REPO CONFIG ##############################################################

# Enable RPM Fusion
dnf install -y \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable other repos: brave-browser, docker, wezterm, yazi
dnf config-manager addrepo --from-repofile https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
dnf copr enable -y wezfurlong/wezterm-nightly
dnf copr enable -y lihaohong/yazi

# Enable repos for flatpak: flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#### INSTALL TOOLS ############################################################

# Install NVIDIA driver
dnf install -y akmod-nvidia

# My CLI tools
dnf install -y --allowerasing \
	fish \
	neovim \
	git \
	tmux \
	yazi \
	\
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin \
	\
	@c-development \
	clang \
	clang-tools-extra \
	python3 \
	pipx \
	hugo \
	java-latest-openjdk-devel \
	\
	ripgrep \
	fzf \
	fastfetch \
	bat \
	fd-find \
	\
	tokei \
	moreutils \
	rsync \
	tealdeer \
	hunspell \
	\
	traceroute \
	tcpdump \
	nmap \
	\
	jq \
	perl-Image-ExifTool \
	poppler-utils \
	tesseract \
	pandoc \
	ffmpeg \
	ImageMagick \
	yt-dlp

# Other GUI software
dnf install -y \
	wezterm \
	brave-browser \
	VirtualBox \
	calibre \
	\
	inkscape \
	gimp \
	libreoffice

flatpak install md.obsidian.Obsidian com.github.flxzt.rnote

# Install MegaSync
dnf install -y https://mega.nz/linux/repo/Fedora_43/x86_64/megasync-Fedora_43.x86_64.rpm

#### ENABLE SERVICES ##########################################################

systemctl restart vboxdrv
systemctl enable --now sddm docker
systemctl set-default graphical.target

