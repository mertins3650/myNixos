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
    { device = "/dev/mapper/luks-a491326e-974b-4c66-8b8c-17a265d3a04a";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-a491326e-974b-4c66-8b8c-17a265d3a04a".device = "/dev/disk/by-uuid/a491326e-974b-4c66-8b8c-17a265d3a04a";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/28BB-111F";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-591ffa23-9bd4-4b4c-8d46-2698e163086b"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
};
}

