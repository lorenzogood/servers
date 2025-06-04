{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (toplevel @ {withSystem, ...}: {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          localSystem = system;
          config = {
            allowUnfree = true;
            allowAliases = true;
          };
          overlays = [self.overlays.default];
        };

        packages = import ./lib/packages.nix pkgs;
      };

      flake = {
        lib = import ./lib inputs.nixpkgs withSystem;
        overlays.default = final: prev: (import ./lib/packages.nix prev);

        nixosModules.default = {...}: {
          imports = self.lib.utils.findNixFiles ./common;
        };
      };
    });
}
