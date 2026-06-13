{...}: {
  flake.homeModules.fcitx5 = {pkgs, ...}: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-gtk
          qt6Packages.fcitx5-configtool
        ];

        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";

            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "dk";
              DefaultIM = "keyboard-dk";
            };

            "Groups/0/Items/0" = {
              Name = "keyboard-dk";
              Layout = "";
            };
          };
        };
      };
    };

    home.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
    };
  };
}
