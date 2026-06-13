{inputs, ...}: {
  flake.homeModules.zen = {
    pkgs,
    lib,
    ...
  }: let
    extension = shortId: guid: {
      name = guid;
      value = {
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
        installation_mode = "normal_installed";
      };
    };

    prefs = {
      "extensions.autoDisableScopes" = 0;
      "extensions.pocket.enabled" = false;
      "browser.startup.page" = 1;
      "browser.tabs.loadInBackground" = false;
    };

    extensions = [
      (extension "ublock-origin" "uBlock0@raymondhill.net")
      (extension "1password-x-password-manager" "{d634138d-c276-4fc8-924b-40a0ea21d284}")
      (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
      (extension "darkreader" "addon@darkreader.org")
    ];

    zenBrowser =
      pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: ''
              lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});
            ''
          )
          prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;
          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
              {
                Name = "NixOS Wiki";
                URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@nw";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "@ng";
              }
            ];
          };
        };
      };
  in {
    home.packages = [
      zenBrowser
      (pkgs.writeShellApplication {
        name = "launch-webapp";
        runtimeInputs = with pkgs; [util-linux];
        text = ''
                    profile="$HOME/.local/share/zen-webapps/$(basename "$1")"
          mkdir -p "$profile"

          exec setsid uwsm app -- ${lib.getExe zenBrowser} \
              --no-remote \
              --profile "$profile" \
              --new-window "$1" "''${@:2}"
        '';
      })
    ];
  };
}
