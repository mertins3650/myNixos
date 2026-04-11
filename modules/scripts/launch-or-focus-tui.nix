{ ... }:
{
    flake.homeModules.scripts =
        { config, pkgs, ... }:
        {
            home.packages = [
                (pkgs.writeShellApplication {
                    name = "launch-or-focus-tui";
                    runtimeInputs = with pkgs; [
                        coreutils
                        util-linux
                    ];

                    text = ''
                        APP_ID="org.nixy.$(basename "$1")"
                        LAUNCH_COMMAND="launch-tui $@"

                        exec launch-or-focus "$APP_ID" "$LAUNCH_COMMAND"
                    '';
                })
            ];
        };
}
