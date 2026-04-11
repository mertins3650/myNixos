(pkgs.writeShellApplication {
    name = "launch-browser";
    runtimeInputs = with pkgs; [
        util-linux
        uwsm
    ];

    text = ''
        browser="${config.programs.chromium.package}/bin/chromium"

        if [[ "$browser" =~ (firefox|zen|librewolf|mullvad) ]]; then
            private_flag="--private-window"
        elif [[ "$browser" =~ edge ]]; then
            private_flag="--inprivate"
        else
            private_flag="--incognito"
        fi

        args=()
        for arg in "$@"; do
            if [[ "$arg" == "--private" ]]; then
                args+=("$private_flag")
            else
                args+=("$arg")
            fi
        done

        exec setsid uwsm app -- "$browser" "''${args[@]}"
    '';
})
