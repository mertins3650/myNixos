{ pkgs, lib, ... }:
{
    flake.nixosModules.amdGpuPower = { pkgs, ... }: {
        hardware.amdgpu.overdrive.enable = true;
        services.lact.enable = true;

        systemd.services.lact-monitor = {
            description = "Monitor Power Profiles and update LACT profile";
            after = [ "lactd.service" "power-profiles-daemon.service" ];
            wants = [ "lactd.service" "power-profiles-daemon.service" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
                Type = "simple";
                Restart = "always";
                User = "root";

                ExecStartPre = lib.getExe (pkgs.writeShellApplication {
                    name = "lact-initial-set";
                    runtimeInputs = with pkgs; [
                        lact
                        power-profiles-daemon
                    ];
                    text = ''
                        profile="$(powerprofilesctl get)"
                        if [[ "$profile" == "power-saver" ]]; then
                            lact cli profile set "power-saver"
                        else
                            lact cli profile set "default"
                        fi
                    '';
                });

                ExecStart = lib.getExe (pkgs.writeShellApplication {
                    name = "lact-watcher";
                    runtimeInputs = with pkgs; [
                        glib
                        gnugrep
                        lact
                    ];
                    text = ''
                        gdbus monitor --system --dest net.hadess.PowerProfiles |
                        while read -r line; do
                            if [[ "$line" =~ ActiveProfile ]]; then
                                profile="$(echo "$line" | grep -oP "(?<=<').+?(?='>)")"

                                if [[ "$profile" == "power-saver" ]]; then
                                    lact cli profile set "power-saver"
                                else
                                    lact cli profile set "default"
                                fi
                            fi
                        done
                    '';
                });
            };
        };
    };
}
