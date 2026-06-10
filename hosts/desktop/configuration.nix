{ config, lib, pkgs, inputs, niri, hyprland, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../Modules/desktop/fonts.nix
    ./../../Modules/environment.nix
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

  # ── Compositors: Hyprland + Niri ──
  programs.hyprland.enable = true;
  programs.niri.enable = true;
  niri-flake.cache.enable = true;

  # ── DankGreeter (greetd-based Wayland greeter) ──
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # ── Base system ──
  console.keyMap = "us";
  services.thermald.enable = true;

  qt.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # ── Locale ──
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];

  # ── Input method ──
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
      fcitx5-nord
    ];
  };

  # ── Networking ──
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Time ──
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Nix ──
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
