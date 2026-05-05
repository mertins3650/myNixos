{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "iso2sd";
      runtimeInputs = with pkgs; [
        coreutils
        util-linux
        gawk
        gnugrep
      ];

      text = ''
        set -euo pipefail

        if [ "$#" -ne 2 ]; then
            echo "Usage: iso2sd <input_file> <output_device>"
            echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sda"
            echo
            echo "Available SD cards:"
            lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
            exit 1
        fi

        input="$1"
        output="$2"

        sudo dd bs=4M status=progress oflag=sync if="$input" of="$output"
        sudo eject "$output"
      '';
    })
  ];
}
