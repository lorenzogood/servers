{
  pkgs,
  config,
  ...
}: let
  paths = ["/var/lib/vaultwarden"];
  exclude = [];

  secrets = config.sops.secrets;
in {
  users.groups.restic = {};
  users.users.restic = {
    isSystemUser = true;
    group = "restic";
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "restic";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic.backups = {
    s3 = {
      inherit paths exclude;
      user = "restic";

      repositoryFile = secrets.restic-repository.path;
      environmentFile = secrets.restic-env.path;
      passwordFile = secrets.restic-password.path;

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
      ];
    };
  };
}
