{...}: {
  flake.nixosModules.development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      go
      rustc
      cargo
      nodejs_24
    ];
  };
}
