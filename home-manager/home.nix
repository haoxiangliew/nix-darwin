{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  dracula-pro = {
    foreground = "#F8F8F2";

    background-lighter = "#393649";
    background-light = "#2E2B3B";
    background = "#22212C";
    background-dark = "#17161D";
    background-darker = "#0B0B0F";

    comment = "#7970A9";
    selection = "#454158";
    subtle = "#424450";

    cyan = "#80FFEA";
    green = "#8AFF80";
    orange = "#FFCA80";
    pink = "#FF80BF";
    purple = "#9580FF";
    red = "#FF9580";
    yellow = "#FFFF80";

    ansi = {
      black_0 = "#454158";
      red_1 = "#FF9580";
      green_2 = "#8AFF80";
      yellow_3 = "#FFFF80";
      blue_4 = "#9580FF";
      purple_5 = "#FF80BF";
      cyan_6 = "#80FFEA";
      white_7 = "#F8F8F2";

      bright = {
        black_8 = "#7970A9";
        red_9 = "#FFAA99";
        green_10 = "#A2FF99";
        yellow_11 = "#FFFF99";
        blue_12 = "#AA99FF";
        purple_13 = "#FF99CC";
        cyan_14 = "#99FFEE";
        white_15 = "#FFFFFF";
      };
    };
  };
in
{
  home = {
    activation = {
      removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm -f ~/.gitconfig
      '';
    };
    packages = with pkgs; [
      aria2
      fastfetch
      ffmpeg-headless
      htop
      ncdu
      p7zip
      pinentry_mac
      qmk
      speedtest-cli
      testdisk
      tree
      unzip
      xz
      yazi
      yt-dlp
      zip
      # devtools
      age
      agenix
      awscli2
      fd
      fzf
      git-trim
      jq
      postgresql
      ripgrep
      sops
      sqlfluff
      tio
      # c / c++
      clang
      clang-tools
      cmake-language-server
      cmake
      darwin.dyld
      ninja
      platformio
      # bash
      bash-language-server
      shfmt
      # html/css/json/eslint
      vscode-langservers-extracted
      eslint
      # go
      go
      gopls
      # java
      jdk
      # js
      biome
      bun
      deno
      pnpm
      svelte-language-server
      typescript-language-server
      typescript
      # latex
      pandoc
      texliveFull
      typst
      # lua
      luaPackages.lua-lsp
      stylua
      # markdown
      marksman
      # nix
      direnv
      hydra-check
      nil
      nix-diff
      nix-prefetch
      nix-tree
      nixd
      nixfmt-rfc-style
      # nodejs
      nodejs
      yarn
      # pascal
      fpc
      # python
      black
      pythonWithMyPackages
      pyright
      # rust
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      # rust-analyzer-nightly
      # yaml
      yaml-language-server
    ];
    file = {
      ".hushlogin".text = "";
      ".gnupg/gpg-agent.conf".text = ''
        pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      '';
    };
  };

  age = {
    secrets = {
      id_ed25519 = {
        file = ../secrets/id_ed25519.age;
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "600";
      };
      gcp-rsa = {
        file = ../secrets/gcp-rsa.age;
        path = "${config.home.homeDirectory}/.ssh/gcp-rsa";
        mode = "600";
      };
      gpg-haoxiangliew = {
        file = ../secrets/gpg-haoxiangliew.age;
        path = "${config.home.homeDirectory}/.gnupg/gpg-haoxiangliew.key";
        mode = "600";
      };
      gh_token = {
        file = ../secrets/gh_token.age;
        path = "${config.home.homeDirectory}/.gh_token";
        mode = "400";
      };
      expand-key = {
        file = ../secrets/expand-key.age;
        path = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        mode = "400";
      };
    };
    identityPaths = [
      "${config.home.homeDirectory}/Documents/hxSSH/id_ed25519"
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
  };

  nix = {
    settings = {
      accept-flake-config = true;
      auto-optimise-store = false; # WARN: NixOS/Nix/7273
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://aseipp-nix-cache.freetls.fastly.net"
        "https://cache.nixos.org"
      ];
      extra-trusted-substituters = [ "https://nix-community.cachix.org" ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    extraOptions = ''
      !include ${config.age.secrets.gh_token.path}
    '';
  };

  programs = {
    ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        AddKeysToAgent yes
        ForwardX11Timeout 596h
      '';
      matchBlocks = {
        rlogin = {
          hostname = "rlogin.cs.vt.edu";
          user = "haoxiangliew";
        };
        ece = {
          hostname = "ssh.ece.vt.edu";
          user = "haoxiangliew";
        };
        big-ece = {
          hostname = "big.lan.ece";
          user = "haoxiangliew";
          proxyJump = "ssh.ece.vt.edu";
        };
        github = {
          hostname = "github.com";
          user = "git";
          certificateFile = builtins.toPath ../secrets/id_ed25519.pub;
          identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
          identitiesOnly = true;
        };
        gcp-hxserver1 = {
          hostname = "hx-server1.com";
          user = "hxliew";
          certificateFile = builtins.toPath ../secrets/gcp-rsa.pub;
          identityFile = "${config.home.homeDirectory}/.ssh/gcp-rsa";
          identitiesOnly = true;
        };
      };
    };
    gpg = {
      enable = true;
      settings.use-agent = true;
      publicKeys = [
        {
          source = builtins.toPath ../secrets/gpg-haoxiangliew.pub;
          trust = "ultimate";
        }
      ];
    };
    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      userName = "Hao Xiang Liew";
      userEmail = "haoxiangliew@gmail.com";
      signing = {
        key = null;
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
    };
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-classroom
        gh-dash
        gh-eco
      ];
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui = {
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
      };
    };
    fish = {
      enable = true;
      shellInit = ''
        # init nix
        if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        end
        if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        end
        # init brew
        eval (env /opt/homebrew/bin/brew shellenv)
        # enable shell integration for ghostty
        if set -q GHOSTTY_RESOURCES_DIR
          source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
        end
        # set cursor to line
        # set fish_cursor_default line
        # enable vi mode
        # function fish_user_key_bindings
        #   fish_default_key_bindings -M insert
        #   fish_vi_key_bindings --no-erase insert
        # end
        # set fish_cursor_default block
        # set fish_cursor_insert line
        # set fish_cursor_replace_one underscore
        # set fish_cursor_replace underscore
        # set fish_cursor_external line
        # enable command-not-found handler
        function __fish_command_not_found_handler --on-event fish_command_not_found
          ${config.home.homeDirectory}/.config/fish/nix-command-not-found $argv
        end
      '';
      shellAliases = {
        s = "kitty +kitten ssh";
        checktheme = "${config.home.homeDirectory}/.config/kitty/check-theme.sh";
        ollamaupdate = "ollama list | tail -n +2 | awk '{print $1}' | xargs -I {} ollama pull {}";
      };
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    neovim = {
      enable = true;
      package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      extraLuaConfig = builtins.readFile ../config/nvim/init.lua;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };

  xdg.configFile = {
    "nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';
    "fish/nix-command-not-found" = {
      text = ''
        #!/usr/bin/env bash
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        command_not_found_handle "$@"
      '';
      executable = true;
    };
    "ghostty/config".text = ''
      font-family = "JetBrainsMono Nerd Font"
      font-size = 12
      font-thicken = true

      window-padding-x = 10
      window-padding-y = 10
      window-padding-balance = true

      theme = dark:dracula-pro,light:"Builtin Solarized Light"
      window-colorspace = display-p3

      mouse-hide-while-typing = true

      shell-integration-features = no-cursor,sudo
      cursor-style = bar
      cursor-style-blink = false
      adjust-cursor-thickness = 2

      macos-titlebar-style = tabs

      keybind = global:cmd+ctrl+`=toggle_quick_terminal
    '';
    "ghostty/themes/dracula-pro".text = ''
      palette = 0=${dracula-pro.ansi.black_0}
      palette = 1=${dracula-pro.ansi.red_1}
      palette = 2=${dracula-pro.ansi.green_2}
      palette = 3=${dracula-pro.ansi.yellow_3}
      palette = 4=${dracula-pro.ansi.blue_4}
      palette = 5=${dracula-pro.ansi.purple_5}
      palette = 6=${dracula-pro.ansi.cyan_6}
      palette = 7=${dracula-pro.ansi.white_7}
      palette = 8=${dracula-pro.ansi.bright.black_8}
      palette = 9=${dracula-pro.ansi.bright.red_9}
      palette = 10=${dracula-pro.ansi.bright.green_10}
      palette = 11=${dracula-pro.ansi.bright.yellow_11}
      palette = 12=${dracula-pro.ansi.bright.blue_12}
      palette = 13=${dracula-pro.ansi.bright.purple_13}
      palette = 14=${dracula-pro.ansi.bright.cyan_14}
      palette = 15=${dracula-pro.ansi.bright.white_15}
      background = ${dracula-pro.background}
      foreground = ${dracula-pro.foreground}
      cursor-color = ${dracula-pro.foreground}
      selection-background = ${dracula-pro.selection}
      selection-foreground = ${dracula-pro.foreground}
    '';
    "kitty/kitty.conf".source = ../config/kitty/kitty.conf;
    "kitty/current-theme.conf".text = ''
      # Dracula Pro
      foreground            ${dracula-pro.foreground}
      background            ${dracula-pro.background}
      selection_foreground  ${dracula-pro.ansi.bright.white_15}
      selection_background  ${dracula-pro.selection}

      url_color ${dracula-pro.cyan}

      # black
      color0  ${dracula-pro.ansi.black_0}
      color8  ${dracula-pro.ansi.bright.black_8}

      # red
      color1  ${dracula-pro.ansi.red_1}
      color9  ${dracula-pro.ansi.bright.red_9}

      # green
      color2  ${dracula-pro.ansi.green_2}
      color10 ${dracula-pro.ansi.bright.green_10}

      # yellow
      color3  ${dracula-pro.ansi.yellow_3}
      color11 ${dracula-pro.ansi.bright.yellow_11}

      # blue
      color4  ${dracula-pro.ansi.blue_4}
      color12 ${dracula-pro.ansi.bright.blue_12}

      # magenta
      color5  ${dracula-pro.ansi.purple_5}
      color13 ${dracula-pro.ansi.bright.purple_13}

      # cyan
      color6  ${dracula-pro.ansi.cyan_6}
      color14 ${dracula-pro.ansi.bright.cyan_14}

      # white
      color7  ${dracula-pro.ansi.white_7}
      color15 ${dracula-pro.ansi.bright.white_15}

      # Cursor colors
      cursor            ${dracula-pro.foreground}
      cursor_text_color background

      # Tab bar colors
      active_tab_foreground   ${dracula-pro.background}
      active_tab_background   ${dracula-pro.foreground}
      inactive_tab_foreground ${dracula-pro.background}
      inactive_tab_background ${dracula-pro.comment}

      # Marks
      mark1_foreground ${dracula-pro.background}
      mark1_background ${dracula-pro.red}

      # Splits/Windows
      active_border_color ${dracula-pro.foreground}
      inactive_border_color ${dracula-pro.comment}
    '';
    # "kitty/startup.conf".text = ''
    #   launch ${config.home.homeDirectory}/.config/kitty/check-theme.sh
    #   launch
    # '';
    # "kitty/check-theme.sh".source = ../config/kitty/check-theme.sh;
    "ranger/rc.conf".source = ../config/ranger/rc.conf;
  };
}
