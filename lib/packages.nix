pkgs: let
  getPackages = dir: let
    entries = builtins.readDir dir;

    procEntry = name: type: let
      path = dir + "/${name}";
    in
      if type == "directory"
      then
        (
          if builtins.pathExists (path + "/default.nix")
          then [path]
          else []
        )
      else [];
  in
    builtins.concatLists (
      builtins.attrValues (
        builtins.mapAttrs procEntry entries
      )
    );

  buildPackage = path: {
    name = builtins.baseNameOf (toString path);
    value = pkgs.callPackage (path + "/default.nix") {};
  };
in
  builtins.listToAttrs (builtins.map buildPackage (getPackages ../packages))
