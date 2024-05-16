{
  eval = {
    target = {
      args = [ "-f" "default.nix" ];
    };
  };
  formatting.command = "nixfmt -v";
  options = {
    enable = true;
    target = {
      args = [ ];
      installable = ".#darwinConfigurations.macbookPro.config";
    };
  };
}
