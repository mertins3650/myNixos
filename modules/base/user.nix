{...}: {
  flake.homeModules.simonm = {lib, ...}: {
    home.username = "simonm";
    home.homeDirectory = "/home/simonm";
    home.stateVersion = "25.11";

    home.pointerCursor.enable = true;
    programs.home-manager.enable = true;
    home.activation.createWorkDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/Work"
    '';
  };
}
