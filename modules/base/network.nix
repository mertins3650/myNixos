
{ ... }: {
  flake.nixosModules.base = {  ...}: {
networking.wireless.iwd.enable = true;
};
}
