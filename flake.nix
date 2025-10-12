{
  description = "一个基础 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, dankMaterialShell, niri, ... }@inputs: {
    nixosConfigurations.nixos = let
      system = "x86_64-linux";
      
    in nixpkgs.lib.nixosSystem { 
      inherit system;
      modules = [
        ./configuration.nix
        ./Modules/services/ssh.nix
        ./Modules/services/dae.nix
        ./Modules/user/tux.nix
        ./Modules/nh.nix

        {
          nixpkgs.overlays = [
            niri.overlays.niri 
          ];
          
        }
        
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true; 
            useUserPackages = true;
            users.tux = { imports = [ ./home.nix ]; }; 
          };
        }
      ];
      specialArgs = { inherit inputs niri; };
    };
  };
}
