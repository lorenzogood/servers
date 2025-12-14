{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkOption;

  cfg = config.foehammer.services.readeck;
in {
  options.foehammer.services.readeck = {
    enable = mkEnableOption "Enable readeck server";

    port = mkOption {
      type = lib.types.port;
      default = 8224;
      description = ''
        What external port to serve over.
      '';
    };

    envFile = mkOption {
      type = types.nullOr types.path;
    };

    domain = mkOption {
      type = types.str;
      description = ''
        Readeck's domain.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.readeck = {
      enable = true;
      environmentFile = cfg.envFile;
      settings = {
        server = {
          port = cfg.port;
          base_url = cfg.domain;
        };
        extractor = {
          workers = 2;
        };
      };
    };
  };
}
