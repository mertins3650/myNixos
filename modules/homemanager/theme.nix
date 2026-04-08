{ config, lib, pkgs, ... }:
{
    flake.homeModules.theme = { config, lib, theme, ... }: {
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

dconf.settings = {
    "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
    };
};

};
}
