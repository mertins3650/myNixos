{ self, inputs, ... }: {

  flake.nixosModules.t490Configuration = { pkgs, lib, ... }: {
  imports =
    [ 
        inputs.home-manager.nixosModules.home-manager
	self.nixosModules.t490Hardware
	self.nixosModules.homemanager
	self.nixosModules.desktopenv
	self.nixosModules.neovim
	self.nixosModules.development
	self.nixosModules.base
    ];

        home-manager.users.simonm.imports = [
            self.homeModules.hyprland
            self.homeModules.waybar
            self.homeModules.keyring
            self.homeModules.terminal
            self.homeModules.theme
            self.homeModules.tmux
            self.homeModules.rofi
            self.homeModules.swayosd
            self.homeModules.mako
            self.homeModules.fontconfig
        ];

	boot.initrd.kernelModules = [ "i915" ];
  networking.hostName = "t490"; # Define your hostname.

  users.users.simonm = {
    isNormalUser = true;
    description = "Simon Mertins";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    git
  ];
    
  system.stateVersion = "25.11"; # Did you read the comment?

};

  }

