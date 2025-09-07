# flake.nix


我的的NIXOS 配置 


## 如何使用

```nix
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
sudo nixos-rebuild switch --flake .
```