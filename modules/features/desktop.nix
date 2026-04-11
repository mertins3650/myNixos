{ self, inputs, ... }: {
    flake.nixosModules.desktopenv = { pkgs, lib, ... }: {
        programs.hyprland = {
            enable = true;
            withUWSM = true;
        };

        services.udisks2.enable = true;
        services.devmon.enable = true;
        services.gvfs.enable = true;
        services.xserver.updateDbusEnvironment = true;

xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
    ];

    config = {
        common = {
            default = [ "hyprland" "gtk" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };

        hyprland = {
            default = [ "hyprland" "gtk" ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
    };
};
        environment.systemPackages = with pkgs; [
            wl-clipboard
	    thunar
	nautilus
            glib
            swaybg
            brightnessctl
            yaru-theme
            bluetui
            wiremix
            impala
        ];
    };
}
