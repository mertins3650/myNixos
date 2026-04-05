{ self, inputs, ... }: {
    flake.nixosModules.dotfiles = { pkgs, lib, ... }:
        let
            user = "simonm";
            home = "/home/${user}";
            dotfilesDir = "${home}/myNixos/dotfiles";

            stowDotfiles = pkgs.writeShellScript "stow-dotfiles" ''
                set -euo pipefail

                export HOME=${lib.escapeShellArg home}

                if [ ! -d ${lib.escapeShellArg dotfilesDir} ]; then
                    echo "Dotfiles directory not found: ${dotfilesDir}"
                    exit 0
                fi

                cleanup() {
                    echo "Restoring tracked dotfiles after adopt..."
                    ${pkgs.git}/bin/git -C ${lib.escapeShellArg dotfilesDir} restore .
                }
                trap cleanup EXIT

                shopt -s nullglob
                for dir in ${lib.escapeShellArg dotfilesDir}/*/; do
                    [ -d "$dir" ] || continue
                    pkg="''${dir%/}"
                    pkg="''${pkg##*/}"

                    echo "Stowing $pkg..."
                    ${pkgs.stow}/bin/stow \
                        --dir=${lib.escapeShellArg dotfilesDir} \
                        --target=${lib.escapeShellArg home} \
                        --verbose=2 \
                        --adopt \
                        "$pkg"
                done
            '';
        in
        {
            environment.systemPackages = [
                pkgs.stow
                pkgs.git
            ];

            system.activationScripts.stowDotfiles.text = ''
                echo "Running dotfile stow activation..."

                if id -u ${user} >/dev/null 2>&1; then
                    /run/wrappers/bin/su - ${user} -c ${lib.escapeShellArg "${stowDotfiles}"}
                fi
            '';
        };
}
