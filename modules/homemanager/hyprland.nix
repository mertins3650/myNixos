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
      toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
      moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
      focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
      moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
      drag = lua "hl.dsp.window.drag()";
      resize = lua "hl.dsp.window.resize()";
      sendshortcut = mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
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
    mkEnv = name: value: {
      _args = [
        name
        value
      ];
    };
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
        "$mod" = "SUPER";
        "$mainMod" = "SUPER";
        "$terminal" = "uwsm app -- $TERMINAL";
        "$browser" = "launch-browser";
        "$fileManager" = "nautilus";
        "$menu" = "uwsm app -- rofi -show drun";
        "$osdclient" = ''swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"'';

        config = {
          monitor = [
            {
              output = "DP-";
              mode = "2560x1440@144";
              position = "0x0";
              scale = 1;
            }
          ];

          env = [
            (mkEnv "HYPRCURSOR_SIZE" "24")
            (mkEnv "XCURSOR_THEME" "Adwaita")
            (mkEnv "XCURSOR_SIZE" "24")
            (mkEnv "GDK_BACKEND" "wayland,x11,*")
            (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
            (mkEnv "QT_STYLE_OVERRIDE" "kvantum")
            (mkEnv "SDL_VIDEODRIVER" "wayland")
            (mkEnv "MOZ_ENABLE_WAYLAND" "1")
            (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "wayland")
            (mkEnv "OZONE_PLATFORM" "wayland")
            (mkEnv "XDG_SESSION_TYPE" "wayland")
            (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
            (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
            (mkEnv "GDK_SCALE" "1")
          ];
        };
        bind = with dsp; [
          (bind "SUPER + RETURN" (exec "uwsm app -- $TERMINAL"))
          (bind "SUPER + Q" close)
          (bind "SUPER + D" (exec "uwsm app -- rofi -show drun"))
          (bind "SUPER + O" (exec "ghostty"))

          (bind "SUPER + CTRL + F" (exec "uwsm app -- nautilus --new-window"))
          (bind "SUPER + SHIFT + F" (exec "uwsm app -- $TERMINAL -e yazi"))

          (bind "SUPER + R" (exec "uwsm app -- rofi -show drun"))

          (bind "SUPER + SHIFT + B" (exec "launch-browser"))
          (bind "SUPER + SHIFT + ALT + B" (exec "launch-browser --private"))

          (bind "SUPER + SHIFT + A" (exec "launch-webapp http://chatgpt.com"))
          (bind "SUPER + SHIFT + Y" (exec "launch-webapp https://youtube.com/"))
          (bind "SUPER + SHIFT + C" (exec "launch-webapp https://calendar.proton.me/"))
          (bind "SUPER + SHIFT + E" (exec "launch-webapp https://mail.proton.me/"))
          (bind "SUPER + CTRL + N" (exec "launch-webapp https://netflix.com/"))
          (bind "SUPER + SHIFT + T" (exec "launch-webapp https://twitch.tv/"))
          (bind "SUPER + SHIFT + R" (exec "launch-webapp https://reddit.com/"))
          (bind "SUPER + CTRL + J" (exec "launch-webapp http://jellyfin.mertins.net"))
          (bind "SUPER + SHIFT + N" (exec "launch-webapp http://joplin.mertins.net"))

          (bind "SUPER + ALT + T" (exec "floating-terminal theme-switcher"))
          (bind "SUPER + SHIFT + U" (exec "floating-terminal sync-sys"))

          # Window controls
          (bind "SUPER + T" float)
          (bind "SUPER + P" pseudo)
          (bind "SUPER + V" (layout "togglesplit"))
          (bind "SUPER + F" fullscreen)

          # Focus
          (bind "SUPER + H" (focus "l"))
          (bind "SUPER + L" (focus "r"))
          (bind "SUPER + K" (focus "u"))
          (bind "SUPER + J" (focus "d"))

          # Move windows
          (bind "SUPER + SHIFT + H" (swap "l"))
          (bind "SUPER + SHIFT + L" (swap "r"))
          (bind "SUPER + SHIFT + K" (swap "u"))
          (bind "SUPER + SHIFT + J" (swap "d"))

          # Resize (still raw dispatcher-style call)
          (bind "SUPER + ALT + L" (exec "hyprctl dispatch resizeactive 10 0"))
          (bind "SUPER + ALT + H" (exec "hyprctl dispatch resizeactive -10 0"))
          (bind "SUPER + ALT + K" (exec "hyprctl dispatch resizeactive 0 -10"))
          (bind "SUPER + ALT + J" (exec "hyprctl dispatch resizeactive 0 10"))

          # Workspaces
          (bind "SUPER + 0" (focusWorkspace 10))
          (bind "SUPER + SHIFT + 0" (moveToWorkspace 10))

          # Lock
          (bind "SUPER + CTRL + ALT + L" (exec "pidof hyprlock || hyprlock &"))
        ];

        exec-once = [
          "uwsm app -- hypridle"
          "uwsm app -- mako"
          "uwsm app -- waybar"
          "uwsm app -- swaybg -i /home/simonm/myNixos/defaults/background.png -m fill"
          "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
          "systemctl --user import-environment $(env | cut -d'=' -f 1)"
          "dbus-update-activation-environment --systemd --all"
        ];

        monitor = [
          ",preferred,auto,1.25"
          "DP-2,2560x1440@144,0x0,1"
          "eDP-1,preferred,auto,1.25"
        ];

        bindl = with dsp; [
          (bind "switch:on:Lid Switch" (exec "hyprctl keyword monitor 'eDP-1, disable'"))
          (bind "switch:off:Lid Switch" (exec "hyprctl keyword monitor 'eDP-1, preferred, auto, 1.25'"))
        ];

        bindd = with dsp; [
          (bind ", PRINT" (exec "cmd-screenshot"))
          (bind "SHIFT, PRINT" (exec "cmd-screenshot smart clipboard"))

          (bind "SUPER, COMMA" (exec "makoctl dismiss"))
          (bind "SUPER SHIFT, COMMA" (exec "makoctl dismiss --all"))
        ];

        bindeld = with dsp; [
          # Volume
          (bind ", XF86AudioRaiseVolume" (exec "$osdclient --output-volume raise"))
          (bind ", XF86AudioLowerVolume" (exec "$osdclient --output-volume lower"))
          (bind ", XF86AudioMute" (exec "$osdclient --output-volume mute-toggle"))
          (bind ", XF86AudioMicMute" (exec "$osdclient --input-volume mute-toggle"))

          # Brightness
          (bind ", XF86MonBrightnessUp" (exec "$osdclient --brightness raise"))
          (bind ", XF86MonBrightnessDown" (exec "$osdclient --brightness lower"))

          # Precise volume (ALT)
          (bind "ALT, XF86AudioRaiseVolume" (exec "$osdclient --output-volume +1"))
          (bind "ALT, XF86AudioLowerVolume" (exec "$osdclient --output-volume -1"))

          # Precise brightness (ALT)
          (bind "ALT, XF86MonBrightnessUp" (exec "$osdclient --brightness +1"))
          (bind "ALT, XF86MonBrightnessDown" (exec "$osdclient --brightness -1"))
        ];

        bindmd = with dsp; [
          (bind "SUPER, mouse:273" resize)
          (bind "SUPER, mouse:272" drag)
        ];

        workspace = [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrule = [
          "opacity 1 0.95, match:class .*"
          "float on, match:tag floating-window"
          "center on, match:tag floating-window"
          "size 875 600, match:tag floating-window"
          "tag +floating-window, match:class (org.nixy.bluetui|org.nixy.impala|org.nixy.wiremix|org.nixy.btop|org.nixy.terminal|org.nixy.bash|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|nixy|About|TUI.float|imv|mpv)"
          "tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)"
          "float on, match:class org.gnome.Calculator"
          "float on, match:class steam"
          "center on, match:class steam, match:title Steam"
          "opacity 1 1, match:class steam"
          "size 1100 700, match:class steam, match:title Steam"
          "size 460 800, match:class steam, match:title Friends List"
          "idle_inhibit fullscreen, match:class steam"
        ];

        input = {
          kb_layout = "dk";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;
          sensitivity = 0;
          repeat_rate = 40;
          repeat_delay = 600;
          accel_profile = "flat";

          touchpad = {
            natural_scroll = true;
          };
        };

        xwayland = {
          enabled = true;
          force_zero_scaling = true;
        };

        ecosystem = {
          no_update_news = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgb(ebbcba) rgb(31748f) rgb(eb6f92) rgb(c4a7e7) 90deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 0;

          shadow = {
            enabled = true;
            range = 2;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 2;
            passes = 2;
            special = true;
            brightness = 0.60;
            contrast = 0.75;
          };
        };

        animations = {
          enabled = false;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 0, 0, ease"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
        };

        master = {
          new_status = "master";
        };

        misc = {
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
          anr_missed_pings = 3;
          on_focus_under_fullscreen = 1;
        };
      };

      extraConfig = ''
        hyprland.windowrulev2({
            name = "no-gaps-wtv1",

            match = {
                floating = false,
                workspace = "w[tv1]",
            },

            border_size = 0,
            rounding = 0,
        })

        hyprland.windowrulev2({
            name = "no-gaps-f1",

            match = {
                floating = false,
                workspace = "f[1]",
            },

            border_size = 0,
            rounding = 0,
        })

        hyprland.windowrulev2({
            name = "suppress-maximize-events",

            match = {
                class = ".*",
            },

            suppress_event = "maximize",
        })

        hyprland.windowrulev2({
            name = "fix-xwayland-drags",

            match = {
                class = "^$",
                title = "^$",
                xwayland = true,
                floating = true,
                fullscreen = false,
                pinned = false,
            },

            no_focus = true,
        })

        hyprland.windowrulev2({
            name = "move-hyprland-run",

            match = {
                class = "hyprland-run",
            },

            move = "20 monitor_h-120",
            floating = true,
        })
      '';
    };

    home.sessionVariables = {
      TERMINAL = "xdg-terminal-exec";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };
}
