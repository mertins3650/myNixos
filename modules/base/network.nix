
{ ... }: {
  flake.nixosModules.base = {  ...}: {
  networking.networkmanager.enable = true;
networking.wireless.iwd.enable = true;
networking.networkmanager.wifi.backend = "iwd";
};
}
