{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu
    libvirt
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ];
  };
  programs.virt-manager.enable = true;

  # Enable TPM emulation (optional)
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
  };
  users.groups.libvirtd.members = ["alice"];

  # Enable USB redirection (optional)
  virtualisation.spiceUSBRedirection.enable = true;
}
