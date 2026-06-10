{ pkgs, niriConf, ... }:

{
  xdg.configFile."niri/config.kdl".source = niriConf;
}
