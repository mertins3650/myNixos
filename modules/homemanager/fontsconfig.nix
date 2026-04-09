{ lib, ... }:
{
    flake.homeModules.fontconfig =
        { config, lib, ... }:
        let
            cfg = config.myModules.fontconfig;
        in
        {
            options.myModules.fontconfig = {
                enable = lib.mkEnableOption "fontconfig";
            };

            config = lib.mkIf cfg.enable {
                fonts.fontconfig = {
                    enable = true;

                    defaultFonts = {
                        sansSerif = [ "Liberation Sans" ];
                        serif = [ "Liberation Serif" ];
                        monospace = [ "CaskaydiaMono Nerd Font" ];
                    };

                    localConf = ''
                        <?xml version="1.0"?>
                        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
                        <fontconfig>
                          <alias>
                            <family>system-ui</family>
                            <prefer>
                              <family>Liberation Sans</family>
                            </prefer>
                          </alias>

                          <alias>
                            <family>ui-monospace</family>
                            <default>
                              <family>monospace</family>
                            </default>
                          </alias>

                          <alias>
                            <family>-apple-system</family>
                            <prefer>
                              <family>Liberation Sans</family>
                            </prefer>
                          </alias>

                          <alias>
                            <family>BlinkMacSystemFont</family>
                            <prefer>
                              <family>Liberation Sans</family>
                            </prefer>
                          </alias>
                        </fontconfig>
                    '';
                };
            };
        };
}
