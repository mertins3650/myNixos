{ self, inputs, ... }: {

  flake.nixosModules.t490Hardware = { config, lib, pkgs, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e46b0e55-c5ad-4a30-9b37-e7322b140edd";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EC96-5AAA";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2084e4b6-2cc5-4b90-a023-6470a23a1cbc"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
};
}
