{ inputs, pkgs, ... }:

{
  home.username = "tux";
  home.homeDirectory = "/home/tux";

  imports = [
    ./homeModules/git.nix
    ./homeModules/shell/fish.nix
    ./homeModules/vscode.nix
    ./homeModules/shell/starship.nix
    ./homeModules/desktop/kitty.nix
    ./homeModules/desktop/helix.nix
    ./homeModules/desktop/hyprland.nix
    ./homeModules/desktop/niri.nix
    ./homeModules/desktop/plasma.nix
  ];

  home.packages = with pkgs; [
    htop
    devenv
    qt6Packages.qt6ct
    docker
    yazi
    firefox
    rust-analyzer
    alacritty
    openssl
    helix
    pear-desktop
    podman
    gnumake
    cargo
    splayer
    nodejs
    bun
    grim
    remmina
    slurp
    wl-clipboard
    gemini-cli
  ];

  home.stateVersion = "23.11";
}
