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
      "homebrew/services"
      "railwaycat/emacsmacport"
      "d12frosted/emacs-plus"
      "chipsalliance/verible"
    ];

    # `brew install`
    brews = [
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
        args = [
          "with-native-comp"
          "with-elrumo2-icon"
        ];
      }
      "libtool"
      "llvm"
      "libomp"
      "pngpaste"
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
          "obs"
          "openemu"
          "signal"
          "spotify"
          "steam"
          "stremio"
          "syncthing"
          "tradingview"
          "utm"
          "via"
          "visual-studio-code-insiders"
          "wezterm"
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
