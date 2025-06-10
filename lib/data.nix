rec {
  getSSHKeys = let
    sshKeys = builtins.fromTOML (builtins.readFile ../data/ssh-keys.toml);
  in
    name: (builtins.mapAttrs (_: value: builtins.attrValues value) sshKeys)."${name}";
}
