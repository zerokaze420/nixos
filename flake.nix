{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
      minesddm = {
      url = "github:Davi-S/sddm-theme-minesddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    home-manager,
    minesddm,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./Modules/services/ssh.nix
        ./Modules/services/dae.nix
        ./Modules/user/tux.nix
        ./Modules/inputMethod.nix
        ./Modules/nh.nix
        ./Modules/nvf.nix
        # ./Modules/nvf/configuration.nix
        nvf.nixosModules.default
        minesddm.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # 用户配置必须以「模块的集合」(Attribute Set)形式定义
            users.tux = {
              imports = [
                nvf.homeManagerModules.default
                ./home.nix # 确保此文件返回 attribute set
                # 正确注入 nixvim 的模块
              ];
            };
          };
        }
      ];
    };
  };
}
