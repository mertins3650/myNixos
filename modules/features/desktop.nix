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
    extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
    ];
    # Add this - creates the GTK portal config
    config.common.default = "*";
};

        environment.systemPackages = with pkgs; [
            wl-clipboard
	    thunar
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
