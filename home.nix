
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
  ];

  # The 'pkgs' here includes 'niri-unstable' thanks to the global overlay.
  home.packages = with pkgs; [
    htop
    firefox
    telegram-desktop
    rustup
    youtube-music
    nodejs
    bun
    grim
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



  home.stateVersion = "23.11";
}
