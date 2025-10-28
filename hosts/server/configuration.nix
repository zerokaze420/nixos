{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda"; 

  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;  

  time.timeZone = "Asia/Shanghai";

   environment.systemPackages = with pkgs; [
     vim 
     wget
     fish
     git
     fastfetch
     tmux
     btop
  ];

   services.openssh.enable = true;
   services.openssh.settings.PermitRootLogin = "yes";

  system.stateVersion = "25.05"; 

}

