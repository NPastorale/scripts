{
  description = "NixOS system configuration for XPS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative dotfiles and user packages
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # The hostname is used as the configuration name
      XPS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Pass flake inputs to modules so they can be accessed inside configuration.nix
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          ./disko-config.nix
          ./configuration.nix

          # Home Manager module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nahue = import ./home.nix;
          }
        ];
      };
    };
  };
}
