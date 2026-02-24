{
  config,
  lib,
  pkgs,
  ...
}:
{
  foehammer = {
    users.admin = {
      enable = true;
      hashedPasswordFile = config.sops.secrets.admin-password.path;
    };

    services.goatcounter = {
      enable = true;
    };

    services.forgejo = {
      enable = true;
      domain = "forge.foehammer.me";
      ssh-domain = "lebesgue";
    };

    services.authelia = {
      enable = true;
      domain = "foehammer.me";
      url = "https://auth.foehammer.me";
      jwtSecretFile = config.sops.secrets.authelia-jwtsecret.path;

      userDbFile = config.sops.secrets.authelia-users.path;
      # oidcIssuerPrivateKeyFile = config.sops.secrets.authelia-oidc-privkey.path;
      # oidcHmacSecretFile = config.sops.secrets.authelia-oidc-hmac.path;
      sessionSecretFile = config.sops.secrets.authelia-session-secret.path;
      storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption.path;

      ldap = {
        addr = "ldap://localhost:${toString config.foehammer.services.lldap.ldap_port}";
        baseDN = config.foehammer.services.lldap.base_dn;
        user = "UID=authelia,OU=people,${config.foehammer.services.lldap.base_dn}";
        passwordFile = config.sops.secrets.authelia-lldap-password.path;
      };
    };

    services.continuwuity = {
      enable = true;
      domain = "matrix.foehammer.me";
      signups = false;
      allowEncryption = false;

      ldap = {
        addr = "ldap://localhost:${toString config.foehammer.services.lldap.ldap_port}";
        baseDN = config.foehammer.services.lldap.base_dn;
        user = "UID=authelia,OU=people,${config.foehammer.services.lldap.base_dn}";
        passwordFile = config.sops.secrets.continuwuity-ldap-password.path;
      };
    };

    services.lldap = {
      enable = true;
      url = "https://lldap.foehammer.me";
      base_dn = "DC=foehammer,DC=me";

      adminUserPasswordFile = config.sops.secrets.lldap-admin-password.path;
    };

    services.vaultwarden = {
      enable = true;
      domain = "https://passwords.foehammer.me";
      signups = false;
      envPath = config.sops.secrets.vaultwarden-env.path;
    };

    backups.restic = {
      enable = true;

      repositoryFile = config.sops.secrets.restic-repository.path;
      environmentFile = config.sops.secrets.restic-env.path;
      passwordFile = config.sops.secrets.restic-password.path;

      paths = [
        "/var/lib/vaultwarden"
        "/var/lib/authelia"
        "/var/lib/forgejo"
      ];
    };

    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "24.11";
}
