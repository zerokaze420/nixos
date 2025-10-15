
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
    neovide
    firefox
    telegram-desktop
    chatbox
    rustup
    youtube-music
    grim
    slurp
    wl-clipboard
       ((feishu.override (previous: {
        commandLineArgs = (previous.commandLineArgs or "") +
          " --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=x11 --enable-wayland-ime";
      })).overrideAttrs (previous: {
        installPhase = previous.installPhase + ''

          sed -i "s/export XDG_DATA_DIRS/export XDG_DATA_DIRS; GTK_IM_MODULE=; export GTK_IM_MODULE/" $out/opt/bytedance/feishu/feishu
        '';
      }))
  ];
  programs.dankMaterialShell.enable = true;



  home.stateVersion = "23.11";
}
