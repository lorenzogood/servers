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
      "glance.foehammer.me" = {
        extraConfig = ''
          forward_auth :${toString config.foehammer.services.authelia.port} {
            	uri /api/authz/forward-auth?rd=https://auth.foehammer.me
          		copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
          reverse_proxy :${toString config.foehammer.services.glance.port}
        '';
      };
    };
  };
}
