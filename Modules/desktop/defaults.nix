{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpd
    ncmpcpp
    dae
    awww
    wget
    aria2
    wechat
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
    clash-verge-rev
    opencode
    bun
    direnv
  ];
}
