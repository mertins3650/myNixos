{ pkgs, ... }: {
    flake.homeModules.keyring = { pkgs, ... }: {
        programs.ghostty = {
            enable = true;
            settings = {
                theme = "Rose Pine";
                font-family = "CaskaydiaMono Nerd Font";
                font-style = "Regular";
                font-size = 16;
                window-theme = "ghostty";
                window-padding-x = 14;
                window-padding-y = 14;
                confirm-close-surface = false;
                resize-overlay = "never";
                gtk-toolbar-style = "flat";
                cursor-style = "block";
                cursor-style-blink = false;
                shell-integration-features = "no-cursor,ssh-env";
                keybind = [
                    "shift+insert=paste_from_clipboard"
                    "control+insert=copy_to_clipboard"
                    "super+control+shift+alt+arrow_down=resize_split:down,100"
                    "super+control+shift+alt+arrow_up=resize_split:up,100"
                    "super+control+shift+alt+arrow_left=resize_split:left,100"
                    "super+control+shift+alt+arrow_right=resize_split:right,100"
                ];
                mouse-scroll-multiplier = 0.95;
            };
            enableZshIntegration = true;
        };

        xdg.terminal-exec = {
            enable = true;
            package = pkgs.ghostty;
            settings = {
                default = [
                    "ghostty.desktop"
                    "kitty.desktop"
                ];
            };
        };

        home.packages = [
            pkgs.xdg-terminal-exec
        ];
    };
}
