{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf types mkOption mkEnableOption;

  cfg = config.foehammer.services.authelia;
in {
  options.foehammer.services.authelia = {
    enable = mkEnableOption "Enable authelia server component.";
    domain = mkOption {
      type = types.str;
      description = ''
        Authelia's domain.
      '';
    };

    url = mkOption {
      type = types.str;
      description = ''
        Authelia's url.
      '';
    };

    userDbFile = mkOption {
      type = types.path;
    };

    jwtSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your JWT secret used during identity verificaton.
      '';
    };

    oidcIssuerPrivateKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your private key file used to encrypt OIDC JWTs.
      '';
    };

    oidcHmacSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your HMAC secret used to sign OIDC JWTs.
      '';
    };

    sessionSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your session secret. Only used when redis is used as session storage.
      '';
    };

    storageEncryptionKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to your storage encryption key.
      '';
    };

    port = mkOption {
      type = lib.types.port;
      default = 9001;
      description = ''
        What external port to serve over.
      '';
    };

    settingsFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [
        "/etc/authelia/config.yml"
        "/etc/authelia/access-control.yml"
        "/etc/authelia/config/"
      ];
      description = ''
        Here you can provide authelia with configuration files or directories.
        It is possible to give authelia multiple files and use the nix generated configuration
        file set via {option}`services.authelia.<instance>.settings`.
      '';
    };

    environmentVariables = mkOption {
      type = types.attrsOf types.str;
      description = ''
        Additional environment variables to provide to authelia.
        If you are providing secrets please consider the options under {option}`services.authelia.<instance>.secrets`
        or make sure you use the `_FILE` suffix.
        If you provide the raw secret rather than the location of a secret file that secret will be preserved in the nix store.
        For more details: https://www.authelia.com/configuration/methods/secrets/
      '';
      default = {};
    };
  };

  config = mkIf cfg.enable {
    services.authelia.instances.main = {
      inherit (cfg) settingsFiles environmentVariables;

      enable = true;

      settings = {
        theme = "dark";
        default_2fa_method = "totp";
        server.address = "tcp://:${toString cfg.port}";
        log = {
          level = "info";
          format = "json";
          # file_path = "/var/log/authelia/authelia.log";
        };
        totp = {
          disable = false;
          issuer = cfg.domain;
        };
        duo_api.disable = true;

        access_control.default_policy = "two_factor";

        session.cookies = [
          {
            domain = cfg.domain;
            authelia_url = cfg.url;
          }
        ];

        notifier = {
          filesystem.filename = "/var/lib/authelia-main/notifications.txt";
        };

        authentication_backend = {
          password_change.disable = true;
          password_reset.disable = true;
          file = {
            path = cfg.userDbFile;
          };
        };

        server.endpoints.authz = {
          forward-auth = {
            implementation = "ForwardAuth";
          };
        };

        storage.local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };

      secrets = {
        inherit
          (cfg)
          jwtSecretFile
          oidcIssuerPrivateKeyFile
          oidcHmacSecretFile
          sessionSecretFile
          storageEncryptionKeyFile
          ;
      };
    };
  };
}
