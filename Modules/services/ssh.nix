{ config, pkgs, ... }:
{
	services.openssh = {
		enable = true;
		ports = [ 22 ];
		settings = {
			PasswordAuthentication = true;
			AllowUsers = [ "Zerokaze"  "root" "tux"];
			UseDns = true;
			X11Forwarding = false;
			PermitRootLogin = "yes";
		};
	} ; 
}
