{ inputs, ... }:
{
  nixpkgs.overlays =
    let
      pythonPackages =
        python-packages: with python-packages; [
          # aioconsole
          matplotlib
          openpyxl
          pandas
          regex
          tkinter
        ];
      pythonOverlay = self: super: { pythonWithMyPackages = super.python3.withPackages pythonPackages; };
      packagesOverlay = final: prev: {
        apple-fonts = prev.callPackage ./packages/apple-fonts { };
        gh-classroom = prev.callPackage ./packages/gh-classroom { };
      };
      nnnOverlay = (
        self: super: {
          nnn = (
            super.nnn.override {
              withNerdIcons = true;
              withPcre = true;
            }
          );
        }
      );
    in
    [
      inputs.agenix.overlays.default
      inputs.fenix.overlays.default
      inputs.neovim-nightly.overlays.default
      inputs.emacs-lsp-booster.overlays.default
      pythonOverlay
      packagesOverlay
      nnnOverlay
    ];
}
