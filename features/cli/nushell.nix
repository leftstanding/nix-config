{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  hasPackage = pname: lib.any (p: p ? pname && p.pname == pname) config.home.packages;
  hasRipgrep = hasPackage "ripgrep";
  hasNeovim = config.programs.neovim.enable;
  hasEmacs = config.programs.emacs.enable;
  hasShellColor = config.programs.shellcolor.enable;
  hasKitty = config.programs.kitty.enable;
  shellcolor = "${pkgs.shellcolord}/bin/shellcolor";
in
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner = false,
      }
      $env.PATH = ($env.PATH |
                    split row (char esep) |
                    prepend /home/baker/.apps |
                    append /usr/bin/env
                    )
    '';
    shellAliases = {
      # Clear screen and scrollback
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
    };
  }
}
