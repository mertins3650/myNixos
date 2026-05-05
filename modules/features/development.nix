{...}: {
  flake.nixosModules.development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      go
      nodejs_24
    ];
  };
}
