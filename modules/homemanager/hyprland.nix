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

    wayland.windowManager.hyprland.enable = false;
    home.file.".local/share/hypr/stubs".source = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/stubs";

    xdg.configFile."hypr/hyprland.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/hyprland.lua";

    xdg.configFile."hypr/env.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/env.lua";

    xdg.configFile."hypr/input.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/input.lua";

    xdg.configFile."hypr/monitor.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/monitor.lua";

    xdg.configFile."hypr/exec.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/exec.lua";

    xdg.configFile."hypr/keybinds.lua".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua/keybinds.lua";

    home.sessionVariables = {
      TERMINAL = "xdg-terminal-exec";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };
}
