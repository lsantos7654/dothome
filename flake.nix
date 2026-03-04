{
  description = "Portable Home Manager configuration for santos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeModules.default = ./home;

    homeConfigurations."santos@nixos" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home
        {
          home.username = "santos";
          home.homeDirectory = "/home/santos";
        }
      ];
    };
  };
}
