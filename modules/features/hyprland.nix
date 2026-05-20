{...}: {
  flake.nixosModules.hyprland = {
    pkgs,
    lib,
    ...
  }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    # Hyprland Cachix — the flake build isn't in cache.nixos.org, so subscribe
    # to the official hyprland.cachix.org binary cache to avoid compiling from
    # source on every flake input bump. See https://wiki.hypr.land/Nix/Cachix/
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    # UWSM configuration
    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = false; # Disable wlr when using Hyprland
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["*"];
          "org.freedesktop.portal.Settings" = ["hyprland"];
          "org.freedesktop.portal.ScreenCast" = ["hyprland"];
          "org.freedesktop.portal.Screenshot" = ["hyprland"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.FileChooser" = ["hyprland"];
          "org.freedesktop.portal.OpenURI" = ["hyprland"];
        };
        hyprland = {
          default = ["hyprland"];
        };
      };
    };
  };
}
