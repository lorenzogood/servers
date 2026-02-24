{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.foehammer.services.forgejo;
in
{
  options.foehammer.services.forgejo = {
    enable = mkEnableOption "Enable Gitea Server";

    port = mkOption {
      type = lib.types.port;
      default = 8225;
      description = ''
        What external port to serve over.
      '';
    };

    ssh-port = mkOption {
      type = lib.types.port;
      default = 22;
      description = ''
        Where ssh is available.
      '';
    };

    domain = mkOption {
      type = lib.types.str;
    };

    ssh-domain = mkOption {
      type = lib.types.str;
      default = cfg.domain;
    };
  };

  config = mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      lfs.enable = true;

      settings = {
        service = {
          DISABLE_REGISTRATION = true;
          SHOW_REGISTRATION_BUTTON = false;
        };
        ui = {
          SHOW_USER_EMAIL = false;
        };
        server = {
          HTTP_PORT = cfg.port;
          DOMAIN = cfg.domain;
          ROOT_URL = "https://${cfg.domain}";
          SSH_DOMAIN = cfg.ssh-domain;
          SSH_PORT = cfg.ssh-port;
        };
      };
    };
  };
}
