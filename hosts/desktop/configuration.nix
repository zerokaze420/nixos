{ config, lib, pkgs, inputs, hyprland, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../Modules/desktop/fonts.nix
    ./../../Modules/services/virt.nix
    ./../../Modules/services/pipewire.nix
    ./../../Modules/desktop/defaults.nix
    ./../../Modules/services/docker.nix
  ];

  # ── Boot ──
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ── Intel Arc GPU (DG2 / Alchemist) ──
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime
    vpl-gpu-rt
  ];

  # ── KDE Plasma 6 (Wayland) ──
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "hyprland";
  services.desktopManager.plasma6.enable = true;

  # ── Hyprland ──
  programs.hyprland.enable = true;

  # ── Niri ──
  programs.niri.enable = true;
  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  # ── Base system ──
  console.keyMap = "us";
  services.thermald.enable = true;

  qt.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # ── Networking ──
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.defaultGateway = {
    address = "192.168.5.8";
    interface = "enp5s0";
  };
  networking.defaultGateway6 = "";

  # ── Nix ──
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
