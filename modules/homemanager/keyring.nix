{ config, ... }: {
    flake.homeModules.keyring = { config, ... }: {
services.gnome-keyring.enable = true;
home.packages = [ pkgs.gcr ]; # Provides org.gnome.keyring.SystemPrompter
};
}
