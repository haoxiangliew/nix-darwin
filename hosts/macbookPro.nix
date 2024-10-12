{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "chipsalliance/verible"
      "d12frosted/emacs-plus"
      "homebrew/services"
      "railwaycat/emacsmacport"
      "mongodb/brew"
    ];

    # `brew install`
    brews = [
      "aspell"
      "croc"
      "deskpad"
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
        name = "emacs-plus@31";
        args = [
          "with-native-comp"
          "with-elrumo2-icon"
        ];
      }
      "libtool"
      "llvm"
      "libomp"
      "mongodb-community"
      "pngpaste"
      "supabase/tap/supabase"
      "verible"
      "verilator"
    ];

    # `brew install --cask`
    casks =
      let
        packages = [
          "anydesk"
          "arduino-ide"
          "chatgpt"
          "code-composer-studio"
          "darktable"
          "discord"
          "epic-games"
          "firefox@nightly"
          "iina"
          "insomnia"
          "keepingyouawake"
          "keka"
          "kekaexternalhelper"
          "keyboardcleantool"
          "kitty"
          "league-of-legends"
          "mac-mouse-fix"
          "microsoft-office"
          "microsoft-teams"
          "microsoft-teams@classic"
          "middleclick"
          "minecraft"
          "mongodb-compass"
          "mullvadvpn"
          "obs"
          "openemu"
          "orbstack"
          "postico"
          "signal"
          "slack@beta"
          "spotify"
          "steam"
          "stremio"
          "syncthing"
          "tradingview"
          "utm"
          "via"
          "visual-studio-code-insiders"
          "whisky"
          "xquartz"
          "zed-preview"
          "zoom"
        ];
      in
      (map (
        pkg:
        if builtins.isString pkg then
          {
            name = pkg;
            greedy = true;
          }
        else
          pkg
      ) packages)
      ++ [ ];
  };
}
