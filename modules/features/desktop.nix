{ self, input, ... }: {
    flake.nixosModules.desktopenv = { pkgs, lib, ... }: {
        programs.hyprland = {
            enable = true;
            withUWSM = true;
            xwayland.enable = true;
        };

        environment.systemPackages = with pkgs; [
            nautilus
            wl-clipboard
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            swaybg
            fcitx5
	    brightnessctl
            fcitx5-gtk
            libsForQt5.fcitx5-qt
            yaru-theme
	    bluetui
	    wiremix
	    impala
        ];
    };
}
