
{ self, inputs, ... }: {

  flake.nixosModules.t14Hardware = { config, lib, pkgs, modulesPath, ... }: {

imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-911434da-cb89-4044-9d68-68c772467cd4";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-911434da-cb89-4044-9d68-68c772467cd4".device = "/dev/disk/by-uuid/911434da-cb89-4044-9d68-68c772467cd4";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/04D0-6F20";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-3645a30c-d4ed-4817-a05e-61e9e4adba0b"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

};
}

