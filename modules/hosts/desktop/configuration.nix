{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktopConfiguration = {...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.desktopHardware
      self.nixosModules.homemanager
      self.nixosModules.gaming
      self.nixosModules.desktopenv
      self.nixosModules.development
      self.nixosModules.base
      self.nixosModules.neovim
    ];

    home-manager.users.simonm.imports = [
      self.homeModules.hyprland
      self.homeModules.hypridle
      self.homeModules.fcitx5
      self.homeModules.nh
      self.homeModules.hyprlock
      self.homeModules.waybar
      self.homeModules.chromium
      self.homeModules.keyring
      self.homeModules.scripts
      self.homeModules.terminal
      self.homeModules.theme
      self.homeModules.tmux
      self.homeModules.rofi
      self.homeModules.shell
      self.homeModules.swayosd
      self.homeModules.mako
      self.homeModules.fontconfig
      self.homeModules.git
      self.homeModules.homepackages
    ];
  boot.initrd.luks.devices."luks-aef71664-5c85-4be2-a5f0-aab09ab77baf".device = "/dev/disk/by-uuid/aef71664-5c85-4be2-a5f0-aab09ab77baf";


    services.thermald.enable = true;
services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];
    networking.hostName = "desktop"; # Define your hostname.
 hardware.cpu.amd.updateMicrocode = true;
hardware.graphics.enable = true;

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
