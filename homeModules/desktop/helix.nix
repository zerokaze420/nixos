{ ... }:
{
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
}