{config, ...}: {
  sops.age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

  environment.persistence."/persist" = {
    directories =
      [
        "/var/lib/tailscale"
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/docker"
        "/var/lib/caddy/.local/share/caddy"
      ]
      ++ config.foehammer.backups.paths;

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/var/lib/systemd/random-seed"
      "/var/lib/logrotate.status"
    ];
  };
}
