{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.foehammer.tailscale;
in {
  options.foehammer.tailscale = {
    enable = mkEnableOption "Enable tailscale";
    authKeyFile = mkOption {
      type = types.nullOr types.path;
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = cfg.authKeyFile;
      openFirewall = true;
    };

    networking.firewall.trustedInterfaces = ["tailscale0"];
  };
}
