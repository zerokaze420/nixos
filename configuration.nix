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
    systemd-boot.enable = true;
    # 如果你的系统是 UEFI 并且你想要 systemd-boot 能够管理 EFI 引导项，请启用此项。
    # NixOS 通常会自动检测并安装 systemd-boot 到 EFI 系统分区 (ESP)。
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages =  pkgs.linuxPackages_zen;
  services.xserver.xkb.layout = "us";
  services.xserver.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

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
    wget
    neovim
    vscode
    kitty
    fastfetch
    firefox
    yazi
    gimp
    copyq
    cliphist
    lm_sensors
    alacritty
    fuzzel
    nodejs
    git
    btop
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
  programs.niri = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
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
