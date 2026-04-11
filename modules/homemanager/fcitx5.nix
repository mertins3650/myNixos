{ pkgs, ... }:
{
    flake.homeModules.fcitx5 = { ... }: {
        i18n.inputMethod = {
            enable = true;
            type = "fcitx5";

            fcitx5 = {
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
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
            INPUT_METHOD = "fcitx";
            SDL_IM_MODULE = "fcitx";
            GLFW_IM_MODULE = "ibus";
        };
    };
}
