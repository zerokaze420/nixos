{ config, pkgs, ... }:
{
  home.username = "tux";
  home.homeDirectory = "/home/tux";
  
  imports = [ 
    ./homeModules/git.nix
    ./homeModules/nvf.nix
    ./homeModules/shell/fish.nix
    ./homeModules/shell/starship.nix    
   ];
  # 安装用户级软件包
  home.packages = with pkgs; [
    htop
    # neovim
    neovide
  ];

  # 配置程序



  # 管理 dotfiles

  # 设置 Home Manager 的版本
  home.stateVersion = "23.11";
}
