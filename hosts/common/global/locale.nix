{ lib, ... }: {
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME =           lib.mkDefault "pt_PT.UTF-8";
      LC_ADDRESS =        lib.mkDefault "pt_PT.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "pt_PT.UTF-8";
      LC_MEASUREMENT =    lib.mkDefault "pt_PT.UTF-8";
      LC_MONETARY =       lib.mkDefault "pt_PT.UTF-8";
      LC_NAME =           lib.mkDefault "pt_PT.UTF-8";
      LC_NUMERIC =        lib.mkDefault "pt_PT.UTF-8";
      LC_PAPER =          lib.mkDefault "pt_PT.UTF-8";
      LC_TELEPHONE =      lib.mkDefault "pt_PT.UTF-8";

    };
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "pt_PT.UTF-8/UTF-8"
    ];
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  time.timeZone = lib.mkDefault "Europe/Lisbon";
}
