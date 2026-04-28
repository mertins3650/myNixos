{...}: {
  flake.nixosModules.t14Hardware = {
    config,
    lib,
    modulesPath,
    ...
  }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-e307504c-9a5f-44bd-ac4a-a0b97f5bc707";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-e307504c-9a5f-44bd-ac4a-a0b97f5bc707".device = "/dev/disk/by-uuid/e307504c-9a5f-44bd-ac4a-a0b97f5bc707";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C0FE-5003";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-36de1782-d627-41c9-8c32-902f06423faa"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  };
}
