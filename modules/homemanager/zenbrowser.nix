{inputs, ...}: {
  flake.homeModules.zen = {
    config,
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
    };

    extensions = [
      (extension "ublock-origin" "uBlock0@raymondhill.net")
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
    # Expose your customized package to the rest of Home Manager
    options.custom.zen.package = lib.mkOption {
      type = lib.types.package;
      default = zenBrowser;
      description = "My customized wrapped Zen Browser";
    };

    # Install the exposed package
    config = {
      home.packages = [
        config.custom.zen.package
      ];
    };
  };
}
