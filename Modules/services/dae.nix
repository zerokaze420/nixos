{ config, pkgs, lib, ... }:
{
  services.dae = {
    enable = false;
    configFile = "/home/tux/config/dae/config.dae";
  };
}
