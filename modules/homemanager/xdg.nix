{...}: {
  flake.homeModules.xdg = {...}: {
    xdg.desktopEntries.zen = {
      name = "Zen Browser";
      genericName = "Web Browser";
      exec = "zen %U";
      terminal = false;

      categories = ["Network" "WebBrowser"];

      mimeType = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];

      startupNotify = true;
    };
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
      };
    };
  };
}
