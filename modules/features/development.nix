{...}: {
  flake.nixosModules.development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      go
      rustc
      nodejs_24
    ];
  };
}
