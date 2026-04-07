{ config, ... }: {
    flake.homeModules.hyprland = {
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland = {
	enable = true; # enable Hyprland
	systemd.enable = false;
	systemd.variables = ["--all"];
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
