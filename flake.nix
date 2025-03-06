{
  description = "haoxiangliew's nix config";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
    fenix.url = "github:nix-community/fenix";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    emacs-lsp-booster.url = "github:slotThe/emacs-lsp-booster-flake";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs =
    inputs@{
      self,
      home-manager,
      agenix,
      nix-index-database,
      darwin,
      ...
    }:
    let
      user = "haoxiangliew";

      inherit (inputs.nixpkgs-unstable.lib) attrValues optionalAttrs singleton;
      darwinNixpkgsConfig = {
        config.allowUnfree = true;
        overlays =
          attrValues self.overlays
          ++ singleton (
            final: prev:
            (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
              inherit (final.pkgs-x86) qmk;
              inherit (final.unstable-pkgs)
                aider-chat
                bun
                # deno
                font-awesome
                material-design-icons
                nerd-fonts
                nixd
                nnn
                platformio
                ;
            })
          );
      };
    in
    {
      darwinConfigurations = {
        macbookPro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            {
              system.stateVersion = 5;
            }
            nix-index-database.darwinModules.nix-index
            ./overlays.nix
            ./hosts/macbookPro.nix
            ./modules/nix-core.nix
            ./modules/system.nix

            home-manager.darwinModules.home-manager
            {
              nixpkgs = darwinNixpkgsConfig;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                sharedModules = [
                  agenix.homeManagerModules.default
                  nix-index-database.hmModules.nix-index
                ];
                users.${user} = {
                  home.stateVersion = "24.11";
                  imports = [ ./home-manager/home.nix ];
                };
              };
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
      devShells = {
        "darwin-aarch64" =
          let
            pkgs = import inputs.nixpkgs-unstable { system = "aarch64-darwin"; };
            pkgs-x86 = import inputs.nixpkgs-unstable { system = "x86_64-darwin"; };
          in
          {
            cc = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                pkg-config
                cmake
                qt6Packages.wrapQtAppsHook
                makeWrapper
              ];
              buildInputs = with pkgs; [
                boost.dev
                qt6.full
                qt6.qtbase
              ];
              shellHook = ''
                setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
                echo "shellHook: setQtEnvironment = $setQtEnvironment"
                makeWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
                sed "/^exec/d" -i "$setQtEnvironment"
                source "$setQtEnvironment"
              '';
            };
            "darwin-x86-cc" = pkgs-x86.mkShell { };
          };
      };
      overlays = {
        darwinOverlay =
          final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (darwinNixpkgsConfig) config;
            };
            unstable-pkgs = import inputs.nixpkgs-unstable {
              system = "aarch64-darwin";
              inherit (darwinNixpkgsConfig) config;
            };
          };
      };
    };
}
