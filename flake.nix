{
  description = "NixOS Flake - KDE Plasma 6 + Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "git+https://github.com/nix-community/plasma-manager.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , hyprland
    , plasma-manager
    , ...
    }@inputs:
    let
      system = "x86_64-linux";

      globalModules = [
        ./Modules/services/ssh.nix
        ./Modules/nh.nix
      ];

      desktopModules = [
        ./Modules/user/tux.nix
        ./Modules/desktop/i18n.nix
        ./Modules/environment.nix
        ./Modules/services/dae.nix
        hyprland.nixosModules.default

        {
          nixpkgs.overlays = [
            hyprland.overlays.default
          ];
        }

        {
          programs.dms-shell = {
            enable = true;
            systemd.enable = false;
            enableDynamicTheming = true;
            enableSystemMonitoring = true;
            enableClipboardPaste = true;
          };
        }

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            users.tux.imports = [ ./home.nix ];
            extraSpecialArgs = {
              inherit inputs;
              hyprlandConf = ./config/hypr/hyprland.conf;
              niriConf = ./config/niri/config.kdl;
            };
          };
        }
      ];

      hostDefs = {
        "desktop" = { type = "desktop"; dir = "desktop"; };
        "laptop"  = { type = "desktop"; dir = "laptop"; };
        "server"  = { type = "server";  dir = "server"; };
      };

      mkModules = def:
        globalModules
        ++ (if def.type == "desktop" then desktopModules else [ ])
        ++ [ (./hosts + "/${def.dir}/configuration.nix") ];

      nixosConfigurations = nixpkgs.lib.mapAttrs (
        name: def:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = mkModules def;
          specialArgs = { inherit inputs hyprland; };
        }
      ) hostDefs;
    in
    {
      inherit nixosConfigurations;
    };
}
