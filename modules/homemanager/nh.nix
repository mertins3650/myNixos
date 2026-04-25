{...}: {
  flake.homeModules.nh = {...}: {
    programs = {
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        clean.dates = "daily";
      };
    };
    home.sessionVariables = {
      NH_OS_FLAKE = "/home/simonm/myNixos";
    };
  };
}
