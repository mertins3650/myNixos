{...}: {
  flake.nixosModules.desktopHardware = {
    config,
    lib,
    modulesPath,
    ...
  }: {
imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-9c2def3c-10e3-4394-8037-51a5ddeb1679";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-9c2def3c-10e3-4394-8037-51a5ddeb1679".device = "/dev/disk/by-uuid/9c2def3c-10e3-4394-8037-51a5ddeb1679";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4F70-B4AA";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-aef71664-5c85-4be2-a5f0-aab09ab77baf"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


  };
}
