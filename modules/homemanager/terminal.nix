{ pkgs, ... }: {
  flake.homeModules.terminal = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;

      settings = {
        # Dynamic theme colors
        theme = "Rose Pine";

        # Font
        font-family = "CaskaydiaMono Nerd Font";
        font-style = "Regular";
        font-size = 16;

        # Window
        window-theme = "ghostty";
        window-padding-x = 14;
        window-padding-y = 14;
        confirm-close-surface = false;
        resize-overlay = "never";
        gtk-toolbar-style = "flat";

        # Cursor styling
        cursor-style = "block";
        cursor-style-blink = false;

        # Shell integration
        shell-integration-features = "no-cursor,ssh-env";

        # Keyboard bindings (list!)
        keybind = [
          "shift+insert=paste_from_clipboard"
          "control+insert=copy_to_clipboard"
          "super+control+shift+alt+arrow_down=resize_split:down,100"
          "super+control+shift+alt+arrow_up=resize_split:up,100"
          "super+control+shift+alt+arrow_left=resize_split:left,100"
          "super+control+shift+alt+arrow_right=resize_split:right,100"
        ];

        # Mouse
        mouse-scroll-multiplier = 0.95;
      };

      enableZshIntegration = true;
    };
    home.packages = [
      pkgs.xdg-terminal-exec
    ];

    xdg.terminal-exec = {
      enable = true;
      package = pkgs.ghostty;
    };
  };
}
