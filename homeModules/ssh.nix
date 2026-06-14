{ ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git

      Host lzcos.heiyu.space
        Port 144
        User tux
    '';
  };
  home.file.".ssh/config".force = true;
}
