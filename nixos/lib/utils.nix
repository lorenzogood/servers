rec {
  findNixFiles = dir: let
    inherit (builtins) attrNames readDir pathExists concatMap hasSuffix;

    # Helper function to build full paths
    fullPath = name: dir + "/${name}";

    # Get directory contents
    contents = readDir dir;

    # Convert contents attrset to list of names
    names = attrNames contents;

    # Filter and process each item
    processItem = name: let
      path = fullPath name;
      type = contents.${name};
    in
      if type == "regular" && hasSuffix ".nix" name
      then [path]
      else if type == "directory" && pathExists path
      then findNixFiles path
      else [];
  in
    concatMap processItem names;
}
