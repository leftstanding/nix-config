{
  imports = [
    ./discord.nix
    ./firefox.nix
    ./font.nix
    ./gtk.nix
    ./pavucontrol.nix
    ./qt.nix
    ./slack.nix
    ./vivaldi.nix
  ];
  xdg.portal.enable = true;
}
