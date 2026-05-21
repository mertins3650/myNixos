{...}: {
  flake.homeModules.hyprland = {
    config,
    pkgs,
    inputs,
    ...
  }: let
    luaFiles = [
      "hyprland.lua"
      "apperance.lua"
      "env.lua"
      "input.lua"
      "monitor.lua"
      "exec.lua"
      "keybinds.lua"
      "looknfeel.lua"
    ];

    basePath = "${config.home.homeDirectory}/myNixos/modules/homemanager/hyprland/lua";

    hyprlandConfigs = builtins.listToAttrs (map (filename: {
        name = "hypr/${filename}";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${basePath}/${filename}";
        };
      })
      luaFiles);
  in {
    home.packages = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland.enable = false;
    home.file.".local/share/hypr/stubs".source = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/stubs";

    xdg.configFile =
      hyprlandConfigs
      // {
        "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      };

    home.sessionVariables = {
      TERMINAL = "xdg-terminal-exec";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };
  };
}
