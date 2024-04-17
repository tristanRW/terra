{
  config,
  lib,
  ...
}:
let
  cfg = config.terra.user;

  inherit (lib) types mkOption mkDoc;
in {
  options.terra.user = {
    name = mkOption{
      type = types.str;
      default = "user";
      description = mkDoc "The username of the main user for this system. default is \"user\"";
    };
    hashedPassword = mkOption{
      type = types.str;
      default = "$6$aDKd1PtD2Dddg58E$9UjPzxv.D6aqFKox6ROyku.WycuKjeZprYHOBg.P4EdTZ8eKdsrZd4mj0Rm.Eks059Zp0G0YycqYhicjgXYMQ0";
      description = mkDoc "The hashed password for the main user. default is \"resu\"";
    };
    isAdministrator = mkOption{
      type = types.bool;
      default = true;
      description = mkDoc "Whether the user should be an administrator. True by default.";
    };
    groups = mkOption{
      type = types.listOf types.str;
      default = [];
      description = mkDoc "The groups the main user should be in.";
    };
  };

  config = {
    users.mutableUsers = false;

    users.groups."${cfg.name}" = {
      name = "${cfg.name}";
      gid = 1000;
    }; #create the users own group

    users.users."${cfg.name}" = {
      isNormalUser = true;
      home = "/home/${cfg.name}";
      createHome = true; #always set homedir permissions to user
      extraGroups =
      let
        groups = cfg.groups
        ++ (if cfg.isAdministrator then [ "wheel" ] else []) #add wheel if user is admin
        ++ ["${cfg.name}"]; #add user's own group
      in groups;
      hashedPassword = "${cfg.hashedPassword}";
    };
  };
}