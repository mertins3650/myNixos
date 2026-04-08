{self, input, ... }: {
  flake.nixosModules.desktopenv = { pkgs, lib, ...}: {

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    environment.systemPackages = with pkgs;[
      nautilus
      fontconfig
      swayosd
      mako
      wl-clipboard
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      swaybg
      hypridle
      hyprlock
      fcitx5
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      yaru-theme
    ];
    fonts.packages = with pkgs; [
      nerd-fonts.caskaydia-mono
      font-awesome
    ];
  };
}
