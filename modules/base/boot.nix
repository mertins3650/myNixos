{ self, input, ... }: {
    flake.nixosModules.base = { pkgs, lib, ... }:
    let
        archPlymouthTheme = pkgs.stdenvNoCC.mkDerivation {
            pname = "arch-plymouth-theme";
            version = "1.0";

            src = ../../defaults/plymouth;

            installPhase = ''
                mkdir -p $out/share/plymouth/themes/arch
                cp -r ./* $out/share/plymouth/themes/arch/
            '';
        };
    in {
        boot.kernelPackages = pkgs.linuxPackages_latest;

        boot = {
            kernelParams = [
                "quiet"
                "splash"
                "udev.log_level=3"
                "systemd.show_status=auto"
            ];

            consoleLogLevel = 3;

            initrd = {
                verbose = false;
                systemd.enable = true;
            };

plymouth = {
    enable = true;
    theme = "bgrt";
};

            loader = {
                timeout = 3;

                efi.canTouchEfiVariables = true;

                limine = {
                    enable = true;
                    maxGenerations = 5;
                    panicOnChecksumMismatch = false;

                    extraConfig = ''
                        interface_branding: NixOS
                        interface_branding_color: 2

                        term_background: 1a1b26
                        backdrop: 1a1b26

                        term_palette: 15161e;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;a9b1d6
                        term_palette_bright: 414868;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;c0caf5

                        term_foreground: c0caf5
                        term_foreground_bright: c0caf5
                        term_background_bright: 24283b
                    '';
                };
            };
        };

        services.displayManager = {
            defaultSession = "hyprland-uwsm";

            sddm = {
                enable = true;
                wayland.enable = true;
            };

            autoLogin = {
                enable = true;
                user = "simonm";
            };
        };

        systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";

        security.pam.services.sddm-autologin.text = pkgs.lib.mkBefore ''
            auth optional ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
            auth include sddm
        '';
    };
}
