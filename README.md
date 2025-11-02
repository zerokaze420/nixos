# NixOS Configuration

<p align="center">
  <a href="https://nixos.org/">
    <img src="https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&logo=NixOS" alt="NixOS">
  </a>
</p>

This repository contains my personal NixOS configuration, managed with Nix Flakes.

## Folder Structure

- **`flake.nix`**: The entry point for the NixOS configuration.
- **`hosts`**: Contains the NixOS configuration for each host.
  - **`desktop`**: The configuration for my desktop.
  - **`laptop`**: The configuration for my laptop.
- **`modules`**: Contains the NixOS modules that are shared across hosts.
- **`home.nix`**: The entry point for my home-manager configuration.
- **`homeModules`**: Contains the home-manager modules that are shared across users.

## How to Use

To apply the configuration to a host, run the following command:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

For example, to apply the configuration to my laptop, I would run:

```bash
sudo nixos-rebuild switch --flake .#laptop
```

To apply the configuration to my server, I would run:

```bash
sudo nixos-rebuild switch --flake .#server --impure
```


## Tree

```
.
├── config
│   └── niri
│       ├── config.kdl
│       └── dms
│           ├── binds.kdl
│           ├── colors.kdl
│           └── layout.kdl
├── flake.lock
├── flake.nix
├── homeModules
│   ├── desktop
│   │   └── kitty.nix
│   ├── git.nix
│   ├── shell
│   │   ├── fish.nix
│   │   └── starship.nix
│   └── vscode.nix
├── home.nix
├── hosts
│   ├── desktop
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── Modules
│   ├── nh.nix
│   ├── nvf.nix
│   ├── services
│   │   ├── dae.nix
│   │   └── ssh.nix
│   └── user
│       └── tux.nix
└── README.md
```