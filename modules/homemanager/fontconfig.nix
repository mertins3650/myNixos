{ ... }:
{
    flake.homeModules.fontconfig =
        { pkgs, ... }:
        {
            fonts.fontconfig = {
                enable = true;

                defaultFonts = {
                    sansSerif = [ "Liberation Sans" ];
                    serif = [ "Liberation Serif" ];
                    monospace = [ "CaskaydiaMono Nerd Font" ];
                };

                configFile."90-custom-aliases" = {
                    enable = true;
                    text = ''
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
                    priority = 90;
                };
            };

            home.packages = with pkgs; [
                liberation_ttf
                nerd-fonts.caskaydia-mono
		font-awesome
            ];
        };
}
