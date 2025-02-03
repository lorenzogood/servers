let
  utils = import ./utils.nix;
in rec {
  getSSHKeys = name: (getKeySets ../keys)."${name}";

  getKeySets = dir: let
    entries = builtins.readDir dir;

    procEntry = name: type: let
      path = dir + "/${name}";
    in
      if type == "regular"
      then [
        {
          name = utils.getName name;
          value = builtins.attrValues (import path);
        }
      ]
      else [];
  in
    builtins.listToAttrs (builtins.concatLists (builtins.attrValues (builtins.mapAttrs procEntry entries)));
}
