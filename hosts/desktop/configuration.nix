{
  config,
  lib,
  pkgs,
  inputs,
  niri,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.niri.nixosModules.niri
    ./../../Modules/desktop/fonts.nix
    ./../../Modules/environment.nix
    ./../../Modules/services/tlp.nix
    ./../../Modules/services/virt.nix
    ./../../Modules/services/pipewire.nix
    ./../../Modules/desktop/defaults.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  niri-flake.cache.enable = true;
  services.thermald.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  qt.enable = true;

  programs.fish.enable = true;
  programs.niri = {
    enable = true;
  };

  #i18n.inputMethod.fcitx5.waylandFrontend = true;
  i18n.inputMethod = {
     type = "fcitx5";
     enable = true;
     fcitx5.addons = with pkgs; [
       fcitx5-gtk             # alternatively, kdePackages.fcitx5-qt
       qt6Packages.fcitx5-chinese-addons
       fcitx5-nord            # a color theme
     ];
   };
  programs.nix-ld.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
