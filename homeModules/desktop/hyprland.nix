{ config, pkgs, hyprlandConf, ... }:

{
  xdg.configFile."hypr/hyprland.lua".source = hyprlandConf;
  xdg.configFile."hypr/hyprland.conf".text = "source = ~/.config/hypr/hyprland.lua";
}
