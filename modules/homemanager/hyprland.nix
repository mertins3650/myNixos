{ config, ... }: {
    flake.homeModules.hyprland = { config, ... }: {
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland = {
	enable = true; # enable Hyprland
	systemd.enable = false;
	systemd.variables = ["--all"];
	settings = { 
	"$mod" = "SUPER";
	bind = [
    "$mod, D, exec, rofi -show drun -run-command \"uwsm app -- {cmd}\""
"$mod SHIFT, B, exec, firefox"
"$mod SHIFT, O, exec, ghostty"
 ];

  };
};

    home.sessionVariables = {
        TERMINAL = "xdg-terminal-exec";
        EDITOR = "nvim";
        NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
};
}
