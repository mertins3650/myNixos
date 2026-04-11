{ ... }:
{
    flake.homeModules.chromium = {
programs.chromium = {
    enable = true;

    commandLineArgs = [
        "--ozone-platform=wayland"
        "--ozone-platform-hint=wayland"
    ];

    extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
    ];
};
};
}
