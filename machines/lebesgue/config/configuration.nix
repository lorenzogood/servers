{
  config,
  lib,
  pkgs,
  ...
}: {
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

      paths = ["/var/lib/vaultwarden" "/var/lib/authelia" "/var/lib/forgejo"];
    };

    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tskey.path;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.allowedTCPPorts = [22];

  system.stateVersion = "24.11";
}
