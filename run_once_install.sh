#!/bin/bash
install-ble() {
	curl -LO https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz
	tar xJf ble-nightly.tar.xz
	bash ble-nightly/ble.sh --install ~/.local/share
	[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none
	[[ ! ${BLE_VERSION-} ]] || ble-attach
	rm -r ble-nightly ble-nightly.tar.xz
}

install-gtk-theme() {
    git clone https://github.com/vinceliuice/Graphite-gtk-theme gtk-theme && cd gtk-theme
    ./install.sh -d ~/.local/share/themes -t default -c dark -s compact -l --tweaks darker
    cd .. && rm -r gtk-theme
}

install-dependencies() {
	deps=$1

	for pkg in $(cat $deps); do
	    if ! pacman -Q "$pkg" &>/dev/null; then
		echo "Installing: $pkg"
		yay -S --needed --noconfirm "$pkg"
	    else
		echo "Already installed: $pkg"
	    fi
	done
}

set -e

install-ble
install-gtk-theme
install-dependencies "$CHEZMOI_SOURCE_DIR/requirements.txt"
