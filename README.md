<p align="center">
  <img alt="sennery dotfiles" src="/docs/readme-img.png" />
</p>

This is a repository for my **configuration files**.

## Installing script

This script will install neccessary packages for development and environment setup.

There are scripts for different operating systems:

### Fedora

```sh
./install_fedora.sh
```

### macOS

> [!IMPORTANT]
> You need to install [Homebrew](https://brew.sh/) first.

```sh
./install_macos.sh
```

Each script could be run with `--dry` flag to see what commands will be executed without actully running them:

```sh
./install_macos.sh --dry
```
Also you can run each script with `-i` flag to run it interactively:

```sh
./install_macos.sh -i
```

Or you can pass the neccessary package names as arguments to install only them:

```sh
./install_macos.sh nvim fnm
```

## Setup script

> [!WARNING]
> The script will create symlinks to this directory instead of existing configuration files. Existing files will be copied with the `.backup` prefix.

This script will setup environment for development:

```sh
./setup.sh
```
