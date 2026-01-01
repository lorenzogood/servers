{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption types mkIf mkOption;

  cfg = config.foehammer.services.lldap;
in {
  options.foehammer.services.lldap = {
    enable = mkEnableOption "Enable LLDAP Server";

    url = mkOption {
      type = types.str;
    };

    port = mkOption {
      type = lib.types.port;
      default = 8226;
      description = ''
        What external port to serve over.
      '';
    };

    ldap_port = mkOption {
      type = lib.types.port;
      default = 3890;
      description = "LDAP Port";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
    };

    jwtSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your JWT secret used during identity verificaton.
      '';
    };

    adminUserPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
    };

    base_dn = mkOption {
      type = types.str;
      example = "dc=example,dc=com";
    };
  };

  config = mkIf cfg.enable {
    services.lldap = {
      enable = true;
      environmentFile = cfg.environmentFile;

      settings = {
        # Base setup.
        http_port = cfg.port;
        http_url = cfg.url;
        ldap_port = cfg.ldap_port;
        ldap_base_dn = cfg.base_dn;
        jwt_secret_file = cfg.jwtSecretFile;

        # Reproducable admin password.
        force_ldap_user_pass_reset = "always";
        ldap_user_pass_file = cfg.adminUserPasswordFile;
      };
    };

    users.users.lldap = {
      isSystemUser = true;
      createHome = true;
      group = "lldap";
    };
    users.groups.lldap = {};

    systemd.services.lldap.serviceConfig.DynamicUser = lib.mkForce false;
  };
}
