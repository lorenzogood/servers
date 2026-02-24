{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = {
    users.mutableUsers = false;

    environment.systemPackages = with pkgs; [
      neovim
      git
    ];

    networking = {
      firewall = {
        enable = true;
      };

      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      # If using dhcpcd:
      dhcpcd.extraConfig = mkIf config.networking.dhcpcd.enable "nohook resolv.conf";
      # If using NetworkManager:
      networkmanager.dns = mkIf config.networking.networkmanager.enable "none";
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
  };
}
