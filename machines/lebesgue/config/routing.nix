{ config, ... }:
{
  foehammer.caddy.enable = true;

  services.caddy = {
    virtualHosts = {
      "passwords.foehammer.me" = {
        extraConfig = ''
          reverse_proxy :${toString config.foehammer.services.vaultwarden.port}
        '';
      };
      "auth.foehammer.me" = {
        extraConfig = ''
          reverse_proxy :${toString config.foehammer.services.authelia.port}
        '';
      };
      "goatcounter.foehammer.me" = {
        extraConfig = ''
          reverse_proxy :${toString config.foehammer.services.goatcounter.port}
        '';
      };
      "forge.foehammer.me" = {
        extraConfig = ''
          reverse_proxy :${toString config.foehammer.services.forgejo.port}
        '';
      };
    };
  };
}
