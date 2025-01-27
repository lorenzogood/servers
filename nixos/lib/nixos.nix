let
  foelib = import ./default.nix;
in {
  mkSystem = nixpkgs: pkgs: hostname: modules:
    nixpkgs.lib.nixosSystem {
      modules =
        [
          {
            nix.registry = {
              nixpkgs.flake = nixpkgs;
              p.flake = nixpkgs;
            };
            nixpkgs.pkgs = pkgs;

            networking.hostname = hostname;
          }
        ]
        ++ modules
        ++ foelib.utils.findNixFiles ../nixos;

      specialArgs = {
        inherit hostname foelib;
      };
    };
}
