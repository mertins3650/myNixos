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
            self.homeModules.rofi
        ];

	boot.initrd.kernelModules = [ "i915" ];
  networking.hostName = "t490"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;


  users.users.simonm = {
    isNormalUser = true;
    description = "Simon Mertins";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    kitty
    wofi
    git
  ];
    xdg.terminal-exec = {
      enable = true;
   settings = {
                default = [
                    "ghostty.desktop"
                ];
            };
        };

    
programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
	   alsa-lib
            pulseaudio
            libGL
            libglvnd
            vulkan-loader
            wayland
            libxkbcommon
            libX11
            libXext
            libXcursor
            libXinerama
            libXi
            libXrandr
            libXScrnSaver
            libXxf86vm
            systemd
        ];
    };


  services.openssh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

};

  }

