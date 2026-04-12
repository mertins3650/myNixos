{ self, inputs, ... }: {
    flake.nixosModules.desktopenv = { pkgs, lib, ... }: {
	imports = [ self.nixosModules.neovim ];
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

            extraPortals = [
                pkgs.xdg-desktop-portal-hyprland
                pkgs.xdg-desktop-portal-gtk
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

        environment.systemPackages = [
            pkgs.wl-clipboard
            pkgs.nautilus
            pkgs.glib
            pkgs.swaybg
            pkgs.brightnessctl
            pkgs.yaru-theme
            pkgs.bluetui
            pkgs.wiremix
            pkgs.impala
        ];
    };
}
