{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "launch-tui";
        runtimeInputs = with pkgs; [
          coreutils
          util-linux
          uwsm
          xdg-terminal-exec
        ];

        text = ''
          app_name="$(basename "$1")"
          app_id="org.nixy.$app_name"

          exec setsid uwsm app -- xdg-terminal-exec \
              --app-id="$app_id" \
              -e "$1" "''${@:2}"
        '';
      })
    ];
  };
}
