{ self, input, ... }: {
    flake.nixosModules.desktopenv = { pkgs, lib, ... }: {
        programs.hyprland = {
            enable = true;
            withUWSM = true;
            xwayland.enable = true;
        };

        programs.chromium = {
            enable = true;
            extensions = [
                "dbepggeogbaibhgnhhndojpepiihcmeb;https://clients2.google.com/service/update2/crx" # vimium
                "aeblfdkhhhdcdjpifhhbdiojplfjncoa;https://clients2.google.com/service/update2/crx" # 1password
                "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx" # dark reader
            ];
        };

        environment.systemPackages = with pkgs; [
            chromium
            nautilus
            wl-clipboard
            xdg-desktop-portal-gtk
            xdg-desktop-portal-hyprland
            swaybg
            fcitx5
	    brightnessctl
            fcitx5-gtk
            libsForQt5.fcitx5-qt
            yaru-theme
	    impala
        ];
    };
}
