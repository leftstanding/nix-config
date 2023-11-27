{ inputs, outputs, ... }: {
  imports = [
    ./.config/nix-config/global
    ./.config/nix-config/features/desktop/hyprland
    ./.config/nix-config/features/productivity
    ./.config/nix-config/features/games
    ];

    colorscheme = inputs.nix-colors.colorSchemes.nord;
    wallpaper = ./wallpapers/wallpaper_7.jpg;
}
