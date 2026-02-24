{
  config,
  lib,
  foelib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    optionals
    types
    ;
  cfg = config.foehammer.users.admin;
in
{
  options.foehammer.users.admin = {
    enable = mkEnableOption "Enable a wheel admin user.";
    hashedPasswordFile = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };
  config = mkIf cfg.enable {
    users.users.admin = {
      createHome = true;
      description = "SSH Admin User.";
      group = "admin";

      extraGroups = [ "wheel" ] ++ optionals config.virtualisation.docker.enable [ "docker" ];
      isNormalUser = true;
      uid = 9999;

      openssh.authorizedKeys.keys = foelib.getSSHKeys "foehammer";

      hashedPasswordFile = cfg.hashedPasswordFile;
    };

    users.groups.admin.gid = config.users.users.admin.uid;
  };
}
