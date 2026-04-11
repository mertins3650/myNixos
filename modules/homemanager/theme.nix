{ config, lib, ... }:
{
    flake.homeModules.theme = { config, lib, pkgs, ... }: {
        home.packages = with pkgs; [
            adwaita-icon-theme
            gnome-themes-extra
            glib
        ];

        gtk = {
            enable = true;

            gtk3.extraConfig = {
                gtk-application-prefer-dark-theme = 1;
            };

            gtk4.extraConfig = {
                gtk-application-prefer-dark-theme = 1;
            };

            theme = {
                name = "Adwaita-dark";
                package = pkgs.gnome-themes-extra;
            };

            gtk4.theme = null;

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
