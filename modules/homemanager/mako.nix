{ lib, ... }:
{
    flake.homeModules.mako =
        { config, lib, ... }:
        let
            cfg = config.myModules.mako;
        in
        {
            options.myModules.mako = {
                enable = lib.mkEnableOption "mako";
            };

            config = lib.mkIf cfg.enable {
                services.mako = {
                    enable = true;

                    settings = {
                        text-color = "#e0def4";
                        border-color = "#524f67";
                        background-color = "#26233a";
                        progress-color = "over #31748f";
                        width = 420;
                        height = 110;
                        padding = 10;
                        border-size = 2;
                        font = "Liberation Sans 11";
                        anchor = "top-right";
                        default-timeout = 5000;
                        max-icon-size = 32;
                    };

                    extraConfig = ''
                        [app-name=Spotify]
                        invisible=1

                        [mode=do-not-disturb]
                        invisible=true

                        [mode=do-not-disturb app-name=notify-send]
                        invisible=false

                        [urgency=high]
                        border-color=#eb6f92
                    '';
                };
            };
        };
}
