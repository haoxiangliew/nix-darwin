{ pkgs, lib, ... }:

{
  environment.extraSetup = ''
    ln -sv ${pkgs.path} $out/nixpkgs
  '';

  nixpkgs.config.allowUnfree = true;

  nix = {
    configureBuildUsers = true;
    package = pkgs.nix;
    nixPath = lib.mkForce [
      { darwin-config = "$HOME/.nixpkgs/darwin-configuration.nix"; }
      "nixpkgs=/run/current-system/sw/nixpkgs"
    ];
    settings.trusted-users = [
      "root"
      "haoxiangliew"
      "@admin"
    ];
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;
}
