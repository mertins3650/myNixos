{lib, ...}: {
  flake.nixosModules.base = {
    services.power-profiles-daemon.enable = true;
    powerManagement.powertop.enable = false;
    services.thermald.enable = lib.mkDefault false;
  };
}
