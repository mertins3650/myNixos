{...}: {
  flake.nixosModules.base = {pkgs, ...}: let
    archPlymouthTheme = pkgs.stdenvNoCC.mkDerivation {
      pname = "arch-plymouth-theme";
      version = "1.0";
      src = ../../defaults/plymouth;
      dontBuild = true;

      installPhase = ''
        themeDir=$out/share/plymouth/themes/arch

        mkdir -p "$themeDir"
        cp -r ./* "$themeDir"/

        substituteInPlace "$themeDir/arch.plymouth" \
            --replace-fail 'ImageDir=.' "ImageDir=$themeDir" \
            --replace-fail 'ScriptFile=arch.script' "ScriptFile=$themeDir/arch.script"
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
        theme = "arch";
        themePackages = [archPlymouthTheme];
      };

      loader = {
        timeout = 3;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };

        efi.canTouchEfiVariables = true;
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

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";
    security.pam.services.sddm-autologin.rules.auth.systemd_loadkey = {
      order = 0;
      control = "optional";
      modulePath = "${pkgs.systemd}/lib/security/pam_systemd_loadkey.so";
    };

    security.pam.services.sddm-autologin.rules.auth.gnome_keyring = {
      order = 10400;
      control = "optional";
      modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
    };

    security.pam.services.sddm-autologin.rules.session.gnome_keyring = {
      order = 10400;
      control = "optional";
      modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
      settings.auto_start = true;
    };
    # security.pam.services.sddm-autologin = {
    #   enableGnomeKeyring = true;
    #
    #   rules.auth.systemd_loadkey = {
    #     order = 0;
    #     control = "optional";
    #     modulePath = "${pkgs.systemd}/lib/security/pam_systemd_loadkey.so";
    #   };
    # };
    # security.pam.services.sddm-autologin.text = pkgs.lib.mkBefore ''
    #   auth optional ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
    #   auth include sddm
    # '';
  };
}
