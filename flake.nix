{
  description = "Baker NixOS Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    # Nix Colors
    nix-colors.url = "github:misterio77/nix-colors";

    # Add Security Here once ready

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Desktop
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:misterio77/hyprland-plugins/flake-winwrap";
      inputs.hyprland.follows = "hyprland";
    };

    # MacOS
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofendgli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url "github:homebrew/homebrew-cask";
      flake = false;
    };
    
    # Gaming
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
  in {
    inherit lib;

    # Reusable modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./.config/nix-config/modules/nixos;
    homeManagerModules = import ./.config/nix-config/modules/home-manager;

    # Templates
    # templates = import ./templates;
    
    # Your custom packages and modifications, exported as overlays
    overlays = import ./.config/nix-config/overlays {inherit inputs;};

    # Your custom packages and devshells
    # Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./.config/nix-config/pkgs { inherit pkgs; });
    devShells = forEachSystem (pkgs: import ./.config/nix-config/shell.nix { inherit pkgs; });
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

    wallpapers = import ./wallpapers;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Main Desktop
      bifrost = lib.nixosSystem {
        modules = [ ./.config/nix-config/hosts/bifrost ];
	specialArgs = { inherit inputs outputs; };
      };
      # Personal Laptop
      asgard = lib.nixosSystem {
        modules = [ ./.config/nix-config/hosts/asgard ];
	specialArgs = { inherit inputs outputs; };
      };
      # FIXME Temp Personal Laptop
      machtnix = lib.nixosSystem {
        modules = [ ./.config/nix-config/hosts/asgard ];
	specialArgs = { inherit inputs outputs; };
      };
      # Work Laptop
      midgard = lib.nixosSystem {
        modules = [ ./.config/nix-config/hosts/midgard ];
	specialArgs = { inherit inputs outputs; };
      };
    };

    homeConfigurations = {
      "baker@bifrost" = lib.homeManagerConfiguration {
        modules = [ ./.config/nix-config/bifrost.nix ];
	pkgs = pkgsFor .x86_64-linux;
	extraSpecialArgs = { inherit inputs outputs; };
      };
      "baker@asgard" = lib.homeManagerConfiguration {
        modules = [ ./.config/nix-config/asgard.nix ];
	pkgs = pkgsFor .x86_64-linux;
	extraSpecialArgs = { inherit inputs outputs; };
      };
      # FIXME
      "baker@machtnix" = lib.homeManagerConfiguration {
        modules = [ ./.config/nix-config/machtnix.nix ];
	pkgs = pkgsFor .x86_64-linux;
	extraSpecialArgs = { inherit inputs outputs; };
      };
      "baker@midgard" = lib.homeManagerConfiguration {
        modules = [ ./.config/nix-config/midgard.nix ];
	pkgs = pkgsFor .x86_64-darwin;
	extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
