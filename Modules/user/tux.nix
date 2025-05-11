{config, pkgs, ...}:
{
 users.users.tux = {
		isNormalUser = true;
		description = "tux";
		extraGroups = [ "wheel" "libvirtd"]; # Sudo access
			shell = pkgs.fish;
		home = "/home/tux";
	};
}