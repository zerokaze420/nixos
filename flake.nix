{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
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
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # 用户配置必须以「模块的集合」(Attribute Set)形式定义
            users.tux = {
              imports = [
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
