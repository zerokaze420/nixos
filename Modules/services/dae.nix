{
  config,
  pkgs,
  ...
}: {
  services.dae = {
    enable = true;
    configFile = "/home/tux/config/dae/config.dae";
  };
}
