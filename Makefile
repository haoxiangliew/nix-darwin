UNAME_S := $(shell uname -s)

.PHONY: default setuplsp setupsh update format rm deploy deploy-debug optimize gc clean-build clean resetui resetgpg addemacs all

ifeq ($(UNAME_S),Darwin)

default: all

setupgpg:
	gpg --import ~/.gnupg/gpg-haoxiangliew.key

setuplsp:
	nix eval --json --file .nixd.nix > .nixd.json

setupsh:
	@if grep -q "/run/current-system/sw/bin/fish" /etc/shells; then \
		echo "Fish shell is already in /etc/shells"; \
	else \
		echo "Fish shell is not in /etc/shells"; \
		@read -p "Add /run/current-system/sw/bin/fish to /etc/shells? (y/N) " confirm; \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			echo "/run/current-system/sw/bin/fish" | sudo tee -a /etc/shells; \
			echo "Added fish to /etc/shells"; \
		else \
			echo "Fish not added to /etc/shells"; \
		fi; \
	fi; \
	@read -p "Change your shell to fish? (y/N) " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		chsh -s /run/current-system/sw/bin/fish; \
		echo "Shell changed to fish"; \
	else \
		echo "Shell not changed"; \
	fi

update:
	nix flake update

format:
	nixfmt -v *.nix
	nixfmt -v */*.nix

rm:
	sudo rm -f /etc/bashrc /etc/zshrc

deploy:
	nix build .#darwinConfigurations.macbookPro.system \
	  --extra-experimental-features 'nix-command flakes'
	./result/sw/bin/darwin-rebuild switch --flake .#macbookPro

deploy-debug:
	nix build .#darwinConfigurations.macbookPro.system \
	  --extra-experimental-features 'nix-command flakes' --show-trace
	./result/sw/bin/darwin-rebuild switch --flake .#macbookPro --show-trace

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

resetui:
	defaults write com.apple.dock ResetLaunchPad -bool true
	defaults write com.apple.dock tilesize -integer 64
	defaults write com.apple.dock size-immutable -bool yes
	killall Dock

resetgpg:
	gpgconf --kill gpg-agent

addemacs:
	osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@31/Emacs.app" at POSIX file "/Applications" with properties {name:"Emacs.app"}'

all: setuplsp format deploy

else

default:
	@echo "No default target for $(UNAME_S)"

endif
