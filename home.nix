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
    inputs.zen-browser.homeModules.beta
  ];

  # The 'pkgs' here includes 'niri-unstable' thanks to the global overlay.
  home.packages = with pkgs; [
    htop
    devenv
    qt6Packages.qt6ct
    firefox
    telegram-desktop
    # 1. ADD RUST-ANALYZER HERE
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

  # 2. Add Cargo configuration to ensure rust-src component is available (Crucial for NixOS)

  programs.dankMaterialShell.enable = true;
  programs.zen-browser.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };

    # 3. ADD RUST LANGUAGE CONFIGURATION HERE
    languages.language = [
      # Existing Nix config
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
      # New Rust config
      {
        name = "rust";
        auto-format = true;
        language-servers = [ "rust-analyzer" ];
      }
    ];

    # 4. Configure the language server (optional, but good practice)
    languages.language-server.rust-analyzer.config = {
      # This tells rust-analyzer to run clippy instead of cargo check on save
      checkOnSave.command = "clippy";
    };

    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  home.stateVersion = "23.11";
}
