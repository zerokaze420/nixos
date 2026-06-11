# NixOS 配置

这是个人使用的 NixOS Flake 配置仓库，覆盖桌面、笔记本和服务器三类主机。

## 当前主机

| Flake 输出 | 配置目录 | 主机名 | 说明 |
| --- | --- | --- | --- |
| `nixos` | `hosts/desktop` | `nixos` | 默认桌面机别名 |
| `desktop` | `hosts/desktop` | `nixos` | 桌面机 |
| `laptop` | `hosts/laptop` | `laptop` | 笔记本 |
| `server` | `hosts/server` | `server` | 服务器 |

## 目录结构

- `flake.nix`：Flake 入口，定义 `nixosConfigurations` 和共享模块。
- `flake.lock`：锁定 nixpkgs、home-manager、Hyprland、plasma-manager 等输入版本。
- `hosts/`：各主机的系统配置和硬件配置。
- `Modules/`：NixOS 共享模块，包括用户、桌面、服务和系统工具配置。
- `home.nix`：home-manager 入口，绑定用户 `tux` 的 Home 配置。
- `homeModules/`：home-manager 模块，包括 Git、Shell、编辑器和桌面环境配置。
- `config/`：Hyprland、Niri 等外部配置文件。

## 使用方式

先检查 Flake 是否能正常求值：

```bash
nix flake check --show-trace
```

切换当前机器配置：

```bash
sudo nixos-rebuild switch --flake .#<主机>
```

示例：

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild switch --flake .#laptop
sudo nixos-rebuild switch --flake .#server
```

如果使用 `nh`，默认 Flake 路径已配置为：

```text
/home/tux/code/nixos
```

因此可以在任意目录执行：

```bash
nh os switch
```

## 桌面环境

桌面类主机默认包含：

- KDE Plasma 6。
- Hyprland。
- Niri。
- home-manager 用户环境。
- fcitx5 中文输入法。
- PipeWire 音频。

桌面主机的默认登录会话当前设置为 `hyprland`。

## 服务与工具

共享模块中启用了：

- OpenSSH。
- nh 自动清理。

桌面类主机额外启用了 dae、home-manager、KDE Plasma、Hyprland、Niri、fcitx5 和常用桌面环境变量。

桌面机额外启用了 Docker、libvirt、PipeWire、字体和常用桌面工具；笔记本额外启用了 TLP；服务器使用 GRUB 并包含基础命令行工具。

## 维护建议

- 修改硬件相关配置前，先确认对应 `hosts/<主机>/hardware-configuration.nix`。
- 添加新主机时，在 `hosts/` 下新增目录，并同步更新 `flake.nix` 的 `hostDefs`。
- 更新输入版本后先运行 `nix flake check --show-trace`，再执行 `nixos-rebuild switch`。
