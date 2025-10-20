{ pkgs, ... }:
{

 programs.vscode = {
  enable = true;
  profiles.default.extensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    vscodevim.vim
    yzhang.markdown-all-in-one
  ];
};
}
