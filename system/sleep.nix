{ config, lib, ... }:

let
  cfg = config.celso.machine.sleep;

in
{
  options.celso.machine.sleep = {
    hibernateDelay = lib.mkOption {
      type = lib.types.str;
      default = "24h";
      description = "Timeout for hibernating the system from sleep.";
    };
  };

  config = {
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=${cfg.hibernateDelay}
    '';
  };
}
