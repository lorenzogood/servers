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

    services.vaultwarden = {
      enable = true;
      domain = "https://passwords.foehammer.me";
      signups = false;
      envPath = config.sops.secrets.vaultwarden-env.path;
    };
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tskey.path;
    openFirewall = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.trustedInterfaces = ["tailscale0"];

  system.stateVersion = "24.11";
}
