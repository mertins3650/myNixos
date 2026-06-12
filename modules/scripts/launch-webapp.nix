{...}: {
  flake.homeModules.scripts = {
    config,
    pkgs,
    ...
  }: let
    chromiumCmd = "${config.programs.chromium.package}/bin/chromium";
  in {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "launch-webapp";
        runtimeInputs = with pkgs; [
          util-linux
          uwsm
        ];
        text = ''
          exec setsid uwsm app -- ${chromiumCmd} --app="$1" "''${@:2}"
        '';
      })
    ];
  };
}
