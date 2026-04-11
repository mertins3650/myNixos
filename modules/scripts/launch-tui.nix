{ ... }:
{
    flake.homeModules.scripts =
        { config, pkgs, ... }:
        {
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
                        exec setsid uwsm app -- xdg-terminal-exec \
                            --app-id=org.nixy.$(basename "$1") \
                            -e "$1" "''${@:2}"
                    '';
                })
            ];
        };
}
