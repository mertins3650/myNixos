{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktopConfiguration = {pkgs, ...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.base
      self.nixosModules.desktopHardware
      self.nixosModules.desktopenv
      self.nixosModules.development
      self.nixosModules.docker
      self.nixosModules.gaming
      self.nixosModules.homemanager
      self.nixosModules.neovim
    ];

    home-manager.users.simonm.imports = [
      self.homeModules.zenbrowser
      self.homeModules.chromium
      self.homeModules.fcitx5
      self.homeModules.fontconfig
      self.homeModules.git
      self.homeModules.homepackages
      self.homeModules.hypridle
      self.homeModules.hyprland
      self.homeModules.hyprlock
      self.homeModules.keyring
      self.homeModules.mako
      self.homeModules.nh
      self.homeModules.rofi
      self.homeModules.scripts
      self.homeModules.shell
      self.homeModules.swayosd
      self.homeModules.terminal
      self.homeModules.theme
      self.homeModules.tmux
      self.homeModules.waybar
    ];
    boot.initrd.luks.devices."luks-aef71664-5c85-4be2-a5f0-aab09ab77baf".device = "/dev/disk/by-uuid/aef71664-5c85-4be2-a5f0-aab09ab77baf";

    services.thermald.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];
    networking.hostName = "desktop"; # Define your hostname.
    hardware.cpu.amd.updateMicrocode = true;
    hardware.graphics.enable = true;
    environment.systemPackages = with pkgs; [
      orca-slicer
    ];

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
