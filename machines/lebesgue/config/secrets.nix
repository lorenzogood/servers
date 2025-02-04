{...}: {
  sops = {
    defaultSopsFile = ../secrets/main.yaml;

    secrets = {
      admin-password.neededForUsers = true;
      tskey = {};
      vaultwarden-env = {};
    };
  };
}
