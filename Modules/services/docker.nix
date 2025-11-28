{ config , pkgs, ... }:
{
  virtualisation.docker.enable = true;
  users.users.tux.extraGroups = [ "docker" ];

}