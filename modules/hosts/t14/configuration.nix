{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.t14Configuration = {pkgs, ...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.base
      self.nixosModules.t14Hardware
      self.nixosModules.desktopenv
      self.nixosModules.development
      self.nixosModules.docker
      self.nixosModules.gaming
      self.nixosModules.homemanager
      self.nixosModules.neovim
    ];

    home-manager.users.simonm.imports = [
      self.homeModules.zen
      self.homeModules.defaultapps
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

    services.thermald.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];
    networking.hostName = "t14"; # Define your hostname.
    hardware.cpu.amd.updateMicrocode = true;
    hardware.graphics.enable = true;
    environment.systemPackages = with pkgs; [
      orca-slicer
    ];

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
