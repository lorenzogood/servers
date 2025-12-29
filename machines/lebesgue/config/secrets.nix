{...}: {
  sops = {
    defaultSopsFile = ../secrets/main.yaml;

    secrets = let
    in {
      admin-password.neededForUsers = true;

      tskey = {};

      vaultwarden-env = {};

      restic-env = {owner = "restic";};
      restic-password = {owner = "restic";};
      restic-repository = {owner = "restic";};
    };
  };
}
