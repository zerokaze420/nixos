{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      iconTheme = "Papirus-Dark";
      cursor.theme = "Bibata-Modern-Ice";
      cursor.size = 24;
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    shortcuts = {
      ksmserver = {
        "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
      };
      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };

    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
    };

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      kwinrc.Desktops.Number = {
        value = 4;
        immutable = true;
      };
    };
  };
}
