{...}: {
  flake.homeModules.hyprland = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    home.packages = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd.enable = false;
      systemd.variables = ["--all"];
    };
    home.file.".local/share/hypr/stubs".source = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/hypr/stubs";

    xdg.configFile."hypr/hyprland.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/hyprland.lua";

    home.sessionVariables = {
      TERMINAL = "xdg-terminal-exec";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };
}
