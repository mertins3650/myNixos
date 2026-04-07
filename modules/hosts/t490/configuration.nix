{ self, inputs, ... }: {

  flake.nixosModules.t490Configuration = { pkgs, lib, ... }: {
  imports =
    [ 
            inputs.home-manager.nixosModules.home-manager
	self.nixosModules.t490Hardware
	self.homeModules.homeuser
	self.nixosModules.desktopenv
	self.nixosModules.neovim
	self.nixosModules.development
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "t490"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.simonm = {
    isNormalUser = true;
    description = "Simon Mertins";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    kitty
    wofi
    git
    rofi
    ghostty
  ];

    
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

