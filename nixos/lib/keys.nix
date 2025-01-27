rec {
  getSSHKeys = name: (getKeySets ../keys)."${name}";

  getKeySets = dir: let
    entries = builtins.readDir dir;

    procEntry = name: type: let
      path = dir + "/${name}";
    in
      if type == "regular"
      then [
        {
          name = getName name;
          value = builtins.attrValues (import path);
        }
      ]
      else [];
  in
    builtins.listToAttrs (builtins.concatLists (builtins.attrValues (builtins.mapAttrs procEntry entries)));

  getName = filename: let
    parts = builtins.split "\\." filename;
    base = builtins.head (builtins.split "\\." filename);
  in
    if builtins.length parts == 1
    then filename
    else base;
}
