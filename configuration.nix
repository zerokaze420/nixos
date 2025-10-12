{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages =  pkgs.linuxPackages_zen;
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

    # Optional helps save long term battery health
    START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
    STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging
   };
  };
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
    swww
    wget
    aria2
    neovim
    usbutils
    kitty
    feishu
    fastfetch
    copyq
    cliphist
    alacritty
    fuzzel
    nodejs
    android-tools
    git
    btop
    waybar
    dunst
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
  };
  programs.niri = {
    enable = true;
  };
  programs.fish.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable TPM emulation (optional)
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
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
