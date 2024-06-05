{
  config,
  pkgs,
  lib,
  ...
}:
{
  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      # disable Chrome native DNS resolver
      if [ -d '/Applications/Google Chrome.app' ]; then
        defaults write com.google.Chrome BuiltInDnsClientEnabled -bool false
      fi
      # if Spotify.app exists, set the app icon to macOS-compliant
      if [ -d /Applications/Spotify.app ]; then
        /opt/homebrew/bin/fileicon set /Applications/Spotify.app ./hosts/icons/Spotify/Icon.icns
      fi
      # disable saving to keychain for GPG
      defaults write org.gpgtools.common DisableKeychain -bool true
      # reset the order of the launchpad and size of dock
      defaults write com.apple.dock ResetLaunchPad -bool true
      defaults write com.apple.dock tilesize -integer 64
      defaults write com.apple.dock size-immutable -bool yes
      killall Dock
      # if Emacs.app exists, reset Emacs to /Applications and enable natural title bar
      # if [ -d /opt/homebrew/opt/emacs-mac/Emacs.app ]; then
      #   rm -rf /Applications/Emacs.app
      #   cp -r /opt/homebrew/opt/emacs-mac/Emacs.app /Applications
      #   defaults write org.gnu.Emacs TransparentTitleBar DARK
      # elif [ -d /Applications/Emacs.app ]; then
      #   rm -rf /Applications/Emacs.app
      #   defaults delete org.gnu.Emacs TransparentTitleBar
      # fi
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;
      dock = {
        autohide = false;
        show-recents = false;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
      CustomUserPreferences = {
        ".GlobalPreferences" = {
          "com.apple.mouse.linear" = 1;
          AppleSpacesSwitchOnActivate = false;
        };
        NSGlobalDomain = {
          WebKitDeveloperExtras = true;
          ApplePressAndHoldEnabled = false;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
        "com.apple.ImageCapture".disableHotPlug = true;
      };
      loginwindow.GuestEnabled = false;
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  environment = {
    variables = {
      CLICOLOR = "1";
      EDITOR = "emacs -nw";
      FZF_DEFAULT_COMMAND = "fd --type file --color=always --strip-cwd-prefix --hidden --exclude .git";
      FZF_DEFAULT_OPTS = "--ansi";
      TERMINFO_DIRS = lib.mkForce "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    };
    # The world runs on GNU
    systemPackages = with pkgs; [
      coreutils-full
      curl
      diffutils
      ed
      findutils
      gawk
      gnugrep
      gnumake
      gnupatch
      gnused
      gnutar
      gnutls
      gzip
      indent
      less
      rsync
      screen
      unixtools.getopt
      wdiff
      wget
      which
    ];
  };

  programs = {
    bash.enable = true;
    fish = {
      enable = true;
      loginShellInit =
        let
          # This naive quoting is good enough in this case. There shouldn't be any
          # double quotes in the input string, and it needs to be double quoted in case
          # it contains a space (which is unlikely!)
          dquote = str: ''"'' + str + ''"'';
          makeBinPathList = map (path: path + "/bin");
        in
        ''
          fish_add_path --move --prepend --path ${
            lib.concatMapStringsSep " " dquote (makeBinPathList config.environment.profiles)
          }
          set fish_user_paths $fish_user_paths
        '';
    };
    zsh.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "NerdFontsSymbolsOnly"
        ];
      })
      apple-fonts
      font-awesome
      material-design-icons
    ];
  };

  users.users.haoxiangliew.home = "/Users/haoxiangliew";
}
