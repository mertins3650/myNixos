{ config, lib, ... }:
{
    flake.homeModules.theme = { config, lib, pkgs, ... }: {
        home.packages = with pkgs; [
            adwaita-icon-theme
            gnome-themes-extra
        ];

        gtk = {
            enable = true;

            theme = {
                name = "Adwaita-dark";
                package = pkgs.gnome-themes-extra;
            };

            iconTheme = {
                name = "Adwaita";
                package = pkgs.adwaita-icon-theme;
            };

            cursorTheme = {
                name = "Adwaita";
                package = pkgs.adwaita-icon-theme;
                size = 24;
            };
        };

        home.pointerCursor = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            size = 24;
            gtk.enable = true;
            x11.enable = true;
        };

        dconf.settings = {
            "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                gtk-theme = "Adwaita-dark";
                icon-theme = "Adwaita";
                cursor-theme = "Adwaita";
            };
        };
    };
}
