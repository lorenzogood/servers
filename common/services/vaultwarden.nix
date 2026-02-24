{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.foehammer.services.vaultwarden;
in
{
  options.foehammer.services.vaultwarden = {
    enable = mkEnableOption "Enable Vaultwarden Server";

    port = mkOption {
      type = lib.types.port;
      default = 8222;
      description = ''
        What external port to serve over.
      '';
    };

    signups = mkOption {
      type = lib.types.bool;
      default = false;
    };

    envPath = mkOption {
      type = lib.types.path;
    };

    domain = mkOption {
      type = lib.types.str;
    };
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;

      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
        DOMAIN = cfg.domain;
        ROCKET_LOG = "critical";
        SIGNUPS_ALLOWED = cfg.signups;
      };

      environmentFile = cfg.envPath;
    };
  };
}
