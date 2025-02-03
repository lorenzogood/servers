{
  inputs = {
    common.url = "path:../../nixos";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
  };
  outputs = inputs @ {common, ...}: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
    buildNixpkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [];
      };
  in {
    nixosConfigurations.default = let
      config = common.lib.utils.findNixFiles ./config;
      modules = [inputs.sops-nix.nixosModules.sops inputs.common.nixosModules.default];
    in
      common.lib.mkSystem "lebesgue" "x86_64-linux" (config ++ modules);

    devShells = forAllSystems (system: let
      pkgs = buildNixpkgs system;
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [sops];
      };
    });
  };
}
