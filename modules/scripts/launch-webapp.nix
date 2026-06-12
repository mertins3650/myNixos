# {...}: {
#   flake.homeModules.scripts = {
#     config,
#     pkgs,
#     ...
#   }: let
#     chromiumCmd = "${config.programs.chromium.package}/bin/chromium";
#   in {
#     home.packages = [
#       (pkgs.writeShellApplication {
#         name = "launch-webapp";
#         runtimeInputs = with pkgs; [
#           util-linux
#           uwsm
#         ];
#         text = ''
#           exec setsid uwsm app -- ${chromiumCmd} --app="$1" "''${@:2}"
#         '';
#       })
#     ];
#   };
# }
{...}: {
  flake.homeModules.scripts = {pkgs, ...}: let
    # Assuming 'zen-browser' is available in your pkgs via a flake input or overlay
    zenCmd = "${pkgs.zen-browser}/bin/zen";
  in {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "launch-webapp";
        runtimeInputs = with pkgs; [
          util-linux
          uwsm
        ];
        text = ''
          # Zen does not support Chromium's --app flag, so we pass the URL directly.
          exec setsid uwsm app -- ${zenCmd} "$1" "''${@:2}"
        '';
      })
    ];
  };
}
