nixpkgs: withSystem: {
  utils = import ./utils.nix;
  getSSHKeys = (import ./data.nix).getSSHKeys;
  mkSystem = (import ./nixos.nix nixpkgs withSystem).mkSystem;
}
