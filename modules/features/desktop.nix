{ self, input, ... }: {
    flake.nixosModules.desktopenv = { pkgs, lib, ... }: {
        programs.hyprland = {
            enable = true;
            withUWSM = true;
            xwayland.enable = true;
        };
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;

        environment.systemPackages = with pkgs; [
            nautilus
            wl-clipboard
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            swaybg
	    brightnessctl
            yaru-theme
	    bluetui
	    wiremix
	    impala
        ];
    };
}
