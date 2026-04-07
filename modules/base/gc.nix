{ ... }: {
  flake.nixosModules.base = {  ...}: {
    nix.gc = {
        automatic = true;
        dates = "weekly";   # or "daily"
        options = "--delete-older-than 5d";
    };
  };
}
