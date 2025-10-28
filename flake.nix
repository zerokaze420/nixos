{
  description = "一个基础 Flake - 支持多主机和模块选择性加载";

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
    system = "x86_64-linux";
    
    # --- 1. 定义真正的全局共享模块 (GLOBAL COMMON MODULES) ---
    globalCommonModules = [
      ./Modules/services/ssh.nix
      ./Modules/services/dae.nix
      ./Modules/nh.nix
      
      # Niri Overlay (所有主机都可用的包定义，不包含激活)
      {
        nixpkgs.overlays = [
          niri.overlays.niri 
        ];
      }
    ];

    # --- 2. 定义桌面专有模块 (DESKTOP MODULES) ---
    # 包含用户 'tux' 的定义、Home Manager 核心和配置。
    desktopModules = [
      ./Modules/user/tux.nix # 定义用户 'tux'
      
      # Home Manager 核心设置
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true; 
          useUserPackages = true;
          # 仅在桌面主机上配置 'tux' 用户的 home
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

    # --- 3. 定义主机类型映射 ---
    # !! 请根据您的实际主机名修改此映射 !!
    hostTypes = {
      # 示例：假设您原来的主机叫 'my-desktop'
      "desktop" = "desktop"; 
      "laptop" = "desktop";
      
      # 新的服务器
      "server" = "server"; 
      
      # 如果您有更多主机，请在这里添加
    };


    hostConfigs = nixpkgs.lib.mapAttrs' (name: type: {
      name = name;
      # 模块列表：
      value.modules = globalCommonModules                             # 始终加载全局模块
                      ++ (if type == "desktop" then desktopModules else [ ]) # 如果是桌面，加载桌面模块
                      ++ [ (./hosts + "/${name}/configuration.nix") ]; # 加载主机特定配置
    }) hostTypes;

    nixosConfigurations = nixpkgs.lib.mapAttrs (name: hostAttrs:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = hostAttrs.modules;
        specialArgs = { inherit inputs niri; };
      }
    ) hostConfigs;

  in {
    inherit nixosConfigurations;
  };
}
