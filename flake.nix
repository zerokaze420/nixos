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
    #    这些模块将应用于所有主机。
    commonModules = [
      ./configuration.nix        # 基础公共配置
      ./Modules/services/ssh.nix
      ./Modules/services/dae.nix
      ./Modules/user/tux.nix     # 如果 'tux' 用户在所有主机上都有
      ./Modules/nh.nix
      
      # Niri 覆盖层 (Overlay)
      {
        nixpkgs.overlays = [
          niri.overlays.niri 
        ];
      }
      
      # Home Manager 模块 (所有主机都启用 Home Manager)
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true; 
          useUserPackages = true;
          # 将 'tux' 用户的 Home Manager 配置放在公共模块中，
          # 假设该用户和他的大部分配置对所有主机都是通用的。
          users.tux = { 
            imports = [
              ./home.nix 
              inputs.dankMaterialShell.homeModules.dankMaterialShell.default
              inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
            ]; 
          };
          extraSpecialArgs = { inherit inputs; }; # 传递 inputs 给 home-manager
        };
      }
    ];

    # 3. 读取主机配置目录
    #    假设您的主机配置位于 ./hosts 目录下的子文件夹中，
    #    例如：./hosts/desktop/default.nix 或 ./hosts/laptop/configuration.nix
    #    我们使用 `lib.mapAttrs'` 和 `lib.readDir` 遍历 hosts 目录下的所有子目录。
    #    这里的假设是：每个主机目录（如 'desktop'）都包含一个名为 'configuration.nix' 的文件。
    hostConfigs = nixpkgs.lib.mapAttrs' (name: _: {
      name = name;
      # 导入每个主机目录下的 configuration.nix 文件。
      value = { modules = [ (./hosts + "/${name}/configuration.nix") ]; };
    }) (nixpkgs.lib.readDir ./hosts);

    # 4. 动态生成 nixosConfigurations
    #    遍历 hostConfigs，为每个主机生成一个完整的 NixOS 配置。
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
