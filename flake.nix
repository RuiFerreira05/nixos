{
  description = "My Unified NixOS Configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # zen-browser.url = "github:zen-browser/desktop";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "rui";
    in {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username host; };
          modules = [

            ./configuration.nix

            nixos-hardware.nixosModules.lenovo-legion-15ach6h
            
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs username; };
            }
          ];
        };
      };
    };
}
