{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf types mkOption mkEnableOption;

  format = pkgs.formats.yaml {};

  cfg = config.foehammer.services.glance;
in {
  options.foehammer.services.glance = {
    enable = mkEnableOption "Enable glance server.";

    port = mkOption {
      type = lib.types.port;
      default = 9002;
      description = ''
        What external port to serve over.
      '';
    };

    settings = mkOption {
      type = format.type;
      default = {};
    };

    pages = mkOption {
      type = format.type;
      default = [];
    };

    assetsPath = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    services.glance = {
      enable = true;
      settings =
        {
          server = {
            port = cfg.port;
            proxied = true;
          };

          assets_path = cfg.assetsPath;

          pages = cfg.pages;
        }
        // cfg.settings;
    };
  };
}
