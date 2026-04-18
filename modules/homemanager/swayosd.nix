{...}: {
  flake.homeModules.swayosd = {config, ...}: {
    services.swayosd = {
      enable = true;
      stylePath = "${config.xdg.configHome}/swayosd/style.css";
    };

    xdg.configFile."swayosd/config.toml".text = ''
      [server]
      show_percentage = true
      max_volume = 100
      style = "${config.xdg.configHome}/swayosd/style.css"
    '';

    xdg.configFile."swayosd/style.css".text = ''
      @define-color background-color #191724;
      @define-color border-color #524f67;
      @define-color label #6e6a86;
      @define-color image #6e6a86;
      @define-color progress #e0def4;

      window {
        border-radius: 0;
        opacity: 0.97;
        border: 2px solid @border-color;

        background-color: @background-color;
      }

      label {
        font-family: 'CaskaydiaMono Nerd Font';
        font-size: 11pt;

        color: @label;
      }

      image {
        color: @image;
      }

      progressbar {
        border-radius: 0;
      }

      progress {
        background-color: @progress;
      }
    '';
  };
}
