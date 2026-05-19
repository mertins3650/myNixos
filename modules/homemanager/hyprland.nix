{...}: {
  flake.homeModules.hyprland = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
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

        exec-once = [
          "uwsm app -- hypridle"
          "uwsm app -- mako"
          "uwsm app -- waybar"
          "uwsm app -- swaybg -i /home/simonm/myNixos/defaults/background.png -m fill"
          "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
          "systemctl --user import-environment $(env | cut -d'=' -f 1)"
          "dbus-update-activation-environment --systemd --all"
        ];

        env = [
          "HYPRCURSOR_SIZE,24"
          "XCURSOR_THEME,Adwaita"
          "XCURSOR_SIZE,24"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_STYLE_OVERRIDE,kvantum"
          "SDL_VIDEODRIVER,wayland"
          "MOZ_ENABLE_WAYLAND,1"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          "OZONE_PLATFORM,wayland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "GDK_SCALE,1"
        ];

        monitor = [
          ",preferred,auto,1.25"
          "DP-2,2560x1440@144,0x0,1"
          "eDP-1,preferred,auto,1.25"
        ];

        bind =
          [
            "$mainMod, Q, killactive,"
            "$mainMod, D, exec, $menu"
            "$mainMod, RETURN, exec, $terminal"
            "$mainMod, O, exec, ghostty"
            "$mainMod CTRL, F, exec, uwsm app -- $fileManager --new-window"
            "$mainMod SHIFT, F, exec, $terminal -e yazi"
            "$mainMod, R, exec, $menu"
            "$mainMod SHIFT, B, exec, $browser"
            "$mainMod SHIFT ALT, B, exec, $browser --private"
            ''$mainMod SHIFT, A, exec, launch-webapp "http://chatgpt.com"''
            ''$mainMod SHIFT, Y, exec, launch-webapp "https://youtube.com/"''
            ''$mainMod SHIFT, C, exec, launch-webapp "https://calendar.proton.me/"''
            ''$mainMod SHIFT, E, exec, launch-webapp "https://mail.proton.me/"''
            ''$mainMod CTRL, N, exec, launch-webapp "https://netflix.com/"''
            ''$mainMod SHIFT, T, exec, launch-webapp "https://twitch.tv/"''
            ''$mainMod SHIFT, R, exec, launch-webapp "https://reddit.com/"''
            ''$mainMod CTRL, J, exec, launch-webapp "http://jellyfin.mertins.net"''
            ''$mainMod SHIFT, N, exec, launch-webapp "http://joplin.mertins.net"''
            "$mainMod ALT, T, exec, floating-terminal theme-switcher"
            "$mainMod SHIFT, U, exec, floating-terminal sync-sys"
            "$mainMod, T, togglefloating,"
            "$mainMod, P, pseudo,"
            # "$mainMod, V, togglesplit,"
            "$mainMod, F, fullscreen, 0"
            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"
            "$mainMod SHIFT, h, movewindow, l"
            "$mainMod SHIFT, l, movewindow, r"
            "$mainMod SHIFT, k, movewindow, u"
            "$mainMod SHIFT, j, movewindow, d"
            "$mainMod ALT, L, resizeactive, 10 0"
            "$mainMod ALT, H, resizeactive, -10 0"
            "$mainMod ALT, K, resizeactive, 0 -10"
            "$mainMod ALT, J, resizeactive, 0 10"
            "$mainMod, 0, workspace, 10"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
            "$mainMod CONTROL ALT, L, exec, dpidof hyprlock || hyprlock &"
          ]
          ++ (
            builtins.concatLists (
              builtins.genList
              (i: let
                ws = i + 1;
                key =
                  if ws == 10
                  then "0"
                  else builtins.toString ws;
              in [
                "$mainMod, ${key}, workspace, ${builtins.toString ws}"
                "$mainMod SHIFT, ${key}, movetoworkspace, ${builtins.toString ws}"
              ])
              9
            )
          );

        bindl = [
          '', switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
          '', switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, auto, 1.25"''
        ];

        bindd = [
          ", PRINT, Screenshot with editing, exec, cmd-screenshot"
          "SHIFT, PRINT, Screenshot to clipboard, exec, cmd-screenshot smart clipboard"
          "SUPER, COMMA, Dismiss last notification, exec, makoctl dismiss"
          "SUPER SHIFT, COMMA, Dismiss all notifications, exec, makoctl dismiss --all"
        ];

        bindeld = [
          ", XF86AudioRaiseVolume, Volume up, exec, $osdclient --output-volume raise"
          ", XF86AudioLowerVolume, Volume down, exec, $osdclient --output-volume lower"
          ", XF86AudioMute, Mute, exec, $osdclient --output-volume mute-toggle"
          ", XF86AudioMicMute, Mute microphone, exec, $osdclient --input-volume mute-toggle"
          ", XF86MonBrightnessUp, Brightness up, exec, $osdclient --brightness raise"
          ", XF86MonBrightnessDown, Brightness down, exec, $osdclient --brightness lower"
          "ALT, XF86AudioRaiseVolume, Volume up precise, exec, $osdclient --output-volume +1"
          "ALT, XF86AudioLowerVolume, Volume down precise, exec, $osdclient --output-volume -1"
          "ALT, XF86MonBrightnessUp, Brightness up precise, exec, $osdclient --brightness +1"
          "ALT, XF86MonBrightnessDown, Brightness down precise, exec, $osdclient --brightness -1"
        ];

        bindmd = [
          "SUPER, mouse:273, Resize window, resizewindow"
          "SUPER, mouse:272, Move window, movewindow"
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
    };

    home.sessionVariables = {
      TERMINAL = "xdg-terminal-exec";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };
}
