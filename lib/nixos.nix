nixpkgs: withSystem:
let
  foelib = import ./default.nix nixpkgs withSystem;
in
{
  mkSystem =
    hostname: host-platform: modules:
    withSystem host-platform (
      { pkgs, ... }:
      nixpkgs.lib.nixosSystem {
        modules = [
          {
            nix.registry = {
              nixpkgs.flake = nixpkgs;
              p.flake = nixpkgs;
            };
            nixpkgs.pkgs = pkgs;

            networking.hostName = hostname;
          }
        ]
        ++ modules;
        specialArgs = {
          inherit hostname foelib;
        };
      }
    );
}
