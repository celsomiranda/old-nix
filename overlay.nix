{ lib, home-manager }:

final: prev: {
  celso = {
    apps = builtins.listToAttrs (builtins.map (fname: {
      name = final.lib.strings.removeSuffix ".nix" fname;
      value = final.callPackage ./apps/${fname} { };
    }) (lib.celso.allNixFiles ./apps));
  };
}
