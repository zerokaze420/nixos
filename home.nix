{ config, pkgs, ... }:
{
  home.username = "tux";
  home.homeDirectory = "/home/tux";
  
  imports = [ 
    ./homeModules/git.nix
    ./homeModules/shell/fish.nix
    ./homeModules/vscode.nix
    ./homeModules/shell/starship.nix    
    ./homeModules/desktop/kitty.nix
   ];
  # 安装用户级软件包
  home.packages = with pkgs; [
    htop
    neovide
    firefox
    telegram-desktop
  ];

  # 配置程序



  # 管理 dotfiles

  # 设置 Home Manager 的版本
  home.stateVersion = "23.11";
}
