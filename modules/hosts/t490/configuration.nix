{ self, inputs, ... }: {

  flake.nixosModules.t490Configuration = { pkgs, lib, ... }: {
  imports =
    [ 
        inputs.home-manager.nixosModules.home-manager
	self.nixosModules.t490Hardware
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
        ];

	boot.initrd.kernelModules = [ "i915" ];
  networking.hostName = "t490"; # Define your hostname.
services.thermald.enable = true;

  users.users.simonm = {
    isNormalUser = true;
    description = "Simon Mertins";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim 
  ];
    
  system.stateVersion = "25.11"; # Did you read the comment?

};

  }

