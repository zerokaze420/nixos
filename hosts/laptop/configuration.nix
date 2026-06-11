{ config, lib, pkgs, inputs, hyprland, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../Modules/desktop/fonts.nix
    ./../../Modules/services/pipewire.nix
    ./../../Modules/services/tlp.nix
    ./../../Modules/services/virt.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.power-profiles-daemon.enable = false;

  # ── KDE Plasma 6 (Wayland) ──
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "hyprland";
  services.desktopManager.plasma6.enable = true;

  # ── Hyprland ──
  programs.hyprland.enable = true;

  console.keyMap = "us";
  services.thermald.enable = true;

  qt.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    waybar
    dunst
    git
  ];

  system.stateVersion = "24.11";
}
