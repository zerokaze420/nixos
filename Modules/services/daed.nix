{
  config,
  pkgs,
  ...
}: {
  services.daed = {
    enable = false;
    configFile = "/home/tux/config/dae/config.dae";
  };
}
