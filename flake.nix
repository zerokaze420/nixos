{
  description = "一个基础 Flake - 支持多主机";

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

  outputs = { self, nixpkgs, home-manager, dankMaterialShell, niri, ... }@inputs:
  let
    # 1. 定义系统架构
    system = "x86_64-linux";
    
    # 2. 定义所有主机的公共模块（Common Modules）
    commonModules = [
      ./Modules/services/ssh.nix
      ./Modules/services/dae.nix
      ./Modules/user/tux.nix
      ./Modules/nh.nix
      
      # Niri Overlay
      {
        nixpkgs.overlays = [
          niri.overlays.niri 
        ];
      }
      
      # Home Manager Setup for user 'tux' (Assumed to be common)
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true; 
          useUserPackages = true;
          users.tux = { 
            imports = [
              ./home.nix 
              inputs.dankMaterialShell.homeModules.dankMaterialShell.default
              inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
            ]; 
          };
          extraSpecialArgs = { inherit inputs; };
        };
      }
    ];

    hostConfigs = nixpkgs.lib.mapAttrs' (name: _: {
      name = name;
      value = { modules = [ (./hosts + "/${name}/configuration.nix") ]; };
    }) (builtins.readDir ./hosts); # <-- 修复点

    nixosConfigurations = nixpkgs.lib.mapAttrs (name: hostAttrs:
      nixpkgs.lib.nixosSystem {
        inherit system;
        
        # 模块 = 公共模块 + 主机特定的配置模块
        modules = commonModules ++ hostAttrs.modules;
        
        specialArgs = { inherit inputs niri; };
      }
    ) hostConfigs;

  in {
    # 导出所有动态生成的主机配置
    inherit nixosConfigurations;
  };
}
