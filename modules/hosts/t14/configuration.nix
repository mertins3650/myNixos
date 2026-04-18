{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.t14Configuration = {...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.t14Hardware
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

  boot.initrd.luks.devices."luks-3a74659a-7177-4e58-a91f-eac7dcc30bb5".device = "/dev/disk/by-uuid/3a74659a-7177-4e58-a91f-eac7dcc30bb5";

services.thermald.enable = true;
	boot.initrd.kernelModules = [ "i915" ];
    networking.hostName = "t14"; # Define your hostname.
hardware.cpu.intel.updateMicrocode = true;

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
