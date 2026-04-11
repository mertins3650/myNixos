{ pkgs, ... }:
{
    flake.homeModules.scripts = { pkgs, ...}:  {
        home.packages = [
(pkgs.writeShellApplication {
    name = "launch-webapp";
    runtimeInputs = with pkgs; [
        xdg-utils
        gnused
        coreutils
        util-linux
        uwsm
    ];

    text = ''
        browser="$(xdg-settings get default-web-browser 2>/dev/null || true)"

        case "$browser" in
            google-chrome*|brave-browser*|microsoft-edge*|opera*|vivaldi*|helium*) ;;
            *) browser="chromium.desktop" ;;
        esac

        desktop_file=""
        for base in "$HOME/.local/share/applications" "$HOME/.nix-profile/share/applications" /run/current-system/sw/share/applications /usr/share/applications; do
            if [ -f "$base/$browser" ]; then
                desktop_file="$base/$browser"
                break
            fi
        done

        if [ -z "$desktop_file" ]; then
            echo "Could not find desktop file for browser: $browser" >&2
            exit 1
        fi

        exec_line="$(sed -n 's/^Exec=//p' "$desktop_file" | head -n1)"
        cmd="$(printf '%s\n' "$exec_line" | sed 's/[[:space:]].*$//; s/"//g')"

        if [ -z "$cmd" ]; then
            echo "Could not extract Exec command from: $desktop_file" >&2
            exit 1
        fi

        exec setsid uwsm app -- "$cmd" --app="$1" "''${@:2}"
    '';
})
        ];
    };
}
