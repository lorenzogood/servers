{config, ...}: {
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
    };
  };
}
