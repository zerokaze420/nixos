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
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    htop
    devenv
    qt6Packages.qt6ct
    firefox
    telegram-desktop
    rust-analyzer
    google-chrome
    alacritty
    helix
    youtube-music
    qq
    nodejs
    wpsoffice
    bun
    grim
    remmina
    slurp
    wl-clipboard
    gemini-cli
    (feishu.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
      ];
    })
  ];


  programs.dankMaterialShell.enable = true;
  programs.zen-browser.enable = true;


  home.stateVersion = "23.11";
}
