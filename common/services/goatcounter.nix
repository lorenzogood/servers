{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.foehammer.services.goatcounter;
in {
  options.foehammer.services.goatcounter = {
    enable = mkEnableOption "Enable goatcounter server";

    port = mkOption {
      type = lib.types.port;
      default = 8223;
      description = ''
        What external port to serve over.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.goatcounter = {
      isSystemUser = true;
      createHome = true;
      group = "goatcounter";
    };
    users.groups.goatcounter = {};

    systemd.services.goatcounter = {
      serviceConfig = {
        User = "goatcounter";
        DynamicUser = lib.mkForce false;
      };
    };

    services.goatcounter = {
      enable = true;
      proxy = true;
      address = "0.0.0.0";
      port = cfg.port;
    };
  };
}
