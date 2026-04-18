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
    { device = "/dev/mapper/luks-2dbcf090-86b0-4a3b-9171-caef7eb2c89d";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-2dbcf090-86b0-4a3b-9171-caef7eb2c89d".device = "/dev/disk/by-uuid/2dbcf090-86b0-4a3b-9171-caef7eb2c89d";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/270E-5825";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-3a74659a-7177-4e58-a91f-eac7dcc30bb5"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  };
}
