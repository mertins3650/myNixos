
{ ... }: {
  flake.nixosModules.base = {  ...}: {
networking.wireless.iwd.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.xserver.enable = true;
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  services.printing.enable = true;
programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
	   alsa-lib
            pulseaudio
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
