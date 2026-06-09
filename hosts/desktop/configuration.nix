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
  programs.niri = {
    enable = true;
    settings.layout.border.enable = false;
  };
  niri-flake.cache.enable = true;

  # ── KDE Plasma 6 Desktop ──
  services.desktopManager.plasma6.enable = true;
  # SDDM is replaced by DankGreeter below
  # services.displayManager.sddm.enable = true;

  # ── DankGreeter (greetd-based login) ──
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # ── Base system ──
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.thermald.enable = true;

  qt.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # ── Input method ──
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
      fcitx5-nord
    ];
  };

  # ── Networking ──
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Locale ──
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Nix ──
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
