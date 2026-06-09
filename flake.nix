{
  description = "NixOS Flake - KDE Plasma + DankGreeter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DankMaterialShell (stable) — provides greeter + home-manager modules
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DMS dependency: system resource monitor
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , dms
    , niri
    , hyprland
    , dgop
    , ...
    }@inputs:
    let
      system = "x86_64-linux";

      # ── Global modules (all hosts) ──
      globalCommonModules = [
        ./Modules/services/ssh.nix
        ./Modules/services/dae.nix
        ./Modules/nh.nix
        {
          nixpkgs.overlays = [
            niri.overlays.niri
            hyprland.overlays.default
            (final: prev: {
              dgop = dgop.packages.${system}.dgop;
            })
          ];
        }
      ];

      # ── Desktop modules (KDE + Hyprland/Niri + DankGreeter + Home Manager) ──
      desktopModules = [
        ./Modules/user/tux.nix

        # Hyprland + Niri compositors
        hyprland.nixosModules.default
        niri.nixosModules.niri

        # DankGreeter — greetd-based login screen
        dms.nixosModules.greeter

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.tux = {
              imports = [ ./home.nix ];
            };
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];

      # ── Host definitions ──
      # Each entry: { type = "desktop"|"server"; dir = "config-subdirectory"; }
      hostDefs = {
        "nixos" =   { type = "desktop"; dir = "desktop"; };  # AMD Ryzen 5600X + Intel Arc
        "desktop" = { type = "desktop"; dir = "desktop"; };
        "laptop" =  { type = "desktop"; dir = "laptop"; };
        "server" =  { type = "server";  dir = "server"; };
      };

      mkModules = def:
        globalCommonModules
        ++ (if def.type == "desktop" then desktopModules else [ ])
        ++ [ (./hosts + "/${def.dir}/configuration.nix") ];

      nixosConfigurations = nixpkgs.lib.mapAttrs (
        name: def:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = mkModules def;
          specialArgs = { inherit inputs niri hyprland; };
        }
      ) hostDefs;
    in
    {
      inherit nixosConfigurations;
    };
}
