{...}: {
  flake.homeModules.scripts = {pkgs, ...}: {
    home.file.".tmux-sessionizer".source =
      ../tmux-sessionizer/.tmux-sessionizer;

    xdg.configFile."tmux-sessionizer/tmux-sessionizer.conf".source =
      ../tmux-sessionizer/tmux-sessionizer.conf;

    home.file.".local/bin/tmux-sessionizer" = {
      source = ../tmux-sessionizer/tmux-sessionizer;
      executable = true;
    };

    home.packages = with pkgs; [
      tmux
      fzf
      findutils
      gnugrep
      coreutils
      procps
    ];
  };
}
