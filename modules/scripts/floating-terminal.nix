(pkgs.writeShellApplication {
    name = "floating-terminal";
    runtimeInputs = with pkgs; [
        bash
        util-linux
        uwsm
        xdg-terminal-exec
    ];

    text = ''
        cmd="$*"
        exec setsid uwsm app -- xdg-terminal-exec --app-id=org.nixy.terminal --title=nixy -e bash -c "$cmd"
    '';
})
