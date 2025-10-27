# NixOS Configuration

This repository contains my personal NixOS configuration, managed with Nix Flakes.

## Folder Structure

* **flake.nix**: The entry point for the NixOS configuration.
* **hosts**: Contains the NixOS configuration for each host.
    * **laptop**: The configuration for my laptop.
* **modules**: Contains the NixOS modules that are shared across hosts.
* **home.nix**: The entry point for my home-manager configuration.
* **homeModules**: Contains the home-manager modules that are shared across users.

## How to Use

To apply the configuration to a host, run the following command:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

For example, to apply the configuration to my laptop, I would run:

```bash
sudo nixos-rebuild switch --flake .#laptop
```