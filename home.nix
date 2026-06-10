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
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
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

  programs.dankMaterialShell.enable = true;

  home.stateVersion = "23.11";
}
