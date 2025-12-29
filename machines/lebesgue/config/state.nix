{config, ...}: {
  sops.age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

  environment.persistence."/persist" = {
    directories = [
      "/var/cache/restic-backups-s3"
      "/var/lib/forgejo"
      "/var/lib/tailscale"
      "/var/lib/goatcounter"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/docker"
      "/var/lib/authelia-main"
      "/var/lib/caddy/.local/share/caddy"
      "/var/lib/vaultwarden"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/var/lib/systemd/random-seed"
    ];
  };
}
