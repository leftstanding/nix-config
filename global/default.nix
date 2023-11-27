{ inputs, lib, pkgs, config, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) colorschemeFromPicture nixWallpaperFromScheme;
in
{
  imports = [
    inputs.nix-colors.homeManagerModule
    ../features/cli
    ../features/nvim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefualt pkgs.nix;
    settings = {
      experimental.features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manaager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "baker";
    homeDirectory = lib.mkDefualt "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      FLAKE = "$HOME/.config/NixConfig";
    };

    persistence = {
      "/persist/home/baker" = {
        directories = [
	  "Documents"
	  "Downloads"
	  "Pictures"
	  "Projects"
	  "wallpapers"
	  ".config"
	  ".local/bin"
	];
	allowOther = true;
      };
    };
  };

  colorscheme = lib.mkDefault colorSchemes.nord;
  wallpaper =
    let
      largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
      largestWidth = largest (x: x.width) config.monitors;
      largestHeight = largest (x: x.height) config.monitors;
    in
    lib.mkDefault (nixWallpaperFromScheme
      {
        scheme = config.colorscheme;
	width = largestwidth;
	height = largestHeight;
	logoScale = 4;
      });
    home.file.".colorscheme".text = config.colorscheme.slug;
  }
