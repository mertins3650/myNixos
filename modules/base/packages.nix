{...}: {
  flake.nixosModules.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      rpi-imager
      unzip
      vim
      zip
      file-roller
    ];
  };
}
