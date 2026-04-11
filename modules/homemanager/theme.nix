{ config, lib, ... }:
{
    flake.homeModules.theme = { config, lib, pkgs, ... }: {
        home.packages = with pkgs; [
            yaru-theme
            gnome-themes-extra
        ];

        gtk = {
            enable = true;

            theme = {
                name = "Yaru-blue-dark";
                package = pkgs.yaru-theme;
            };

            gtk4.theme = config.gtk.theme;

            iconTheme = {
                name = "Yaru-blue";
                package = pkgs.yaru-theme;
            };

            cursorTheme = {
                name = "Yaru";
                package = pkgs.yaru-theme;
                size = 24;
            };
        };

        home.pointerCursor = {
            name = "Yaru";
            package = pkgs.yaru-theme;
            size = 24;
            gtk.enable = true;
            x11.enable = true;
        };

        dconf.settings = {
            "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                gtk-theme = "Yaru-blue-dark";
                icon-theme = "Yaru-blue";
                cursor-theme = "Yaru";
            };
        };
    };
}
