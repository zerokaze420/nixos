{ config, pkgs, hyprlandConf, ... }:

{
  xdg.configFile."hypr/hyprland.conf" = {
    source = hyprlandConf;
    force = true;
  };
}
