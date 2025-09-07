# flake.nix

My Nixos Configuration

## How to Use

```nix
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
sudo nixos-rebuild switch --flake .
```