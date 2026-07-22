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

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];


  fileSystems."/" =
    { device = "/dev/mapper/luks-289d7bb9-103f-4ff8-9db2-ecefaa807f09";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-289d7bb9-103f-4ff8-9db2-ecefaa807f09".device = "/dev/disk/by-uuid/289d7bb9-103f-4ff8-9db2-ecefaa807f09";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E5EB-4D25";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-a3c7b431-2a4d-435a-a79c-d52211cb9d8b"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  };
}
