{...}: {
  sops = {
    defaultSopsFile = ../secrets/main.yaml;

    secrets = let
      autheliaSecret = {
        owner = "authelia-main";
        sopsFile = ../secrets/authelia/secrets.yaml;
      };
    in {
      admin-password.neededForUsers = true;

      tskey = {};

      vaultwarden-env = {};

      restic-env = {owner = "restic";};
      restic-password = {owner = "restic";};
      restic-repository = {owner = "restic";};

      lldap-admin-password.owner = "lldap";

      authelia-jwtsecret = autheliaSecret;
      authelia-oidc-privkey = autheliaSecret;
      authelia-oidc-hmac = autheliaSecret;
      authelia-session-secret = autheliaSecret;
      authelia-storage-encryption = autheliaSecret;
      authelia-users = {
        owner = "authelia-main";
        sopsFile = ../secrets/authelia/users.yaml;
      };
    };
  };
}
