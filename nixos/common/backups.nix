{lib, ...}: let
  inherit (lib) mkOption types;
in {
  # Generic Backups.
  options.foehammer.backups = {
    paths = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = [];
    };
  };
}
