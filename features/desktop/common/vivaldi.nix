{ pkgs, ... }:

{
  # programs.browserpass.enable = true;
  programs.vivaldi = {
    enable = true;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "vivaldi.desktop" ];
    "text/xml" = [ "vivaldi.desktop" ];
    "x-scheme-handler/http" = [ "vivaldi.desktop" ];
    "x-scheme-handler/https" = [ "vivaldi.desktop" ];
  };
}
