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
    ./../../Modules/fonts.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  niri-flake.cache.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  services.xserver.xkb.layout = "us";
  services.xserver.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    mpd
    ncmpcpp
    dae
    swww
    wget
    aria2
    neovim
    usbutils
    fastfetch
    copyq
    cliphist
    fuzzel
    nodejs
    android-tools
    btop
    qemu
    libvirt
    virt-manager
    tmux
    starship
    bun
    direnv
  ];
  qt.enable = true;

  environment.sessionVariables = {
    QT_SCALE_FACTOR = "1.5";
    QT_QPA_PLATFORM = "wayland";
    GOOGLE_CLOUD_PROJECT = "740117566518";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = "1";
  };
  programs.fish.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ]; 
  };
  programs.virt-manager.enable = true;
  programs.niri = {
    enable = true;
  };


  # Enable TPM emulation (optional)
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
  };
  users.groups.libvirtd.members = ["alice"];

  # Enable USB redirection (optional)
  virtualisation.spiceUSBRedirection.enable = true;
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

  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
