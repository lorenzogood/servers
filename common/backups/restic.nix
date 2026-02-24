{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.foehammer.backups.restic;
in
{
  options.foehammer.backups.restic = {
    enable = mkEnableOption "Enable restic backups";

    repositoryFile = mkOption {
      type = types.nullOr types.path;
    };

    environmentFile = mkOption {
      type = types.nullOr types.str;
    };

    passwordFile = mkOption {
      type = types.str;
    };

    paths = mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = [ ];
    };

    exclude = mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    users.groups.restic = { };
    users.users.restic = {
      isSystemUser = true;
      group = "restic";
    };

    security.wrappers.restic = {
      source = "${pkgs.restic.out}/bin/restic";
      owner = "restic";
      group = "restic";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };

    services.restic.backups = {
      remote = {
        paths = cfg.paths;
        exclude = cfg.exclude;
        user = "restic";

        initialize = true;

        repositoryFile = cfg.repositoryFile;
        environmentFile = cfg.environmentFile;
        passwordFile = cfg.passwordFile;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
        ];
      };
    };
  };
}
