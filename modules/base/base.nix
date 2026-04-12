{ ... }: {
  flake.nixosModules.base = { pkgs,  ...}: {
  networking = {
	wireless.iwd.enable = true;
	firewall.enable = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.dconf.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  services.xserver.enable = true;
  services.printing.enable = true;
programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
	   alsa-lib
            libGL
            libglvnd
            vulkan-loader
            wayland
            libxkbcommon
            libX11
            libXext
            libXcursor
            libXinerama
            libXi
            libXrandr
            libXScrnSaver
            libXxf86vm
            systemd
        ];
    };
};
}
