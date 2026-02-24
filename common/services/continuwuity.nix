{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.foehammer.services.continuwuity;
in
{
  options.foehammer.services.continuwuity = {
    enable = mkEnableOption "Enable matrix homeserver";

    port = mkOption {
      type = lib.types.port;
      default = 6167;
      description = ''
        What external port to serve over.
      '';
    };

    domain = mkOption {
      type = lib.types.str;
    };

    signups = mkOption {
      type = lib.types.bool;
      default = false;
    };

    allowEncryption = mkOption {
      type = lib.types.bool;
      default = false;
    };

    ldap = {
      addr = mkOption {
        type = types.str;
        description = "LDAP URL";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to LDAP service account password file";
      };

      baseDN = mkOption {
        type = types.str;
        example = "DC=example,DC=com";
      };

      user = mkOption {
        type = types.str;
        example = "UID=authelia,OU=people,DC=example,DC=com";
      };

      filter = mkOption {
        type = types.str;
        default = "(&(objectClass=person)(memberOf=matrix))";
      };

      admin_filter = mkOption {
        type = types.str;
        default = "(&(objectClass=person)(memberOf=matrix-admin))";
      };

      uid_attribute = mkOption {
        type = types.str;
        default = "uid";
      };

      display_attribute = mkOption {
        type = types.str;
        default = "cn";
      };
    };
  };

  config = mkIf cfg.enable {
    services.matrix-continuwuity = {
      enable = true;
      settings = {
        global = {
          server_name = cfg.domain;
          port = [ cfg.port ];
          allow_registration = false;
          allow_encryption = cfg.allowEncryption;
          allow_federation = false;
          new_user_displayname_suffix = "😃";
          database_backup_path = "/opt/continuwuity-db-backups";
          require_auth_for_profile_requests = true;
          allow_room_creation = true;

          ldap = {
            enable = true;
            ldap_only = true;
            uri = cfg.ldap.addr;
            base_dn = cfg.ldap.baseDN;
            bind_dn = cfg.ldap.user;
            bind_password_file = cfg.ldap.passwordFile;
            filter = cfg.ldap.filter;
            uid_attribute = cfg.ldap.uid_attribute;
            name_attribute = cfg.ldap.display_attribute;
            admin_base_dn = cfg.ldap.baseDN;
            admin_filter = cfg.ldap.admin_filter;
          };
        };
      };
    };

    systemd.services.continuwuity.serviceConfig.DynamicUser = lib.mkForce false;
  };
}
