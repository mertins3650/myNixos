{ lib, config, pkgs, ... }:
{
    flake.nixosModules.base = {
        services.power-profiles-daemon.enable = true;
        powerManagement.powertop.enable = true;

        # Easy to override per-host if a machine does not benefit from it.
        services.thermald.enable = lib.mkDefault false;
    };
}
