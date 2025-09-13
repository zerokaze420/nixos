# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
    boot.loader = {
    system.enable = true; # 确保 systemd-boot 被启用
    system.efiSupport = true; # 如果是 EFI 系统
  };

  services.xserver.xkb.layout = "us";
  services.xserver.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  services.xserver.displayManager.gdm.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    font-awesome
  ];

  environment.systemPackages = with pkgs; [
    mpd
    ncmpcpp
    dae
    cava
    hyprshot
    wget
    neovim
    kitty
    fastfetch
    firefox
    yazi
    gimp
    wofi
    copyq
    cliphist
    lm_sensors
    alacritty
    fuzzel
    nodejs
    git
    btop
    cpeditor
    waybar
    dunst
    qemu
    libvirt
    virt-manager
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
  };
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };
  programs.fish.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable TPM emulation (optional)
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
    ovmf.packages = [pkgs.OVMFFull.fd];
  };

  # Enable USB redirection (optional)
  virtualisation.spiceUSBRedirection.enable = true;
  i18n.inputMethod.fcitx5.waylandFrontend = true;
  programs.nix-ld.enable = true;


  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Shanghai";


  i18n.defaultLocale = "zh_CN.UTF-8";


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
