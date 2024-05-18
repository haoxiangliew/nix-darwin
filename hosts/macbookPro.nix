{ pkgs, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      "railwaycat/emacsmacport"
      "d12frosted/emacs-plus"
      "chipsalliance/verible"
      "nextfire/tap"
    ];

    # `brew install`
    brews = [
      {
        name = "apple-music-discord-rpc";
        restart_service = true;
      }
      "aspell"
      "croc"
      "fileicon"
      "gstreamer"
      # {
      #   name = "emacs-mac";
      #   args = [
      #     "HEAD"
      #     "with-emacs-big-sur-icon"
      #     "with-ctags"
      #     "with-natural-title-bar"
      #     "with-starter"
      #     "with-mac-metal"
      #     "with-native-compilation"
      #     "with-xwidgets"
      #     "with-unlimited-select"
      #   ];
      # }
      {
        name = "emacs-plus@30";
        args = [ "with-native-comp" "with-elrumo2-icon" ];
      }
      "libtool"
      "llvm"
      "libomp"
      "pngpaste"
      "verible"
      "verilator"
    ];

    # `brew install --cask`
    casks = [
      "anydesk"
      "arduino-ide"
      "code-composer-studio"
      "crossover"
      "darktable"
      "discord"
      "epic-games"
      "iina"
      "keepingyouawake"
      "keka"
      "kekaexternalhelper"
      "keyboardcleantool"
      "kitty"
      "mac-mouse-fix"
      "microsoft-office"
      "microsoft-teams"
      "middleclick"
      "minecraft"
      "obs"
      "openemu"
      "signal"
      "spotify"
      "steam"
      "stremio"
      "syncthing"
      "utm"
      "via"
      "visual-studio-code-insiders"
      "xquartz"
      "zed-preview"
      "zoom"
    ];
  };
}
