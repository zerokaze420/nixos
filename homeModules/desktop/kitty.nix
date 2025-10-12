{config, pkgs,...}:
{
    programs.kitty = {
    enable = true;
    fontSize = 14.0;
    fonts = with pkgs; [
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        font-awesome
    ];
    }
}