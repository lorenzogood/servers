nixpkgs: withSystem: {
  utils = import ./utils.nix;
  getSSHKeys = (import ./keys.nix).getSSHKeys;
  mkSystem = (import ./nixos.nix nixpkgs withSystem).mkSystem;
}
