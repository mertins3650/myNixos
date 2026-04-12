{ self, inputs, ... }: {
    flake.nixosModules.desktopenv = { pkgs, lib, self', ... }: {
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
environment.systemPackages = [
    self'.packages.neovim
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
