{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.foehammer.caddy;
in {
  options.foehammer.caddy.enable = mkEnableOption "Enable caddy with default configuration.";
  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      email = "foehammer127+acme@gmail.com";
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
