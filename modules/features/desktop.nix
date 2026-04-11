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
  services.xserver.updateDbusEnvironment = true;

        environment.systemPackages = with pkgs; [
            nautilus
            wl-clipboard
	    glib
            swaybg
	    brightnessctl
            yaru-theme
	    bluetui
	    wiremix
	    impala
        ];
	xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
    ];

    config = {
        hyprland = {
            default = [ "hyprland" "gtk" ];

            "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        };
    };
};
    };
}
