UNAME_S := $(shell uname -s)

.PHONY: default setup setuplsp setupsh update format rm deploy deploy-debug optimize gc clean-build clean reset resetui resetgpg addemacs all

ifeq ($(UNAME_S),Darwin)

default: all

setup:
	./setup.sh

setuplsp:
	nix eval --json --file .nixd.nix > .nixd.json

setupsh:
	@read -p "Manually add /run/current-system/sw/bin/fish to /etc/shells, done? (y/N) " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		chsh -s /run/current-system/sw/bin/fish; \
	else \
		echo "Operation cancelled"; \
	fi

update:
	nix flake update

format:
	nixfmt -v *.nix
	nixfmt -v */*.nix

rm:
	sudo rm /etc/bashrc /etc/zshrc

deploy:
	nix build .#darwinConfigurations.macbookPro.system \
	  --extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#macbookPro

deploy-debug:
	nix build .#darwinConfigurations.macbookPro.system \
	  --extra-experimental-features 'nix-command flakes' --show-trace
	./result/sw/bin/darwin-rebuild switch --flake --show-trace .#macbookPro

optimize:
	nix store optimise

gc:
	nix-collect-garbage -d
	sudo nix-collect-garbage -d

clean-build:
	rm -f flake.lock
	rm -f result
	rm -f .nixd.json

clean: clean-build gc

reset:
	./reset.sh

resetui:
	defaults write com.apple.dock ResetLaunchPad -bool true
	defaults write com.apple.dock tilesize -integer 64
	defaults write com.apple.dock size-immutable -bool yes
	killall Dock

resetgpg:
	gpgconf --kill gpg-agent

addemacs:
	osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@30/Emacs.app" at POSIX file "/Applications"'

all: setuplsp format deploy

else

default:
	@echo "No default target for $(UNAME_S)"

endif
