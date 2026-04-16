{ self, inputs, ... }: {
  flake.nixosModules.t14Configuration = { ... }: {
  imports =
    [ 
        inputs.home-manager.nixosModules.home-manager
	self.nixosModules.t14Hardware
	self.nixosModules.homemanager
	self.nixosModules.gaming
	self.nixosModules.desktopenv
	self.nixosModules.development
	self.nixosModules.base
	self.nixosModules.madGpuPower
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

	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = [ "amdgpu" ];
	hardware.cpu.amd.updateMicrocode = true;
  networking.hostName = "t14"; # Define your hostname.
services.thermald.enable = true;


    
  system.stateVersion = "25.11"; # Did you read the comment?

};

  }

