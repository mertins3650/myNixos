{ ... }:
{
    flake.homeModules.scripts =
        { config, pkgs, ... }:
        {
            home.packages = [
                (pkgs.writeShellApplication {
                    name = "playhs";
                    runtimeInputs = with pkgs; [
                        coreutils
                    ];

                    text = ''
                        HS_DIR="$HOME/hearthstone-linux/hearthstone"

                        if [[ ! -d "$HS_DIR" ]]; then
                            echo "Hearthstone directory not found: $HS_DIR" >&2
                            exit 1
                        fi

                        cd "$HS_DIR" || exit 1
                        exec ./Bin/Hearthstone.x86_64
                    '';
                })
            ];
        };
}
