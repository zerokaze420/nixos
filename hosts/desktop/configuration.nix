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
  programs.ssh.knownHosts = {
    "lzcos.heiyu.space" = {
      hostNames = [ "lzcos.heiyu.space" "[lzcos.heiyu.space]" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2lNS/7bNz4rRTtAXUrIYv3eLgd7ZPAhD+HHhNx7uIN";
    };
  };
  programs.ssh.extraConfig = ''
    Host lzcos.heiyu.space
      Port 144
  '';
  systemd.services.fix-gw = {
    description = "Route default gateway via 192.168.5.8";
    after = [ "NetworkManager.service" "network-online.target" ];
    requires = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/ip route replace default via 192.168.5.8";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # ── Nix ──
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # ── Remote Builder ──
  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "lzcos.heiyu.space";
    system = "x86_64-linux";
    maxJobs = 4;
    speedFactor = 2;
    sshUser = "tux";
    supportedFeatures = [ "kvm" "big-parallel" ];
  }];
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nixpkgs.config.allowUnfree = true;

  services.lazycat-cloud-client = {
    enable = true;
  };

  system.stateVersion = "24.11";
}

