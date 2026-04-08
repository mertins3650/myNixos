{ config, lib, ... }:
{
    flake.homeModules.theme = { config, lib, pkgs, ... }: {
        home.packages = with pkgs; [
            yaru-theme
            gnome-themes-extra
            adwaita-icon-theme
        ];

        gtk = {
            enable = true;

            theme = {
                name = "Yaru-dark";
                package = pkgs.yaru-theme;
            };

            gtk4.theme = config.gtk.theme;

            iconTheme = {
                name = "Yaru";
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
                gtk-theme = "Yaru-dark";
                icon-theme = "Yaru";
                cursor-theme = "Yaru";
            };
        };
    };
}
