{ config, lib, pkgs, inputs, niri, hyprland, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../Modules/desktop/fonts.nix
    ./../../Modules/environment.nix
    ./../../Modules/services/pipewire.nix
    ./../../Modules/services/tlp.nix
    ./../../Modules/services/virt.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ── Compositors ──
  programs.hyprland.enable = true;
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.system}.niri-unstable;
  };
  niri-flake.cache.enable = true;

  # ── KDE Plasma 6 ──
  services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.enable = true;

  # ── DankGreeter ──
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.thermald.enable = true;

  qt.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  i18n.inputMethod.fcitx5.waylandFrontend = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

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
