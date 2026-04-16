{...}: {
  flake.nixosModules.t14Hardware = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci_renesas" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/mapper/luks-d0cce0c7-7905-48f2-bba0-a2a538c97e06";
      fsType = "ext4";
    };

    boot.initrd.luks.devices."luks-d0cce0c7-7905-48f2-bba0-a2a538c97e06".device = "/dev/disk/by-uuid/d0cce0c7-7905-48f2-bba0-a2a538c97e06";

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/7014-4436";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [
      {device = "/dev/mapper/luks-d9bb10f0-216f-4784-b8a1-f52c0f323447";}
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
