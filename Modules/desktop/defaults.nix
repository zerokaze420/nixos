{ config, pkgs, ... }:
{
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
    tmux
    starship
    bun
    direnv
  ];
}
