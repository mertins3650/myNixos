{...}: {
  flake.homeModules.hyprland = {
    config,
    pkgs,
    lib,
    ...
  }: let
    lua = lib.generators.mkLuaInline;

    dsp = {
      exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';

      close = lua "hl.dsp.window.close()";
      exit = lua "hl.dsp.exit()";

      float = lua ''hl.dsp.window.float({ action = "toggle" })'';
      fullscreen = lua "hl.dsp.window.fullscreen()";
      pseudo = lua "hl.dsp.window.pseudo()";

      layout = msg: lua ''hl.dsp.layout("${msg}")'';

      focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
      swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';

      focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
      moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';

      toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
      moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';

      drag = lua "hl.dsp.window.drag()";
      resize = lua "hl.dsp.window.resize()";

      sendshortcut = mod: key:
        lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';

      # ---------------------------
      # OPTION A EXTENSIONS
      # ---------------------------

      menu = lua "hl.dsp.exec_cmd('uwsm app -- rofi -show drun')";

      browser = {
        normal = lua "hl.dsp.exec_cmd('launch-browser')";
        private = lua "hl.dsp.exec_cmd('launch-browser --private')";
      };

      webapp = url: lua ''hl.dsp.exec_cmd("launch-webapp \"${url}\"")'';

      terminal = {
        main = lua "hl.dsp.exec_cmd('uwsm app -- ghostty')";
        float = lua "hl.dsp.exec_cmd('ghostty')";
        file = lua "hl.dsp.exec_cmd('uwsm app -- ghostty -e yazi')";
      };

      floatingTerminal = {
        theme = lua "hl.dsp.exec_cmd('floating-terminal theme-switcher')";
        sync = lua "hl.dsp.exec_cmd('floating-terminal sync-sys')";
      };

      lock = lua "hl.dsp.exec_cmd('pidof hyprlock || hyprlock &')";

      lid = {
        off = lua "hl.dsp.exec_cmd('hyprctl keyword monitor \"eDP-1, disable\"')";
        on = lua "hl.dsp.exec_cmd('hyprctl keyword monitor \"eDP-1, preferred, auto, 1.25\"')";
      };

      osd = cmd: lua ''hl.dsp.exec_cmd("$osdclient ${cmd}")'';
    };

    bind = keys: dispatcher: {_args = [keys dispatcher];};
    bindOpts = keys: dispatcher: opts: {_args = [keys dispatcher opts];};

    workspaceBinds = lib.concatMap (
      i: let
        key = toString (lib.mod i 10);
      in [
        (bind "SUPER + ${key}" (dsp.focusWorkspace i))
        (bind "SUPER + SHIFT + ${key}" (dsp.moveToWorkspace i))
      ]
    ) (lib.range 1 10);
  in {
    home.packages = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd.enable = false;
      systemd.variables = ["--all"];

      settings = {
        monitor = [
          {
            output = "DP-2";
            mode = "2560x1440@144";
            position = "0x0";
            scale = 1;
          }
        ];
        config = {
          bind = [
            (bind "SUPER + Q" dsp.close)
            (bind "SUPER + T" dsp.float)
            (bind "SUPER + F" dsp.fullscreen)
            (bind "SUPER + P" dsp.pseudo)
            (bind "SUPER + V" (dsp.layout "togglesplit"))
            (bind "SUPER + D" dsp.menu)
            (bind "SUPER + R" dsp.menu)

            (bind "SUPER + RETURN" dsp.terminal.main)
            (bind "SUPER + O" dsp.terminal.float)

            (bind "SUPER + CTRL + F" dsp.exec "uwsm app -- nautilus --new-window")
            (bind "SUPER + SHIFT + F" dsp.terminal.file)
            (bind "SUPER + SHIFT + B" dsp.browser.normal)
            (bind "SUPER + SHIFT + ALT + B" dsp.browser.private)

            (bind "SUPER + SHIFT + A" (dsp.webapp "http://chatgpt.com"))
            (bind "SUPER + SHIFT + Y" (dsp.webapp "https://youtube.com/"))
            (bind "SUPER + SHIFT + C" (dsp.webapp "https://calendar.proton.me/"))
            (bind "SUPER + SHIFT + E" (dsp.webapp "https://mail.proton.me/"))

            (bind "SUPER + CTRL + N" (dsp.webapp "https://netflix.com/"))
            (bind "SUPER + SHIFT + T" (dsp.webapp "https://twitch.tv/"))
            (bind "SUPER + SHIFT + R" (dsp.webapp "https://reddit.com/"))

            (bind "SUPER + CTRL + J" (dsp.webapp "http://jellyfin.mertins.net"))
            (bind "SUPER + SHIFT + N" (dsp.webapp "http://joplin.mertins.net"))
            (bind "SUPER + h" (dsp.focus "l"))
            (bind "SUPER + l" (dsp.focus "r"))
            (bind "SUPER + k" (dsp.focus "u"))
            (bind "SUPER + j" (dsp.focus "d"))

            (bind "SUPER + SHIFT + h" (dsp.swap "l"))
            (bind "SUPER + SHIFT + l" (dsp.swap "r"))
            (bind "SUPER + SHIFT + k" (dsp.swap "u"))
            (bind "SUPER + SHIFT + j" (dsp.swap "d"))
            (bind "SUPER + ALT + L" dsp.resize)
            (bind "SUPER + ALT + H" dsp.resize)
            (bind "SUPER + ALT + K" dsp.resize)
            (bind "SUPER + ALT + J" dsp.resize)
            (bind "SUPER + CTRL + ALT + L" dsp.lock)
          ];
          bindl = [
            ", switch:on:Lid Switch, exec, ${dsp.lid.off}"
            ", switch:off:Lid Switch, exec, ${dsp.lid.on}"
          ];
          bindeld = [
            ", XF86AudioRaiseVolume, exec, ${dsp.osd "--output-volume raise"}"
            ", XF86AudioLowerVolume, exec, ${dsp.osd "--output-volume lower"}"
            ", XF86AudioMute, exec, ${dsp.osd "--output-volume mute-toggle"}"
            ", XF86AudioMicMute, exec, ${dsp.osd "--input-volume mute-toggle"}"

            ", XF86MonBrightnessUp, exec, ${dsp.osd "--brightness raise"}"
            ", XF86MonBrightnessDown, exec, ${dsp.osd "--brightness lower"}"

            "ALT, XF86AudioRaiseVolume, exec, ${dsp.osd "--output-volume +1"}"
            "ALT, XF86AudioLowerVolume, exec, ${dsp.osd "--output-volume -1"}"
            "ALT, XF86MonBrightnessUp, exec, ${dsp.osd "--brightness +1"}"
            "ALT, XF86MonBrightnessDown, exec, ${dsp.osd "--brightness -1"}"
          ];
          bindmd = [
            "SUPER, mouse:273, resizewindow"
            "SUPER, mouse:272, movewindow"
          ];
          workspaceBinds =
            lib.concatMap (
              i: let
                ws = i + 1;
                key =
                  if ws == 10
                  then "0"
                  else toString ws;
              in [
                (bind "SUPER + ${key}" (dsp.focusWorkspace ws))
                (bind "SUPER + SHIFT + ${key}" (dsp.moveToWorkspace ws))
              ]
            ) (lib.range 1 9)
            ++ [
              (bind "SUPER + 0" (dsp.focusWorkspace 10))
              (bind "SUPER + SHIFT + 0" (dsp.moveToWorkspace 10))
            ];
        };
      };
    };

    home.sessionVariables = {
      TERMINAL = "xdg-terminal-exec";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };
}
